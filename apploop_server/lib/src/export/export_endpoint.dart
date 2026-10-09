import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'wish_export.dart';

/// Export: the whole loop of a wish as one Markdown document.
/// Owner-checked like everything else; nothing leaves the server except
/// to the user who owns it.
class ExportEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Returns the Markdown export of a wish owned by the caller.
  Future<String> exportWish(Session session, int wishId) async {
    final owner = session.authenticated!.authUserId;
    final wish = await AppWish.db.findById(session, wishId);
    if (wish == null || wish.authUserId != owner) {
      throw StateError('Wish not found.');
    }

    final storeApp = await StoreApp.db.findFirstRow(
      session,
      where: (t) => t.wishId.equals(wishId),
    );
    final builds = await AppBuild.db.find(
      session,
      where: (t) => t.wishId.equals(wishId),
      orderBy: (t) => t.iteration,
    );

    final recordingsByBuild = <int, List<FeedbackRecording>>{};
    final commentsByRecording = <int, List<FeedbackComment>>{};
    for (final build in builds) {
      final recordings = await FeedbackRecording.db.find(
        session,
        where: (t) => t.buildId.equals(build.id!),
        orderBy: (t) => t.id,
      );
      recordingsByBuild[build.id!] = recordings;
      for (final recording in recordings) {
        commentsByRecording[recording.id!] = await FeedbackComment.db.find(
          session,
          where: (t) => t.recordingId.equals(recording.id!),
          orderBy: (t) => t.id,
        );
      }
    }

    return buildWishExport(
      wish: wish,
      storeApp: storeApp,
      builds: builds,
      recordingsByBuild: recordingsByBuild,
      commentsByRecording: commentsByRecording,
      exportedAt: DateTime.now(),
    );
  }
}
