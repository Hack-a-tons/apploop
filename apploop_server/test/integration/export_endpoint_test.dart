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

void main() {
  withServerpod('Given Export endpoint', (sessionBuilder, endpoints) {
    test(
      'when exporting a full loop then the document tells the whole story',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final session = builderA.build();
        final wish = await AppWish.db.insertRow(
          session,
          AppWish(
            authUserId: UuidValue.fromString(_userA),
            title: 'Looped App',
            descriptionText: 'Built twice',
            status: 'satisfied',
            currentIteration: 2,
          ),
        );
        await StoreApp.db.insertRow(
          session,
          StoreApp(
            wishId: wish.id!,
            bundleId: 'com.hurated.loop.looped',
            sku: 'com.hurated.loop.looped',
            appName: 'Looped App',
            status: 'ready',
            ascAppId: '999',
            testflightLink: 'https://testflight.apple.com/join/LoOpEd',
          ),
        );
        final build = await AppBuild.db.insertRow(
          session,
          AppBuild(
            wishId: wish.id!,
            storeAppId: (await StoreApp.db.findFirstRow(
              session,
              where: (t) => t.wishId.equals(wish.id!),
            ))!.id!,
            iteration: 2,
            buildNumber: 5,
            status: 'ready',
            testflightState: 'READY',
          ),
        );
        final recording = await FeedbackRecording.db.insertRow(
          session,
          FeedbackRecording(
            buildId: build.id!,
            authUserId: UuidValue.fromString(_userA),
            transcript: 'second round is smooth',
            status: 'ready',
          ),
        );
        await FeedbackComment.db.insertRow(
          session,
          FeedbackComment(
            recordingId: recording.id!,
            authUserId: UuidValue.fromString(_userA),
            title: 'Fixed crash',
            severity: 'high',
            timestamps: '[01:02]',
            resolved: true,
          ),
        );

        final markdown = await endpoints.export.exportWish(
          builderA,
          wish.id!,
        );

        expect(markdown, contains('# Looped App'));
        expect(markdown, contains('com.hurated.loop.looped'));
        expect(markdown, contains('https://testflight.apple.com/join/LoOpEd'));
        expect(markdown, contains('Iteration 2 — build 5'));
        expect(markdown, contains('second round is smooth'));
        expect(markdown, contains('[x] **high** Fixed crash ([01:02])'));
      },
    );

    test(
      'when exporting another users wish then it throws',
      () async {
        await _seedUser(sessionBuilder, _userA);
        final wish = await AppWish.db.insertRow(
          _asUser(sessionBuilder, _userA).build(),
          AppWish(
            authUserId: UuidValue.fromString(_userA),
            title: 'Mine',
          ),
        );

        await expectLater(
          endpoints.export.exportWish(
            _asUser(sessionBuilder, _userB),
            wish.id!,
          ),
          throwsStateError,
        );
      },
    );
  });
}
