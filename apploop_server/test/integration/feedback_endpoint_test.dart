import 'dart:typed_data';

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

/// Wish + ready store app + build for [userId]; returns the build id.
Future<int> _seedBuild(TestSessionBuilder sessionBuilder, String userId) async {
  await _seedUser(sessionBuilder, userId);
  final builder = _asUser(sessionBuilder, userId);
  final session = builder.build();
  final wish = await AppWish.db.insertRow(
    session,
    AppWish(
      authUserId: UuidValue.fromString(userId),
      title: 'Testable',
      descriptionText: '',
    ),
  );
  final storeApp = await StoreApp.db.insertRow(
    session,
    StoreApp(
      wishId: wish.id!,
      bundleId: 'com.hurated.apploop.testable',
      sku: 'com.hurated.apploop.testable',
      appName: 'Testable',
      status: 'ready',
    ),
  );
  final build = await AppBuild.db.insertRow(
    session,
    AppBuild(
      wishId: wish.id!,
      storeAppId: storeApp.id!,
      iteration: 1,
      buildNumber: 1,
      status: 'ready',
    ),
  );
  return build.id!;
}

Future<void> _seedVideo(TestSessionBuilder builder, int recordingId) async {
  final session = builder.build();
  final recording = (await FeedbackRecording.db.findById(
    session,
    recordingId,
  ))!;
  await session.storage.storeFile(
    storageId: 'private',
    path: 'feedback/${recording.authUserId}/${recording.id}/video.mov',
    byteData: ByteData.sublistView(Uint8List.fromList([0, 1, 2, 3])),
  );
}

void main() {
  withServerpod('Given Feedback endpoint', (sessionBuilder, endpoints) {
    test(
      'when starting a recording then it is uploading for that build',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final recording = await endpoints.feedback.startRecording(
          _asUser(sessionBuilder, _userA),
          buildId,
        );
        expect(recording.buildId, buildId);
        expect(recording.status, 'uploading');
      },
    );

    test(
      'when starting a recording for another users build then it throws',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        await expectLater(
          endpoints.feedback.startRecording(
            _asUser(sessionBuilder, _userB),
            buildId,
          ),
          throwsStateError,
        );
      },
    );

    test('when asking for descriptions then they are issued', () async {
      final buildId = await _seedBuild(sessionBuilder, _userA);
      final builderA = _asUser(sessionBuilder, _userA);
      final recording = await endpoints.feedback.startRecording(
        builderA,
        buildId,
      );

      final video = await endpoints.feedback.getVideoUploadDescription(
        builderA,
        recording.id!,
      );
      final audio = await endpoints.feedback.getAudioUploadDescription(
        builderA,
        recording.id!,
      );
      expect(video, isNotEmpty);
      expect(audio, isNotEmpty);
      expect(video, isNot(audio));
    });

    test(
      'when completing without files then it throws and stays uploading',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recording = await endpoints.feedback.startRecording(
          builderA,
          buildId,
        );

        await expectLater(
          endpoints.feedback.completeRecording(builderA, recording.id!),
          throwsStateError,
        );
        final still = await FeedbackRecording.db.findById(
          builderA.build(),
          recording.id!,
        );
        expect(still?.status, 'uploading');
      },
    );

    test(
      'when completing with a stored video then it is uploaded with a path',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recording = await endpoints.feedback.startRecording(
          builderA,
          buildId,
        );
        await _seedVideo(builderA, recording.id!);

        final done = await endpoints.feedback.completeRecording(
          builderA,
          recording.id!,
        );
        expect(done.status, 'uploaded');
        expect(done.videoPath, contains('video.mov'));

        final url = await endpoints.feedback.downloadUrl(
          builderA,
          recording.id!,
          'video',
        );
        expect(url, isNotEmpty);
      },
    );

    test(
      'when listing recordings then other users recordings are hidden',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        await _seedUser(sessionBuilder, _userB);
        await endpoints.feedback.startRecording(
          _asUser(sessionBuilder, _userA),
          buildId,
        );

        await expectLater(
          endpoints.feedback.listRecordings(
            _asUser(sessionBuilder, _userB),
            buildId,
          ),
          // Other user cannot even see the build: throws, not empty.
          throwsStateError,
        );
        expect(
          (await endpoints.feedback.listRecordings(
            _asUser(sessionBuilder, _userA),
            buildId,
          )).length,
          1,
        );
      },
    );

    test(
      'when downloading another users recording then it throws',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recording = await endpoints.feedback.startRecording(
          builderA,
          buildId,
        );
        await _seedVideo(builderA, recording.id!);
        await endpoints.feedback.completeRecording(builderA, recording.id!);

        await expectLater(
          endpoints.feedback.downloadUrl(
            _asUser(sessionBuilder, _userB),
            recording.id!,
            'video',
          ),
          throwsStateError,
        );
      },
    );
  });
}
