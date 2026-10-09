import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../store/asc_api.dart';

/// Builds: one TestFlight build per loop iteration.
///
/// All methods require a signed-in user and only touch rows owned by
/// that user. The actual build work happens on the Mac builder worker
/// via [BuilderEndpoint]; this endpoint records intent and reports state.
class BuildEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Requests a build for a wish owned by the caller. The wish must
  /// already have a provisioned (`ready`) store app, and Apple
  /// credentials must be configured. Assigns the next free TestFlight
  /// build number (latest on TestFlight and local rows + 1).
  Future<AppBuild> requestBuild(Session session, int wishId) async {
    final wish = await _ownedWish(session, wishId);
    final storeApp = await StoreApp.db.findFirstRow(
      session,
      where: (t) => t.wishId.equals(wishId),
    );
    if (storeApp == null || storeApp.status != 'ready') {
      throw StateError(
        'Provision the TestFlight app for this wish first.',
      );
    }

    final creds = AppleCredentials.fromPasswords(session.passwords);
    if (!creds.isConfigured) {
      throw StateError(
        'Apple credentials not configured. Add ascKeyId, ascIssuerId and '
        'ascPrivateKey to config/passwords.yaml (git-ignored).',
      );
    }

    final api = AppStoreConnectApi(creds);
    try {
      final tfLatest = await api.nextBuildNumber(storeApp.ascAppId) - 1;
      final local = await AppBuild.db.find(
        session,
        where: (t) => t.storeAppId.equals(storeApp.id!),
      );
      var localLatest = 0;
      for (final build in local) {
        if (build.buildNumber > localLatest) localLatest = build.buildNumber;
      }
      final number = (tfLatest > localLatest ? tfLatest : localLatest) + 1;

      final iteration = wish.currentIteration + 1;
      await AppWish.db.updateRow(
        session,
        wish.copyWith(status: 'building', currentIteration: iteration),
      );
      final row = await AppBuild.db.insertRow(
        session,
        AppBuild(
          wishId: wish.id!,
          storeAppId: storeApp.id!,
          iteration: iteration,
          buildNumber: number,
          heartbeatAt: DateTime.now().toUtc(),
        ),
      );
      return row;
    } finally {
      api.close();
    }
  }

  /// Lists the caller's builds for one wish, newest first.
  Future<List<AppBuild>> getBuildsForWish(Session session, int wishId) async {
    await _ownedWish(session, wishId);
    return AppBuild.db.find(
      session,
      where: (t) => t.wishId.equals(wishId),
      orderBy: (t) => t.id.desc(),
    );
  }

  /// Lists all of the caller's builds across wishes, newest first.
  Future<List<AppBuild>> listMyBuilds(Session session) async {
    final owner = session.authenticated!.authUserId;
    final wishes = await AppWish.db.find(
      session,
      where: (t) => t.authUserId.equals(owner),
    );
    if (wishes.isEmpty) return [];
    final ids = wishes.map((w) => w.id!).toSet();
    final builds = await AppBuild.db.find(session);
    final mine = builds.where((b) => ids.contains(b.wishId)).toList()
      ..sort((a, b) => b.id!.compareTo(a.id!));
    return mine;
  }

  /// Loads one build owned by the caller.
  Future<AppBuild> getBuild(Session session, int id) async {
    return _ownedBuild(session, id);
  }

  /// Re-queues a failed build owned by the caller.
  Future<AppBuild> retryBuild(Session session, int id) async {
    final build = await _ownedBuild(session, id);
    if (build.status != 'failed') {
      throw StateError('Only failed builds can be retried.');
    }
    return AppBuild.db.updateRow(
      session,
      build.copyWith(
        status: 'queued',
        statusLog: '${build.statusLog}Retried by user.\n',
        heartbeatAt: DateTime.now().toUtc(),
      ),
    );
  }

  Future<AppWish> _ownedWish(Session session, int id) async {
    final owner = session.authenticated!.authUserId;
    final wish = await AppWish.db.findById(session, id);
    if (wish == null || wish.authUserId != owner) {
      throw StateError('Wish not found.');
    }
    return wish;
  }

  Future<AppBuild> _ownedBuild(Session session, int id) async {
    final build = await AppBuild.db.findById(session, id);
    if (build == null) throw StateError('Build not found.');
    await _ownedWish(session, build.wishId);
    return build;
  }
}
