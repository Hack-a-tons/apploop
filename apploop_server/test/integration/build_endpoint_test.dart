import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import 'package:apploop_server/src/generated/protocol.dart';

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

/// Builder token from the test run's passwords (passwords.yaml test
/// section locally, SERVERPOD_PASSWORD_builderToken in CI).
String _builderToken(TestSessionBuilder builder) {
  final token = builder.build().passwords['builderToken'] ?? '';
  assert(token.isNotEmpty, 'Test run is missing the builderToken password.');
  return token;
}

/// Creates a wish + ready store app for [userId], returns their ids.
Future<(int, int)> _seedProvisioned(
  TestSessionBuilder sessionBuilder,
  String userId,
) async {
  await _seedUser(sessionBuilder, userId);
  final builder = _asUser(sessionBuilder, userId);
  final session = builder.build();
  final wish = await AppWish.db.insertRow(
    session,
    AppWish(
      authUserId: UuidValue.fromString(userId),
      title: 'Buildable',
      descriptionText: 'Build me',
    ),
  );
  final storeApp = await StoreApp.db.insertRow(
    session,
    StoreApp(
      wishId: wish.id!,
      bundleId: 'com.hurated.apploop.buildable',
      sku: 'com.hurated.apploop.buildable',
      appName: 'Buildable',
      status: 'ready',
      ascAppId: 'test-asc-app-id',
    ),
  );
  return (wish.id!, storeApp.id!);
}

void main() {
  withServerpod('Given Build endpoint', (sessionBuilder, endpoints) {
    test(
      'when requesting without Apple credentials then it throws and creates nothing',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'No Creds', '');
        await StoreApp.db.insertRow(
          builderA.build(),
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.apploop.no_creds',
            sku: 'com.hurated.apploop.no_creds',
            appName: 'No Creds',
            status: 'ready',
          ),
        );

        await expectLater(
          endpoints.build.requestBuild(builderA, wish.id!),
          throwsStateError,
        );
        expect(
          await endpoints.build.getBuildsForWish(builderA, wish.id!),
          isEmpty,
        );
      },
    );

    test(
      'when requesting without a provisioned app then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final wish = await endpoints.wish.createWish(builderA, 'No App', '');

        await expectLater(
          endpoints.build.requestBuild(builderA, wish.id!),
          throwsStateError,
        );
      },
    );

    test(
      'when reading another users build then it throws',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final build = await AppBuild.db.insertRow(
          _asUser(sessionBuilder, _userA).build(),
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 1,
            status: 'failed',
          ),
        );
        await expectLater(
          endpoints.build.getBuild(
            _asUser(sessionBuilder, _userB),
            build.id!,
          ),
          throwsStateError,
        );
      },
    );

    test(
      'when retrying a failed build then it is queued again',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final builderA = _asUser(sessionBuilder, _userA);
        final build = await AppBuild.db.insertRow(
          builderA.build(),
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 7,
            status: 'failed',
            statusLog: 'boom\n',
          ),
        );

        final retried = await endpoints.build.retryBuild(builderA, build.id!);

        expect(retried.status, 'queued');
        expect(retried.statusLog, contains('boom'));
        expect(retried.statusLog, contains('Retried'));
      },
    );

    test(
      'when listing builds then only the callers builds are returned',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        await _seedUser(sessionBuilder, _userB);
        final sessionA = _asUser(sessionBuilder, _userA).build();
        await AppBuild.db.insertRow(
          sessionA,
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 1,
            status: 'failed',
          ),
        );

        expect(
          (await endpoints.build.listMyBuilds(
            _asUser(sessionBuilder, _userB),
          )),
          isEmpty,
        );
        expect(
          (await endpoints.build.listMyBuilds(
            _asUser(sessionBuilder, _userA),
          )).length,
          1,
        );
      },
    );

    test(
      'when reading install info then numbers, state and link are returned',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final builderA = _asUser(sessionBuilder, _userA);
        const link = 'https://testflight.apple.com/join/AbCdEfGh';
        await endpoints.storeApp.setTestflightLink(
          builderA,
          storeAppId,
          link,
        );
        final build = await AppBuild.db.insertRow(
          builderA.build(),
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 2,
            buildNumber: 9,
            status: 'ready',
            testflightState: 'READY',
          ),
        );

        final info = await endpoints.build.testflightInfo(
          builderA,
          build.id!,
        );

        expect(info.buildNumber, 9);
        expect(info.version, '1.0');
        expect(info.status, 'ready');
        expect(info.testflightState, 'READY');
        expect(info.installUrl, link);
      },
    );

    test(
      'when reading install info without a link then the url is empty',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final builderA = _asUser(sessionBuilder, _userA);
        final build = await AppBuild.db.insertRow(
          builderA.build(),
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 1,
            status: 'building',
          ),
        );

        final info = await endpoints.build.testflightInfo(
          builderA,
          build.id!,
        );
        expect(info.installUrl, isEmpty);
      },
    );

    test(
      'when reading another users install info then it throws',
      () async {
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final build = await AppBuild.db.insertRow(
          _asUser(sessionBuilder, _userA).build(),
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 1,
            status: 'ready',
          ),
        );

        await expectLater(
          endpoints.build.testflightInfo(
            _asUser(sessionBuilder, _userB),
            build.id!,
          ),
          throwsStateError,
        );
      },
    );
  });

  withServerpod('Given Builder endpoint', (sessionBuilder, endpoints) {
    test('when the token is wrong then claim throws', () async {
      await expectLater(
        endpoints.builder.claimBuildTask(sessionBuilder, 'wrong'),
        throwsStateError,
      );
    });

    test(
      'when claiming then the task carries everything the worker needs',
      () async {
        final token = _builderToken(sessionBuilder);
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final sessionA = _asUser(sessionBuilder, _userA).build();
        await AppBuild.db.insertRow(
          sessionA,
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 3,
            buildNumber: 12,
          ),
        );

        final task = await endpoints.builder.claimBuildTask(
          sessionBuilder,
          token,
        );

        expect(task, isNotNull);
        expect(task!.build.buildNumber, 12);
        expect(task.wishTitle, 'Buildable');
        expect(task.bundleId, 'com.hurated.apploop.buildable');
        expect(task.organization, isNotEmpty);

        // Second claim finds nothing (already claimed, heartbeat fresh).
        expect(
          await endpoints.builder.claimBuildTask(sessionBuilder, token),
          isNull,
        );
      },
    );

    test(
      'when progressing and completing then status, log and wish follow',
      () async {
        final token = _builderToken(sessionBuilder);
        final (wishId, storeAppId) = await _seedProvisioned(
          sessionBuilder,
          _userA,
        );
        final sessionA = _asUser(sessionBuilder, _userA).build();
        final build = await AppBuild.db.insertRow(
          sessionA,
          AppBuild(
            wishId: wishId,
            storeAppId: storeAppId,
            iteration: 1,
            buildNumber: 1,
          ),
        );

        await endpoints.builder.postBuildProgress(
          sessionBuilder,
          token,
          build.id!,
          'building',
          'Compiling...\n',
        );
        var current = await AppBuild.db.findById(sessionA, build.id!);
        expect(current?.status, 'building');
        expect(current?.statusLog, contains('Compiling'));

        await endpoints.builder.completeBuild(
          sessionBuilder,
          token,
          build.id!,
          true,
          'READY',
          'Uploaded.\n',
        );
        current = await AppBuild.db.findById(sessionA, build.id!);
        expect(current?.status, 'ready');
        expect(current?.testflightState, 'READY');
        final wish = await AppWish.db.findById(sessionA, wishId);
        expect(wish?.status, 'testing');
      },
    );

    test('when a claim goes stale then it can be claimed again', () async {
      final token = _builderToken(sessionBuilder);
      final (wishId, storeAppId) = await _seedProvisioned(
        sessionBuilder,
        _userA,
      );
      final sessionA = _asUser(sessionBuilder, _userA).build();
      await AppBuild.db.insertRow(
        sessionA,
        AppBuild(
          wishId: wishId,
          storeAppId: storeAppId,
          iteration: 1,
          buildNumber: 1,
          status: 'claimed',
          heartbeatAt: DateTime.now().toUtc().subtract(
            const Duration(hours: 1),
          ),
        ),
      );

      final task = await endpoints.builder.claimBuildTask(
        sessionBuilder,
        token,
      );
      expect(task, isNotNull);
    });
  });
}
