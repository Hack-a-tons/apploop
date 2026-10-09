import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

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
      path: _videoPath(recording),
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
      path: _audioPath(recording),
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
      path: _videoPath(recording),
    );
    final hasAudio = await session.storage.fileExists(
      storageId: 'private',
      path: _audioPath(recording),
    );
    if (!hasVideo && !hasAudio) {
      throw StateError(
        'No video or audio found for this recording. Upload first.',
      );
    }
    return FeedbackRecording.db.updateRow(
      session,
      recording.copyWith(
        videoPath: hasVideo ? _videoPath(recording) : '',
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
      'audio' => _audioPath(recording),
      _ => throw ArgumentError.value(kind, 'kind', 'Use video or audio.'),
    };
    if (path.isEmpty) throw StateError('No $kind attached to this recording.');
    final uri = await session.storage.temporaryDownloadUrl(
      storageId: 'private',
      path: path,
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

  String _videoPath(FeedbackRecording recording) =>
      'feedback/${recording.authUserId}/${recording.id}/video.mov';

  String _audioPath(FeedbackRecording recording) =>
      'feedback/${recording.authUserId}/${recording.id}/audio.m4a';

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
}
