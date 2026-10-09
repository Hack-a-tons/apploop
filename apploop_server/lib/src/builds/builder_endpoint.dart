import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Worker API for the Mac builder. No user login — every method takes
/// the shared builder token, which must match `builderToken` in
/// `config/passwords.yaml` (or the `SERVERPOD_PASSWORD_builderToken`
/// environment variable in CI). Fails closed when unconfigured.
class BuilderEndpoint extends Endpoint {
  /// Claims the next queued build (or a stale claim with no heartbeat
  /// for 30 minutes) and returns the work order, or null when idle.
  Future<BuildTask?> claimBuildTask(
    Session session,
    String builderToken,
  ) async {
    _checkToken(session, builderToken);

    var build = await AppBuild.db.findFirstRow(
      session,
      where: (t) => t.status.equals('queued'),
    );
    build ??= await _staleClaim(session);
    if (build == null) return null;

    build = await AppBuild.db.updateRow(
      session,
      build.copyWith(
        status: 'claimed',
        statusLog: '${build.statusLog}Claimed by builder.\n',
        heartbeatAt: DateTime.now().toUtc(),
      ),
    );
    return _taskFor(session, build);
  }

  /// Appends to the build log, updates status and heartbeat.
  Future<void> postBuildProgress(
    Session session,
    String builderToken,
    int buildId,
    String status,
    String logAppend,
  ) async {
    _checkToken(session, builderToken);
    const known = {
      'claimed',
      'generating',
      'building',
      'uploading',
      'processing',
    };
    if (!known.contains(status)) {
      throw ArgumentError.value(status, 'status', 'Unknown build status.');
    }
    final build = await _build(session, buildId);
    await AppBuild.db.updateRow(
      session,
      build.copyWith(
        status: status,
        statusLog: _capped(build.statusLog + logAppend),
        heartbeatAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Finishes a build as `ready` (on TestFlight) or `failed`.
  Future<void> completeBuild(
    Session session,
    String builderToken,
    int buildId,
    bool succeeded,
    String testflightState,
    String logAppend,
  ) async {
    _checkToken(session, builderToken);
    final build = await _build(session, buildId);
    final done = await AppBuild.db.updateRow(
      session,
      build.copyWith(
        status: succeeded ? 'ready' : 'failed',
        testflightState: testflightState,
        statusLog: _capped(build.statusLog + logAppend),
        heartbeatAt: DateTime.now().toUtc(),
      ),
    );
    final wish = await AppWish.db.findById(session, done.wishId);
    if (wish != null) {
      await AppWish.db.updateRow(
        session,
        wish.copyWith(status: succeeded ? 'testing' : 'provisioned'),
      );
    }
  }

  void _checkToken(Session session, String builderToken) {
    final expected = session.passwords['builderToken'] ?? '';
    if (expected.isEmpty || builderToken != expected) {
      throw StateError('Not authorized.');
    }
  }

  Future<AppBuild> _build(Session session, int buildId) async {
    final build = await AppBuild.db.findById(session, buildId);
    if (build == null) throw StateError('Build not found.');
    return build;
  }

  Future<AppBuild?> _staleClaim(Session session) async {
    final cutoff = DateTime.now().toUtc().subtract(
      const Duration(minutes: 30),
    );
    final claimed = await AppBuild.db.find(
      session,
      where: (t) => t.status.equals('claimed'),
    );
    for (final build in claimed) {
      if (build.heartbeatAt.isBefore(cutoff)) return build;
    }
    return null;
  }

  Future<BuildTask> _taskFor(Session session, AppBuild build) async {
    final wish = (await AppWish.db.findById(session, build.wishId))!;
    final storeApp = (await StoreApp.db.findById(session, build.storeAppId))!;
    final prefix = session.passwords['appLoopBundlePrefix'] ?? '';
    return BuildTask(
      build: build,
      wishTitle: wish.title,
      wishDescription: wish.descriptionText,
      bundleId: storeApp.bundleId,
      organization: prefix.isEmpty ? 'com.hurated.apploop' : prefix,
    );
  }
}

/// Keeps the stored log bounded; the tail is what matters.
String _capped(String log, {int maxLength = 100000}) {
  if (log.length <= maxLength) return log;
  return '…[truncated]…\n${log.substring(log.length - maxLength)}';
}
