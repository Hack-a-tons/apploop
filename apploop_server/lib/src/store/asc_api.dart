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

  void close() => _http.close();
}
