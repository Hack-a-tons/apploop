import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/future_calls.dart';
import '../generated/protocol.dart';
import 'slugify.dart';

/// Store apps: one App Store Connect app record per wish.
///
/// Provisioning itself runs in [ProvisionAppFutureCall]; this endpoint only
/// records the intent (idempotently) and schedules the work.
class StoreAppEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Requests (or reuses) the store app for a wish owned by the caller.
  /// A failed provisioning is reset to pending and rescheduled.
  Future<StoreApp> requestApp(Session session, int wishId) async {
    final wish = await _ownedWish(session, wishId);

    final existing = await StoreApp.db.findFirstRow(
      session,
      where: (t) => t.wishId.equals(wishId),
    );
    if (existing != null) {
      if (existing.status == 'failed') {
        final retried = await StoreApp.db.updateRow(
          session,
          existing.copyWith(status: 'pending', statusLog: ''),
        );
        await _schedule(session, retried.id!);
        await _markProvisioning(session, wish);
        return retried;
      }
      return existing;
    }

    final prefix = session.passwords['appLoopBundlePrefix'] ?? '';
    final bundlePrefix = prefix.isEmpty ? 'com.hurated.loop' : prefix;
    final bundleId = await _uniqueBundleId(
      session,
      bundlePrefix,
      slugifyWishTitle(wish.title),
    );

    final app = await StoreApp.db.insertRow(
      session,
      StoreApp(
        wishId: wish.id!,
        bundleId: bundleId,
        sku: bundleId,
        appName: wish.title.length > 90
            ? wish.title.substring(0, 90)
            : wish.title,
      ),
    );
    await _markProvisioning(session, wish);
    await _schedule(session, app.id!);
    return app;
  }

  /// Returns the store app for a wish owned by the caller, if any.
  Future<StoreApp?> getStoreAppForWish(Session session, int wishId) async {
    await _ownedWish(session, wishId);
    return StoreApp.db.findFirstRow(
      session,
      where: (t) => t.wishId.equals(wishId),
    );
  }

  /// Sets the public TestFlight invite link for a store app owned by the
  /// caller (copied from App Store Connect; one link per app). Pass an
  /// empty link to clear it.
  Future<StoreApp> setTestflightLink(
    Session session,
    int storeAppId,
    String link,
  ) async {
    final app = await _ownedStoreApp(session, storeAppId);
    final clean = link.trim();
    if (clean.isNotEmpty) {
      final uri = Uri.tryParse(clean);
      if (uri == null ||
          uri.scheme != 'https' ||
          uri.host != 'testflight.apple.com') {
        throw ArgumentError(
          'Link must be an https://testflight.apple.com invite link.',
        );
      }
    }
    return StoreApp.db.updateRow(
      session,
      app.copyWith(testflightLink: clean),
    );
  }

  Future<String> _uniqueBundleId(
    Session session,
    String prefix,
    String base,
  ) async {
    var candidate = '$prefix.$base';
    var counter = 2;
    while (await StoreApp.db.findFirstRow(
          session,
          where: (t) => t.bundleId.equals(candidate),
        ) !=
        null) {
      candidate = '$prefix.$base-$counter';
      counter++;
    }
    return candidate;
  }

  Future<void> _markProvisioning(Session session, AppWish wish) async {
    if (wish.status == 'draft' || wish.status == 'failed') {
      await AppWish.db.updateRow(
        session,
        wish.copyWith(status: 'provisioning'),
      );
    }
  }

  Future<void> _schedule(Session session, int storeAppId) async {
    await session.serverpod.futureCalls
        .callWithDelay(const Duration(seconds: 5))
        .provisionApp
        .provisionApp(storeAppId);
  }

  Future<AppWish> _ownedWish(Session session, int id) async {
    final owner = session.authenticated!.authUserId;
    final wish = await AppWish.db.findById(session, id);
    if (wish == null || wish.authUserId != owner) {
      throw StateError('Wish not found.');
    }
    return wish;
  }

  Future<StoreApp> _ownedStoreApp(Session session, int id) async {
    final app = await StoreApp.db.findById(session, id);
    if (app == null) throw StateError('Store app not found.');
    await _ownedWish(session, app.wishId);
    return app;
  }
}
