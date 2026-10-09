import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import 'feedback_files.dart';

/// Test recordings: screen videos with spoken comments, plus audio-only
/// notes. Flow: `startRecording` → upload video and/or audio with the
/// issued descriptions → `completeRecording` → (F7) processing.
///
/// Paths are always derived server-side (`feedback/<user>/<id>/…`);
/// clients never choose paths or storage ids.
class FeedbackEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Starts a recording for a build owned by the caller.
  Future<FeedbackRecording> startRecording(Session session, int buildId) async {
    final build = await _ownedBuild(session, buildId);
    return FeedbackRecording.db.insertRow(
      session,
      FeedbackRecording(
        buildId: build.id!,
        authUserId: session.authenticated!.authUserId,
        status: 'uploading',
      ),
    );
  }

  /// Upload description for the screen video (.mov/.mp4, ≤ 500 MB).
  Future<String> getVideoUploadDescription(
    Session session,
    int recordingId,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    return session.storage.createUploadDescription(
      storageId: 'private',
      path: feedbackVideoPath(recording),
      options: UploadOptions(
        expirationDuration: const Duration(hours: 1),
        maxFileSize: 500 * 1024 * 1024,
      ),
    );
  }

  /// Upload description for the audio note (.m4a, ≤ 25 MB).
  Future<String> getAudioUploadDescription(
    Session session,
    int recordingId,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    return session.storage.createUploadDescription(
      storageId: 'private',
      path: feedbackAudioPath(recording),
      options: UploadOptions(
        expirationDuration: const Duration(hours: 1),
        maxFileSize: 25 * 1024 * 1024,
      ),
    );
  }

  /// Marks the upload done after verifying at least one file landed.
  /// Throws when nothing was uploaded (client should retry the upload).
  Future<FeedbackRecording> completeRecording(
    Session session,
    int recordingId,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    final hasVideo = await session.storage.fileExists(
      storageId: 'private',
      path: feedbackVideoPath(recording),
    );
    final hasAudio = await session.storage.fileExists(
      storageId: 'private',
      path: feedbackAudioPath(recording),
    );
    if (!hasVideo && !hasAudio) {
      throw StateError(
        'No video or audio found for this recording. Upload first.',
      );
    }
    return FeedbackRecording.db.updateRow(
      session,
      recording.copyWith(
        videoPath: hasVideo ? feedbackVideoPath(recording) : '',
        status: 'uploaded',
      ),
    );
  }

  /// Time-limited playback URL for the video or audio (`kind` is
  /// `video` or `audio`).
  Future<String> downloadUrl(
    Session session,
    int recordingId,
    String kind,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    final path = switch (kind) {
      'video' => recording.videoPath,
      'audio' => feedbackAudioPath(recording),
      _ => throw ArgumentError.value(kind, 'kind', 'Use video or audio.'),
    };
    if (path.isEmpty) throw StateError('No $kind attached to this recording.');
    final uri = await session.storage.temporaryDownloadUrl(
      storageId: 'private',
      path: path,
    );
    return uri.toString();
  }

  /// Time-limited URL for one processing screenshot of an owned
  /// recording.
  Future<String> screenshotUrl(
    Session session,
    int recordingId,
    String fileName,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    if (!isSafeShotName(fileName)) {
      throw ArgumentError.value(fileName, 'fileName', 'Unsafe name.');
    }
    final uri = await session.storage.temporaryDownloadUrl(
      storageId: 'private',
      path: feedbackShotPath(recording, fileName),
    );
    return uri.toString();
  }

  /// Lists the caller's recordings for one owned build, newest first.
  Future<List<FeedbackRecording>> listRecordings(
    Session session,
    int buildId,
  ) async {
    await _ownedBuild(session, buildId);
    return FeedbackRecording.db.find(
      session,
      where: (t) => t.buildId.equals(buildId),
      orderBy: (t) => t.id.desc(),
    );
  }

  /// Lists all of the caller's recordings across builds, newest first
  /// (powers the Feedback tab).
  Future<List<FeedbackRecording>> listMyRecordings(Session session) async {
    final owner = session.authenticated!.authUserId;
    final wishes = await AppWish.db.find(
      session,
      where: (t) => t.authUserId.equals(owner),
    );
    if (wishes.isEmpty) return [];
    final wishIds = wishes.map((w) => w.id!).toSet();
    final builds = await AppBuild.db.find(session);
    final buildIds = builds
        .where((b) => wishIds.contains(b.wishId))
        .map((b) => b.id!)
        .toSet();
    if (buildIds.isEmpty) return [];
    final recordings = await FeedbackRecording.db.find(session);
    final mine = recordings.where((r) => buildIds.contains(r.buildId)).toList()
      ..sort((a, b) => b.id!.compareTo(a.id!));
    return mine;
  }

  // ------------------------------------------------------------------
  // Comments (extracted issues + manual notes).
  // ------------------------------------------------------------------

  /// Lists comments of one owned recording, in creation order.
  Future<List<FeedbackComment>> listComments(
    Session session,
    int recordingId,
  ) async {
    await _ownedRecording(session, recordingId);
    return FeedbackComment.db.find(
      session,
      where: (t) => t.recordingId.equals(recordingId),
      orderBy: (t) => t.id,
    );
  }

  /// Adds a manual comment (`origin` is `voice` or `keyboard`).
  Future<FeedbackComment> addManualComment(
    Session session,
    int recordingId,
    String title,
    String text,
    String origin,
  ) async {
    final recording = await _ownedRecording(session, recordingId);
    if (title.trim().isEmpty) {
      throw ArgumentError('Comment title must not be empty.');
    }
    if (origin != 'voice' && origin != 'keyboard') {
      throw ArgumentError.value(origin, 'origin', 'Use voice or keyboard.');
    }
    return FeedbackComment.db.insertRow(
      session,
      FeedbackComment(
        recordingId: recording.id!,
        authUserId: session.authenticated!.authUserId,
        title: title.trim(),
        text: text.trim(),
        origin: origin,
      ),
    );
  }

  /// Edits title, text and severity of an owned comment.
  Future<FeedbackComment> editComment(
    Session session,
    int id,
    String title,
    String text,
    String severity,
  ) async {
    final comment = await _ownedComment(session, id);
    if (title.trim().isEmpty) {
      throw ArgumentError('Comment title must not be empty.');
    }
    if (!{'high', 'medium', 'low'}.contains(severity)) {
      throw ArgumentError.value(
        severity,
        'severity',
        'Use high, medium or low.',
      );
    }
    return FeedbackComment.db.updateRow(
      session,
      comment.copyWith(
        title: title.trim(),
        text: text.trim(),
        severity: severity,
      ),
    );
  }

  /// Marks an owned comment resolved or reopens it.
  Future<FeedbackComment> setResolved(
    Session session,
    int id,
    bool resolved,
  ) async {
    final comment = await _ownedComment(session, id);
    return FeedbackComment.db.updateRow(
      session,
      comment.copyWith(resolved: resolved),
    );
  }

  /// Deletes an owned comment.
  Future<void> deleteComment(Session session, int id) async {
    final comment = await _ownedComment(session, id);
    await FeedbackComment.db.deleteRow(session, comment);
  }

  Future<AppBuild> _ownedBuild(Session session, int buildId) async {
    final build = await AppBuild.db.findById(session, buildId);
    if (build == null) throw StateError('Build not found.');
    final owner = session.authenticated!.authUserId;
    final wish = await AppWish.db.findById(session, build.wishId);
    if (wish == null || wish.authUserId != owner) {
      throw StateError('Build not found.');
    }
    return build;
  }

  Future<FeedbackRecording> _ownedRecording(
    Session session,
    int recordingId,
  ) async {
    final recording = await FeedbackRecording.db.findById(
      session,
      recordingId,
    );
    if (recording == null) throw StateError('Recording not found.');
    await _ownedBuild(session, recording.buildId);
    return recording;
  }

  Future<FeedbackComment> _ownedComment(Session session, int id) async {
    final comment = await FeedbackComment.db.findById(session, id);
    if (comment == null) throw StateError('Comment not found.');
    await _ownedRecording(session, comment.recordingId);
    return comment;
  }
}
