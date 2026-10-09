import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'package:apploop_server/src/generated/protocol.dart';
import 'package:apploop_server/src/store/provision_app_call.dart';

import 'test_tools/serverpod_test_tools.dart';

const _userA = '00000000-0000-4000-8000-000000000001';
const _userB = '00000000-0000-4000-8000-000000000002';

TestSessionBuilder _asUser(TestSessionBuilder builder, String userId) {
  return builder.copyWith(
    authentication: AuthenticationOverride.authenticationInfo(
      userId,
      const <Scope>{},
    ),
  );
}

Future<void> _seedUser(TestSessionBuilder builder, String userId) async {
  await AuthUser.db.insertRow(
    builder.build(),
    AuthUser(id: UuidValue.fromString(userId), scopeNames: const {}),
  );
}

void main() {
  withServerpod('Given StoreApp endpoint', (sessionBuilder, endpoints) {
    test(
      'when requesting an app then a pending record with a slug bundle id is created',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(
          builderA,
          'Plant Identifier!',
          '',
        );

        final app = await endpoints.storeApp.requestApp(builderA, wish.id!);

        expect(app.bundleId, 'com.hurated.apploop.plant_identifier');
        expect(app.sku, app.bundleId);
        expect(app.status, isIn(['pending', 'creating', 'failed']));
        expect(app.ascAppId, isEmpty);

        final wishNow = (await endpoints.wish.listMyWishes(builderA)).first;
        expect(wishNow.status, isNot('draft'));
      },
    );

    test(
      'when requesting twice then the same record is returned',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Same App', '');

        final first = await endpoints.storeApp.requestApp(builderA, wish.id!);
        final second = await endpoints.storeApp.requestApp(builderA, wish.id!);

        expect(second.id, first.id);
        final all = await endpoints.storeApp.getStoreAppForWish(
          builderA,
          wish.id!,
        );
        expect(all?.id, first.id);
      },
    );

    test(
      'when requesting for another users wish then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(
          _asUser(sessionBuilder, _userA),
          'User A wish',
          '',
        );
        await expectLater(
          endpoints.storeApp.requestApp(
            _asUser(sessionBuilder, _userB),
            wish.id!,
          ),
          throwsStateError,
        );
      },
    );

    test(
      'when provisioning without Apple credentials then it fails gracefully',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(
          builderA,
          'No Creds App',
          '',
        );
        // Insert directly to avoid the auto-scheduled twin call racing us.
        final app = await StoreApp.db.insertRow(
          builderA.build(),
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.apploop.no_creds_app',
            sku: 'com.hurated.apploop.no_creds_app',
            appName: 'No Creds App',
          ),
        );

        await ProvisionAppFutureCall().provisionApp(
          builderA.build(),
          app.id!,
        );

        final done = await StoreApp.db.findById(builderA.build(), app.id!);
        expect(done?.status, 'failed');
        expect(done?.statusLog, contains('not configured'));
      },
    );

    test(
      'when setting a TestFlight link then it is stored for the owner',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Linked', '');
        final app = await StoreApp.db.insertRow(
          builderA.build(),
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.apploop.linked',
            sku: 'com.hurated.apploop.linked',
            appName: 'Linked',
          ),
        );

        const link = 'https://testflight.apple.com/join/AbCdEfGh';
        final updated = await endpoints.storeApp.setTestflightLink(
          builderA,
          app.id!,
          link,
        );
        expect(updated.testflightLink, link);

        final cleared = await endpoints.storeApp.setTestflightLink(
          builderA,
          app.id!,
          '',
        );
        expect(cleared.testflightLink, isEmpty);
      },
    );

    test(
      'when setting a non-TestFlight link then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Linked', '');
        final app = await StoreApp.db.insertRow(
          builderA.build(),
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.apploop.linked2',
            sku: 'com.hurated.apploop.linked2',
            appName: 'Linked',
          ),
        );

        await expectLater(
          endpoints.storeApp.setTestflightLink(
            builderA,
            app.id!,
            'https://example.com/join/xyz',
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when setting a link on another users app then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'Linked', '');
        final app = await StoreApp.db.insertRow(
          builderA.build(),
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.apploop.linked3',
            sku: 'com.hurated.apploop.linked3',
            appName: 'Linked',
          ),
        );

        await expectLater(
          endpoints.storeApp.setTestflightLink(
            _asUser(sessionBuilder, _userB),
            app.id!,
            'https://testflight.apple.com/join/AbCdEfGh',
          ),
          throwsStateError,
        );
      },
    );
  });
}
