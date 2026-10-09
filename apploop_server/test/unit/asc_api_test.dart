import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'package:apploop_server/src/store/asc_api.dart';

/// Mock App Store Connect: [takenBundles] are registered bundle ids,
/// [takenApps] are bundle ids that already have an app record.
AppStoreConnectApi _mockApi({
  Set<String> takenBundles = const {},
  Set<String> takenApps = const {},
}) {
  String identifierOf(Uri url) =>
      url.queryParametersAll['filter[identifier]']?.first ??
      url.queryParametersAll['filter[bundleId]']?.first ??
      '';
  return AppStoreConnectApi(
    const AppleCredentials(keyId: 'k', issuerId: 'i', privateKey: 'p'),
    MockClient((request) async {
      final id = identifierOf(request.url);
      if (request.url.path == '/v1/bundleIds') {
        final taken = takenBundles.contains(id);
        return http.Response(
          jsonEncode({
            'data': taken
                ? [
                    {'id': 'res-$id'},
                  ]
                : [],
          }),
          200,
        );
      }
      final taken = takenApps.contains(id);
      return http.Response(
        jsonEncode({
          'data': taken
              ? [
                  {'id': 'app-$id'},
                ]
              : [],
        }),
        200,
      );
    }),
    'test-token',
  );
}

void main() {
  group('uniqueBundleId', () {
    test('returns the base id when everything is free', () async {
      final api = _mockApi();
      expect(
        await uniqueBundleId(api, 'com.hurated.loop.my_app'),
        'com.hurated.loop.my_app',
      );
    });

    test('bumps past taken bundle ids and app records', () async {
      final api = _mockApi(
        takenBundles: {'com.hurated.loop.my_app'},
        takenApps: {'com.hurated.loop.my_app-2'},
      );
      expect(
        await uniqueBundleId(api, 'com.hurated.loop.my_app'),
        'com.hurated.loop.my_app-3',
      );
    });

    test('continues counting from an already-suffixed base', () async {
      final api = _mockApi(
        takenBundles: {
          'com.hurated.loop.my_app-2',
          'com.hurated.loop.my_app-3',
        },
      );
      expect(
        await uniqueBundleId(api, 'com.hurated.loop.my_app-2'),
        'com.hurated.loop.my_app-4',
      );
    });
  });
}
