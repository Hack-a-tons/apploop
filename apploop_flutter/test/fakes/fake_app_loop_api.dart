import 'package:apploop_client/apploop_client.dart';

import 'package:apploop_flutter/api/app_loop_api.dart';

final _fakeUser = UuidValue.fromString('00000000-0000-4000-8000-000000000001');

AppWish testWish({int id = 1, String title = 'Test wish'}) => AppWish(
  id: id,
  authUserId: _fakeUser,
  title: title,
  descriptionText: 'Test details',
  status: 'draft',
);

AppBuild testBuild({int id = 1, String status = 'ready'}) => AppBuild(
  id: id,
  wishId: 1,
  storeAppId: 1,
  iteration: 1,
  buildNumber: 7,
  status: status,
  statusLog: 'log line\n',
  testflightState: 'READY',
);

StoreApp testStoreApp({String status = 'ready'}) => StoreApp(
  id: 1,
  wishId: 1,
  bundleId: 'com.hurated.loop.test',
  sku: 'com.hurated.loop.test',
  appName: 'Test',
  status: status,
);

/// In-memory [AppLoopApi] for widget tests. Seed data via fields;
/// set [error] to make the next call throw.
class FakeAppLoopApi implements AppLoopApi {
  List<AppWish> wishes = [];
  Map<int, StoreApp?> storeApps = {};
  List<AppBuild> builds = [];
  TestflightInfo? info;
  Object? error;

  final List<String> calls = [];

  Future<T> _call<T>(String name, Future<T> Function() run) async {
    calls.add(name);
    if (error != null) {
      final e = error!;
      error = null;
      throw e;
    }
    return run();
  }

  @override
  Future<AppWish> createWish(String title, String description) =>
      _call('createWish', () async {
        final wish = testWish(id: wishes.length + 1, title: title);
        wishes = [...wishes, wish];
        return wish;
      });

  @override
  Future<List<AppWish>> listMyWishes() =>
      _call('listMyWishes', () async => wishes);

  @override
  Future<void> deleteWish(int id) => _call('deleteWish', () async {
    wishes = wishes.where((w) => w.id != id).toList();
  });

  @override
  Future<StoreApp?> getStoreAppForWish(int wishId) =>
      _call('getStoreAppForWish', () async => storeApps[wishId]);

  @override
  Future<StoreApp> requestApp(int wishId) => _call('requestApp', () async {
    final app = testStoreApp(status: 'creating');
    storeApps[wishId] = app;
    return app;
  });

  @override
  Future<StoreApp> setTestflightLink(int storeAppId, String link) =>
      _call('setTestflightLink', () async => testStoreApp());

  @override
  Future<AppBuild> requestBuild(int wishId) =>
      _call('requestBuild', () async => testBuild(status: 'queued'));

  @override
  Future<List<AppBuild>> listMyBuilds() =>
      _call('listMyBuilds', () async => builds);

  @override
  Future<List<AppBuild>> getBuildsForWish(int wishId) =>
      _call('getBuildsForWish', () async => builds);

  @override
  Future<AppBuild> getBuild(int id) => _call('getBuild', () async {
    return builds.firstWhere((b) => b.id == id, orElse: () => testBuild());
  });

  @override
  Future<AppBuild> retryBuild(int id) => _call('retryBuild', () async {
    final retried = testBuild(id: id, status: 'queued');
    builds = builds.map((b) => b.id == id ? retried : b).toList();
    return retried;
  });

  @override
  Future<TestflightInfo> testflightInfo(int id) =>
      _call('testflightInfo', () async {
        return info ??
            TestflightInfo(
              buildNumber: 7,
              version: '1.0',
              status: 'ready',
              testflightState: 'READY',
              installUrl: '',
            );
      });

  List<FeedbackRecording> recordings = [];

  FeedbackRecording testRecording({int id = 1, String status = 'uploaded'}) =>
      FeedbackRecording(
        id: id,
        buildId: 1,
        authUserId: _fakeUser,
        videoPath: 'feedback/x/1/video.mov',
        status: status,
      );

  @override
  Future<FeedbackRecording> startRecording(int buildId) =>
      _call('startRecording', () async {
        final recording = testRecording(id: recordings.length + 1);
        recordings = [...recordings, recording];
        return recording;
      });

  @override
  Future<String> videoUploadDescription(int recordingId) =>
      _call('videoUploadDescription', () async => 'video-desc');

  @override
  Future<String> audioUploadDescription(int recordingId) =>
      _call('audioUploadDescription', () async => 'audio-desc');

  @override
  Future<FeedbackRecording> completeRecording(int recordingId) =>
      _call('completeRecording', () async => testRecording(id: recordingId));

  @override
  Future<List<FeedbackRecording>> listRecordings(int buildId) =>
      _call('listRecordings', () async => recordings);

  @override
  Future<String> recordingDownloadUrl(int recordingId, String kind) =>
      _call('recordingDownloadUrl', () async => 'https://example.com/$kind');

  @override
  Future<List<FeedbackRecording>> listMyRecordings() =>
      _call('listMyRecordings', () async => recordings);

  @override
  Future<String> screenshotUrl(int recordingId, String fileName) =>
      _call('screenshotUrl', () async => 'https://example.com/$fileName');

  List<FeedbackComment> comments = [];

  FeedbackComment testComment({int id = 1, bool resolved = false}) =>
      FeedbackComment(
        id: id,
        recordingId: 1,
        authUserId: _fakeUser,
        title: 'Test issue',
        text: 'It broke here',
        severity: 'high',
        timestamps: '[00:12]',
        origin: 'extracted',
      ).copyWith(resolved: resolved);

  @override
  Future<List<FeedbackComment>> listComments(int recordingId) =>
      _call('listComments', () async => comments);

  @override
  Future<FeedbackComment> addManualComment(
    int recordingId,
    String title,
    String text,
    String origin,
  ) => _call('addManualComment', () async {
    final comment = testComment(id: comments.length + 1);
    comments = [...comments, comment];
    return comment;
  });

  @override
  Future<FeedbackComment> editComment(
    int id,
    String title,
    String text,
    String severity,
  ) => _call('editComment', () async => testComment(id: id));

  @override
  Future<FeedbackComment> setResolved(int id, bool resolved) =>
      _call('setResolved', () async {
        final updated = testComment(id: id, resolved: resolved);
        comments = comments.map((c) => c.id == id ? updated : c).toList();
        return updated;
      });

  @override
  Future<void> deleteComment(int id) => _call('deleteComment', () async {
    comments = comments.where((c) => c.id != id).toList();
  });

  @override
  Future<AppWish> markSatisfied(int id) => _call('markSatisfied', () async {
    final updated = testWish(id: id, title: 'Satisfied');
    wishes = wishes.map((w) => w.id == id ? updated : w).toList();
    return updated;
  });

  @override
  Future<AppWish> reopenWish(int id) => _call('reopenWish', () async {
    final updated = testWish(id: id, title: 'Reopened');
    wishes = wishes.map((w) => w.id == id ? updated : w).toList();
    return updated;
  });

  @override
  Future<String> exportWish(int wishId) =>
      _call('exportWish', () async => '# Export of wish $wishId');
}
