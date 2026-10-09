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
  Future<String> recordingDownloadUrl(int recordingId, String kind);
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
  Future<String> recordingDownloadUrl(int recordingId, String kind) =>
      _client.feedback.downloadUrl(recordingId, kind);
}
