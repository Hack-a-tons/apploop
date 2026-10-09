import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'asc_api.dart';

/// Provisions one App Store Connect app per wish in the background.
///
/// Idempotent: re-running for an already-ready app is a no-op, and every
/// Apple-side step is find-or-create, so retries never duplicate apps.
/// Without Apple credentials the call fails gracefully (status `failed`
/// with setup instructions in the log) instead of touching the network.
class ProvisionAppFutureCall extends FutureCall {
  Future<void> provisionApp(Session session, int storeAppId) async {
    var app = await StoreApp.db.findById(session, storeAppId);
    if (app == null) {
      session.log('provisionApp: store app $storeAppId no longer exists.');
      return;
    }
    if (app.status == 'ready') return;

    Future<void> update(String status, String logLine) async {
      app = app!.copyWith(
        status: status,
        statusLog: '${app!.statusLog}$logLine\n',
      );
      await StoreApp.db.updateRow(session, app!);
    }

    await update('creating', 'Starting provisioning for ${app!.bundleId}.');

    final creds = AppleCredentials.fromPasswords(session.passwords);
    if (!creds.isConfigured) {
      await update(
        'failed',
        'Apple credentials not configured. Add ascKeyId, ascIssuerId and '
            'ascPrivateKey to config/passwords.yaml (git-ignored).',
      );
      return;
    }

    final api = AppStoreConnectApi(creds);
    try {
      var bundleResourceId = await api.findBundleId(app!.bundleId);
      if (bundleResourceId == null) {
        await update('creating', 'Registering bundle id ${app!.bundleId}.');
        bundleResourceId = await api.registerBundleId(
          identifier: app!.bundleId,
          name: app!.appName,
        );
      } else {
        await update(
          'creating',
          'Bundle id ${app!.bundleId} already registered.',
        );
      }

      final existing = await api.findAppByBundleId(app!.bundleId);
      final String ascAppId;
      if (existing != null) {
        ascAppId = existing['id']!;
        await update('creating', 'App record already exists ($ascAppId).');
      } else {
        await update('creating', 'Creating app "${app!.appName}".');
        ascAppId = await api.createApp(
          bundleIdResourceId: bundleResourceId,
          name: app!.appName,
          sku: app!.sku,
        );
      }

      app = app!.copyWith(ascAppId: ascAppId, status: 'ready');
      await StoreApp.db.updateRow(session, app!);
      await update('ready', 'Provisioned. App Store Connect id $ascAppId.');

      final wish = await AppWish.db.findById(session, app!.wishId);
      if (wish != null && wish.status == 'provisioning') {
        await AppWish.db.updateRow(
          session,
          wish.copyWith(status: 'provisioned'),
        );
      }
    } catch (e) {
      // e.toString() carries only Apple's error payloads, never our key.
      await update('failed', 'Provisioning failed: $e');
    } finally {
      api.close();
    }
  }
}
