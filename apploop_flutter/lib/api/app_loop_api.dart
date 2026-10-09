import 'package:apploop_client/apploop_client.dart';

/// Server operations used by the UI, behind an interface so widget tests
/// can run against an in-memory fake instead of a live backend.
abstract class AppLoopApi {
  Future<AppWish> createWish(String title, String description);
  Future<List<AppWish>> listMyWishes();
  Future<void> deleteWish(int id);

  Future<StoreApp?> getStoreAppForWish(int wishId);
  Future<StoreApp> requestApp(int wishId);
  Future<StoreApp> setTestflightLink(int storeAppId, String link);

  Future<AppBuild> requestBuild(int wishId);
  Future<List<AppBuild>> listMyBuilds();
  Future<AppBuild> getBuild(int id);
  Future<AppBuild> retryBuild(int id);
  Future<TestflightInfo> testflightInfo(int id);

  Future<FeedbackRecording> startRecording(int buildId);
  Future<String> videoUploadDescription(int recordingId);
  Future<String> audioUploadDescription(int recordingId);
  Future<FeedbackRecording> completeRecording(int recordingId);
  Future<List<FeedbackRecording>> listRecordings(int buildId);
  Future<List<FeedbackRecording>> listMyRecordings();
  Future<String> recordingDownloadUrl(int recordingId, String kind);
  Future<String> screenshotUrl(int recordingId, String fileName);

  Future<List<FeedbackComment>> listComments(int recordingId);
  Future<FeedbackComment> addManualComment(
    int recordingId,
    String title,
    String text,
    String origin,
  );
  Future<FeedbackComment> editComment(
    int id,
    String title,
    String text,
    String severity,
  );
  Future<FeedbackComment> setResolved(int id, bool resolved);
  Future<void> deleteComment(int id);
}

/// Live implementation over the generated Serverpod client.
class ServerAppLoopApi implements AppLoopApi {
  final Client _client;

  ServerAppLoopApi(this._client);

  @override
  Future<AppWish> createWish(String title, String description) =>
      _client.wish.createWish(title, description);

  @override
  Future<List<AppWish>> listMyWishes() => _client.wish.listMyWishes();

  @override
  Future<void> deleteWish(int id) => _client.wish.deleteWish(id);

  @override
  Future<StoreApp?> getStoreAppForWish(int wishId) =>
      _client.storeApp.getStoreAppForWish(wishId);

  @override
  Future<StoreApp> requestApp(int wishId) =>
      _client.storeApp.requestApp(wishId);

  @override
  Future<StoreApp> setTestflightLink(int storeAppId, String link) =>
      _client.storeApp.setTestflightLink(storeAppId, link);

  @override
  Future<AppBuild> requestBuild(int wishId) =>
      _client.build.requestBuild(wishId);

  @override
  Future<List<AppBuild>> listMyBuilds() => _client.build.listMyBuilds();

  @override
  Future<AppBuild> getBuild(int id) => _client.build.getBuild(id);

  @override
  Future<AppBuild> retryBuild(int id) => _client.build.retryBuild(id);

  @override
  Future<TestflightInfo> testflightInfo(int id) =>
      _client.build.testflightInfo(id);

  @override
  Future<FeedbackRecording> startRecording(int buildId) =>
      _client.feedback.startRecording(buildId);

  @override
  Future<String> videoUploadDescription(int recordingId) =>
      _client.feedback.getVideoUploadDescription(recordingId);

  @override
  Future<String> audioUploadDescription(int recordingId) =>
      _client.feedback.getAudioUploadDescription(recordingId);

  @override
  Future<FeedbackRecording> completeRecording(int recordingId) =>
      _client.feedback.completeRecording(recordingId);

  @override
  Future<List<FeedbackRecording>> listRecordings(int buildId) =>
      _client.feedback.listRecordings(buildId);

  @override
  Future<List<FeedbackRecording>> listMyRecordings() =>
      _client.feedback.listMyRecordings();

  @override
  Future<String> recordingDownloadUrl(int recordingId, String kind) =>
      _client.feedback.downloadUrl(recordingId, kind);

  @override
  Future<String> screenshotUrl(int recordingId, String fileName) =>
      _client.feedback.screenshotUrl(recordingId, fileName);

  @override
  Future<List<FeedbackComment>> listComments(int recordingId) =>
      _client.feedback.listComments(recordingId);

  @override
  Future<FeedbackComment> addManualComment(
    int recordingId,
    String title,
    String text,
    String origin,
  ) => _client.feedback.addManualComment(recordingId, title, text, origin);

  @override
  Future<FeedbackComment> editComment(
    int id,
    String title,
    String text,
    String severity,
  ) => _client.feedback.editComment(id, title, text, severity);

  @override
  Future<FeedbackComment> setResolved(int id, bool resolved) =>
      _client.feedback.setResolved(id, resolved);

  @override
  Future<void> deleteComment(int id) => _client.feedback.deleteComment(id);
}
