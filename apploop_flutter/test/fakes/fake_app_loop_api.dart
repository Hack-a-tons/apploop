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
  bundleId: 'com.hurated.apploop.test',
  sku: 'com.hurated.apploop.test',
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
}
