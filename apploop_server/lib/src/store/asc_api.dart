import 'dart:async';
import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

/// Apple App Store Connect credentials. Values come from
/// `config/passwords.yaml` (git-ignored) or process environment — never
/// from code, never from the client. Only names are documented here.
class AppleCredentials {
  final String keyId;
  final String issuerId;
  final String privateKey;

  const AppleCredentials({
    required this.keyId,
    required this.issuerId,
    required this.privateKey,
  });

  bool get isConfigured =>
      keyId.isNotEmpty && issuerId.isNotEmpty && privateKey.isNotEmpty;

  /// Reads `ascKeyId` / `ascIssuerId` / `ascPrivateKey` for the current run
  /// mode. Same key as the author's PlantIdentify pipeline.
  static AppleCredentials fromPasswords(Map<String, String> passwords) {
    return AppleCredentials(
      keyId: passwords['ascKeyId'] ?? '',
      issuerId: passwords['ascIssuerId'] ?? '',
      privateKey: passwords['ascPrivateKey'] ?? '',
    );
  }
}

/// One TestFlight build as reported by App Store Connect.
class TestflightBuildInfo {
  /// Marketing version, e.g. 1.0.
  final String marketingVersion;

  /// Build number (CFBundleVersion), e.g. 42.
  final int buildNumber;

  /// Apple's processing state, e.g. PROCESSING, READY.
  final String processingState;

  final bool expired;

  const TestflightBuildInfo({
    required this.marketingVersion,
    required this.buildNumber,
    required this.processingState,
    required this.expired,
  });
}

/// Minimal App Store Connect API client: just enough to register a bundle
/// id and create an app record. Docs:
/// https://developer.apple.com/documentation/appstoreconnectapi
class AppStoreConnectApi {
  static const _base = 'https://api.appstoreconnect.apple.com';
  static const _timeout = Duration(seconds: 30);

  final AppleCredentials _creds;
  final http.Client _http;

  String? _token;
  DateTime? _tokenExpiry;

  AppStoreConnectApi(this._creds, [http.Client? httpClient])
    : _http = httpClient ?? http.Client();

  /// ES256-signed JWT for the API (same shape as fastlane's api_key).
  /// Tokens live 15 minutes; cached until a minute before expiry.
  String _bearerToken() {
    final now = DateTime.now().toUtc();
    if (_token != null &&
        _tokenExpiry != null &&
        now.isBefore(_tokenExpiry!.subtract(const Duration(minutes: 1)))) {
      return _token!;
    }
    final jwt = JWT(
      {},
      issuer: _creds.issuerId,
      audience: Audience.one('appstoreconnect-v1'),
      header: {'kid': _creds.keyId},
    );
    _token = jwt.sign(
      ECPrivateKey(_creds.privateKey),
      algorithm: JWTAlgorithm.ES256,
      expiresIn: const Duration(minutes: 15),
    );
    _tokenExpiry = now.add(const Duration(minutes: 15));
    return _token!;
  }

  Future<http.Response> _get(Uri url) {
    return _http
        .get(url, headers: {'Authorization': 'Bearer ${_bearerToken()}'})
        .timeout(_timeout);
  }

  Future<http.Response> _post(Uri url, Map<String, dynamic> body) {
    return _http
        .post(
          url,
          headers: {
            'Authorization': 'Bearer ${_bearerToken()}',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(_timeout);
  }

  /// Returns the bundle-id resource id when `identifier` is registered,
  /// else null. Never throws for "not found".
  Future<String?> findBundleId(String identifier) async {
    final url = Uri.parse(
      '$_base/v1/bundleIds?filter[identifier]=$identifier&limit=1',
    );
    final response = await _get(url);
    if (response.statusCode != 200) {
      throw StateError(
        'App Store Connect error ${response.statusCode}: ${response.body}',
      );
    }
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    if (data is List && data.isNotEmpty) {
      return (data.first as Map<String, dynamic>)['id'] as String?;
    }
    return null;
  }

  /// Registers an iOS bundle id. Returns the resource id.
  Future<String> registerBundleId({
    required String identifier,
    required String name,
  }) async {
    final response = await _post(Uri.parse('$_base/v1/bundleIds'), {
      'data': {
        'type': 'bundleIds',
        'attributes': {
          'identifier': identifier,
          'name': name,
          'platform': 'IOS',
        },
      },
    });
    if (response.statusCode != 201) {
      throw StateError(
        'Could not register bundle id $identifier: '
        '${response.statusCode} ${response.body}',
      );
    }
    return (jsonDecode(response.body) as Map<String, dynamic>)['data']['id']
        as String;
  }

  /// Returns `{'id': ..., 'bundleId': ...}` when an app with this bundle id
  /// exists, else null.
  Future<Map<String, String>?> findAppByBundleId(String bundleId) async {
    final url = Uri.parse(
      '$_base/v1/apps?filter[bundleId]=$bundleId&limit=1',
    );
    final response = await _get(url);
    if (response.statusCode != 200) {
      throw StateError(
        'App Store Connect error ${response.statusCode}: ${response.body}',
      );
    }
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'];
    if (data is List && data.isNotEmpty) {
      final app = data.first as Map<String, dynamic>;
      return {
        'id': app['id'] as String,
        'bundleId': bundleId,
      };
    }
    return null;
  }

  /// Creates the app record. Returns the App Store Connect app id.
  Future<String> createApp({
    required String bundleIdResourceId,
    required String name,
    required String sku,
    String primaryLocale = 'en-US',
  }) async {
    final response = await _post(Uri.parse('$_base/v1/apps'), {
      'data': {
        'type': 'apps',
        'attributes': {
          'name': name,
          'primaryLocale': primaryLocale,
          'sku': sku,
        },
        'relationships': {
          'bundleId': {
            'data': {'type': 'bundleIds', 'id': bundleIdResourceId},
          },
        },
      },
    });
    if (response.statusCode != 201) {
      throw StateError(
        'Could not create app "$name": '
        '${response.statusCode} ${response.body}',
      );
    }
    return (jsonDecode(response.body) as Map<String, dynamic>)['data']['id']
        as String;
  }

  /// TestFlight builds of an app (all versions), newest upload first.
  Future<List<TestflightBuildInfo>> listBuilds(String appId) async {
    final url = Uri.parse(
      '$_base/v1/apps/$appId/builds'
      '?include=preReleaseVersion&limit=200',
    );
    final response = await _get(url);
    if (response.statusCode != 200) {
      throw StateError(
        'App Store Connect error ${response.statusCode}: ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final versions = <String, String>{};
    for (final item in (body['included'] as List? ?? [])) {
      final entry = item as Map<String, dynamic>;
      if (entry['type'] == 'preReleaseVersions') {
        versions[entry['id'] as String] =
            (entry['attributes'] as Map<String, dynamic>)['version'] as String;
      }
    }
    final builds = <TestflightBuildInfo>[];
    for (final item in (body['data'] as List? ?? [])) {
      final entry = item as Map<String, dynamic>;
      final attributes = entry['attributes'] as Map<String, dynamic>;
      final versionId =
          (entry['relationships']
                  as Map<
                    String,
                    dynamic
                  >?)?['preReleaseVersion']?['data']?['id']
              as String?;
      builds.add(
        TestflightBuildInfo(
          marketingVersion: versions[versionId] ?? '',
          buildNumber:
              int.tryParse(attributes['version'] as String? ?? '') ?? 0,
          processingState: attributes['processingState'] as String? ?? '',
          expired: attributes['expired'] as bool? ?? false,
        ),
      );
    }
    return builds;
  }

  /// Next free TestFlight build number: max across all versions + 1.
  Future<int> nextBuildNumber(String appId) async {
    final builds = await listBuilds(appId);
    var latest = 0;
    for (final build in builds) {
      if (build.buildNumber > latest) latest = build.buildNumber;
    }
    return latest + 1;
  }

  void close() => _http.close();
}
