import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';
import 'feedback_files.dart';

/// Builder worker API for feedback processing. No user login — every
/// method takes the shared builder token, which must match
/// `builderToken` in `config/passwords.yaml` (or the
/// `SERVERPOD_PASSWORD_builderToken` environment variable in CI).
/// Fails closed when unconfigured.
class FeedbackBuilderEndpoint extends Endpoint {
  /// Claims the next uploaded recording for processing and returns the
  /// work order with time-limited file URLs, or null when idle.
  Future<RecordingTask?> claimRecordingTask(
    Session session,
    String builderToken,
  ) async {
    _checkBuilderToken(session, builderToken);
    final recording = await FeedbackRecording.db.findFirstRow(
      session,
      where: (t) => t.status.equals('uploaded'),
    );
    if (recording == null) return null;
    await FeedbackRecording.db.updateRow(
      session,
      recording.copyWith(status: 'processing'),
    );
    var audioUrl = '';
    if (await session.storage.fileExists(
      storageId: 'private',
      path: feedbackAudioPath(recording),
    )) {
      audioUrl = (await session.storage.temporaryDownloadUrl(
        storageId: 'private',
        path: feedbackAudioPath(recording),
      )).toString();
    }
    return RecordingTask(
      recording: recording,
      videoUrl: recording.videoPath.isEmpty
          ? ''
          : (await session.storage.temporaryDownloadUrl(
              storageId: 'private',
              path: recording.videoPath,
            )).toString(),
      audioUrl: audioUrl,
    );
  }

  /// Upload description for one processing screenshot (`shots/<name>`).
  /// Names are restricted to safe `.jpg` basenames.
  Future<String> getScreenshotUploadDescription(
    Session session,
    String builderToken,
    int recordingId,
    String fileName,
  ) async {
    _checkBuilderToken(session, builderToken);
    final recording = await FeedbackRecording.db.findById(
      session,
      recordingId,
    );
    if (recording == null) throw StateError('Recording not found.');
    if (!isSafeShotName(fileName)) {
      throw ArgumentError.value(fileName, 'fileName', 'Unsafe name.');
    }
    return session.storage.createUploadDescription(
      storageId: 'private',
      path: feedbackShotPath(recording, fileName),
      options: UploadOptions(
        expirationDuration: const Duration(hours: 1),
        maxFileSize: 2 * 1024 * 1024,
      ),
    );
  }

  /// Stores the processing result: transcript, normalized issues and one
  /// comment per issue. `screenshotByIssue[i]` names the uploaded shot
  /// for issue `i` (verified to exist; unmapped issues get none).
  Future<FeedbackRecording> completeRecordingProcessing(
    Session session,
    String builderToken,
    int recordingId,
    String transcript,
    String issuesJson,
    List<String> screenshotByIssue,
  ) async {
    _checkBuilderToken(session, builderToken);
    final recording = await FeedbackRecording.db.findById(
      session,
      recordingId,
    );
    if (recording == null) throw StateError('Recording not found.');
    final issues = _parseIssues(issuesJson);
    if (issues.length > 60) {
      throw ArgumentError('Too many issues (max 60).');
    }

    for (var i = 0; i < issues.length; i++) {
      final issue = issues[i];
      final shot = i < screenshotByIssue.length ? screenshotByIssue[i] : '';
      var shotPath = '';
      if (shot.isNotEmpty) {
        if (!isSafeShotName(shot)) {
          throw ArgumentError.value(shot, 'screenshotByIssue', 'Unsafe.');
        }
        shotPath = feedbackShotPath(recording, shot);
        final exists = await session.storage.fileExists(
          storageId: 'private',
          path: shotPath,
        );
        if (!exists) {
          throw StateError('Screenshot $shot was not uploaded.');
        }
      }
      final quote = issue['quote'] as String? ?? '';
      final fix = issue['fix'] as String? ?? '';
      await FeedbackComment.db.insertRow(
        session,
        FeedbackComment(
          recordingId: recording.id!,
          authUserId: recording.authUserId,
          title: issue['title'] as String,
          text: fix.isEmpty ? quote : '$quote\nSuggested fix: $fix',
          severity: issue['severity'] as String,
          timestamps: (issue['timestamps'] as List).join(', '),
          screenshotPath: shotPath,
          origin: 'extracted',
        ),
      );
    }

    return FeedbackRecording.db.updateRow(
      session,
      recording.copyWith(
        transcript: transcript,
        issuesJson: jsonEncode(issues),
        status: 'ready',
      ),
    );
  }

  /// Parses and normalizes the worker's issues JSON into the canonical
  /// list of {title, severity, timestamps, quote, fix} maps.
  List<Map<String, dynamic>> _parseIssues(String issuesJson) {
    dynamic decoded;
    try {
      decoded = jsonDecode(issuesJson);
    } on FormatException {
      throw ArgumentError('Issues must be a JSON list.');
    }
    if (decoded is! List) {
      throw ArgumentError('Issues must be a JSON list.');
    }
    final issues = <Map<String, dynamic>>[];
    for (final entry in decoded) {
      if (entry is! Map) throw ArgumentError('Each issue must be an object.');
      final title = (entry['title'] ?? '').toString().trim();
      if (title.isEmpty) throw ArgumentError('Each issue needs a title.');
      var severity = (entry['severity'] ?? 'medium').toString();
      if (!{'high', 'medium', 'low'}.contains(severity)) severity = 'medium';
      final rawStamps = entry['timestamps'];
      final stamps = rawStamps is List
          ? rawStamps.map((s) => s.toString()).toList()
          : [rawStamps.toString()];
      issues.add({
        'title': title,
        'severity': severity,
        'timestamps': stamps,
        'quote': (entry['quote'] ?? '').toString(),
        'fix': (entry['fix'] ?? '').toString(),
      });
    }
    return issues;
  }

  void _checkBuilderToken(Session session, String builderToken) {
    final expected = session.passwords['builderToken'] ?? '';
    if (expected.isEmpty || builderToken != expected) {
      throw StateError('Not authorized.');
    }
  }
}
