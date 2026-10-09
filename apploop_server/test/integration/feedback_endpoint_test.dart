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

Future<void> _seedShot(
  TestSessionBuilder builder,
  int recordingId,
  String name,
) async {
  final session = builder.build();
  final recording = (await FeedbackRecording.db.findById(
    session,
    recordingId,
  ))!;
  await session.storage.storeFile(
    storageId: 'private',
    path: 'feedback/${recording.authUserId}/${recording.id}/shots/$name',
    byteData: ByteData.sublistView(Uint8List.fromList([4, 5, 6])),
  );
}

String _builderToken(TestSessionBuilder builder) {
  final token = builder.build().passwords['builderToken'] ?? '';
  assert(token.isNotEmpty, 'Test run is missing the builderToken password.');
  return token;
}

void main() {
  withServerpod('Given Feedback endpoint', (sessionBuilder, endpoints) {
    /// Starts a recording with a stored video and completes the upload.
    Future<int> seedUploadedRecording(String userId, int buildId) async {
      final builder = _asUser(sessionBuilder, userId);
      final recording = await endpoints.feedback.startRecording(
        builder,
        buildId,
      );
      await _seedVideo(builder, recording.id!);
      final done = await endpoints.feedback.completeRecording(
        builder,
        recording.id!,
      );
      return done.id!;
    }

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

    test(
      'when processing completes then comments are created with mapping',
      () async {
        final token = _builderToken(sessionBuilder);
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);
        await _seedShot(builderA, recordingId, 'shot-01.jpg');

        final task = await endpoints.feedbackBuilder.claimRecordingTask(
          sessionBuilder,
          token,
        );
        expect(task?.recording.id, recordingId);
        expect(task?.videoUrl, isNotEmpty);

        final done = await endpoints.feedbackBuilder
            .completeRecordingProcessing(
              sessionBuilder,
              token,
              recordingId,
              'transcript here',
              '[{"title": "Crash on save", "severity": "high", '
                  '"timestamps": ["[00:12]"], "quote": "it crashed", '
                  '"fix": "guard null", "needs_shot": true}, '
                  '{"title": "Typo", "severity": "low", '
                  '"timestamps": "[00:40]", "quote": "teh", "fix": ""}]',
              ['shot-01.jpg', ''],
            );

        expect(done.status, 'ready');
        expect(done.transcript, 'transcript here');
        final comments = await endpoints.feedback.listComments(
          builderA,
          recordingId,
        );
        expect(comments.length, 2);
        expect(comments[0].title, 'Crash on save');
        expect(comments[0].severity, 'high');
        expect(comments[0].timestamps, '[00:12]');
        expect(comments[0].screenshotPath, contains('shot-01.jpg'));
        expect(comments[0].origin, 'extracted');
        expect(comments[0].text, contains('Suggested fix'));
        expect(comments[1].screenshotPath, isEmpty);
        expect(comments[1].text, isNot(contains('Suggested fix')));
      },
    );

    test(
      'when processing with bad JSON then it throws and stays processing',
      () async {
        final token = _builderToken(sessionBuilder);
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);
        await endpoints.feedbackBuilder.claimRecordingTask(
          sessionBuilder,
          token,
        );

        await expectLater(
          endpoints.feedbackBuilder.completeRecordingProcessing(
            sessionBuilder,
            token,
            recordingId,
            '',
            'not json',
            [],
          ),
          throwsArgumentError,
        );
      },
    );

    test(
      'when processing with a missing screenshot then it throws',
      () async {
        final token = _builderToken(sessionBuilder);
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);
        await endpoints.feedbackBuilder.claimRecordingTask(
          sessionBuilder,
          token,
        );

        await expectLater(
          endpoints.feedbackBuilder.completeRecordingProcessing(
            sessionBuilder,
            token,
            recordingId,
            '',
            '[{"title": "X", "severity": "medium", "timestamps": [], '
                '"quote": "", "fix": ""}]',
            ['ghost.jpg'],
          ),
          throwsStateError,
        );
      },
    );

    test(
      'when managing manual comments then CRUD and validation work',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);

        final comment = await endpoints.feedback.addManualComment(
          builderA,
          recordingId,
          'Laggy scroll',
          'stutters badly',
          'voice',
        );
        expect(comment.origin, 'voice');
        expect(comment.resolved, isFalse);

        await expectLater(
          endpoints.feedback.addManualComment(
            builderA,
            recordingId,
            '   ',
            'x',
            'keyboard',
          ),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.feedback.editComment(
            builderA,
            comment.id!,
            'Laggy scroll',
            'stutters',
            'critical',
          ),
          throwsArgumentError,
        );

        final edited = await endpoints.feedback.editComment(
          builderA,
          comment.id!,
          'Laggy scroll!',
          'stutters badly here',
          'high',
        );
        expect(edited.title, 'Laggy scroll!');
        expect(edited.severity, 'high');

        final resolved = await endpoints.feedback.setResolved(
          builderA,
          comment.id!,
          true,
        );
        expect(resolved.resolved, isTrue);

        await endpoints.feedback.deleteComment(builderA, comment.id!);
        expect(
          await endpoints.feedback.listComments(builderA, recordingId),
          isEmpty,
        );
      },
    );

    test(
      'when touching another users comment then it throws',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);
        final comment = await endpoints.feedback.addManualComment(
          builderA,
          recordingId,
          'Mine',
          'mine',
          'keyboard',
        );

        final builderB = _asUser(sessionBuilder, _userB);
        await expectLater(
          endpoints.feedback.editComment(
            builderB,
            comment.id!,
            'Hacked',
            'hacked',
            'low',
          ),
          throwsStateError,
        );
        await expectLater(
          endpoints.feedback.setResolved(builderB, comment.id!, true),
          throwsStateError,
        );
      },
    );

    test(
      'when listing my recordings then only mine are returned',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        await _seedUser(sessionBuilder, _userB);
        await seedUploadedRecording(_userA, buildId);

        expect(
          await endpoints.feedback.listMyRecordings(
            _asUser(sessionBuilder, _userB),
          ),
          isEmpty,
        );
        expect(
          (await endpoints.feedback.listMyRecordings(
            _asUser(sessionBuilder, _userA),
          )).length,
          1,
        );
      },
    );

    test(
      'when reading a screenshot url then it is issued for stored shots',
      () async {
        final buildId = await _seedBuild(sessionBuilder, _userA);
        final builderA = _asUser(sessionBuilder, _userA);
        final recordingId = await seedUploadedRecording(_userA, buildId);
        await _seedShot(builderA, recordingId, 'shot-01.jpg');

        final url = await endpoints.feedback.screenshotUrl(
          builderA,
          recordingId,
          'shot-01.jpg',
        );
        expect(url, isNotEmpty);

        await expectLater(
          endpoints.feedback.screenshotUrl(
            builderA,
            recordingId,
            '../evil.png',
          ),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.feedback.screenshotUrl(
            _asUser(sessionBuilder, _userB),
            recordingId,
            'shot-01.jpg',
          ),
          throwsStateError,
        );
      },
    );
  });
}
