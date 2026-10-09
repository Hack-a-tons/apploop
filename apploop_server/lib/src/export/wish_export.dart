import '../generated/protocol.dart';

/// Renders one wish's whole loop as Markdown: wish, store app, builds
/// with TestFlight links, recordings with transcripts, and comments
/// with resolutions. Pure function — fully unit-testable.
String buildWishExport({
  required AppWish wish,
  required StoreApp? storeApp,
  required List<AppBuild> builds,
  required Map<int, List<FeedbackRecording>> recordingsByBuild,
  required Map<int, List<FeedbackComment>> commentsByRecording,
  required DateTime exportedAt,
}) {
  final out = StringBuffer();
  out.writeln('# ${wish.title}');
  out.writeln();
  if (wish.descriptionText.isNotEmpty) {
    out.writeln(wish.descriptionText);
    out.writeln();
  }
  out.writeln('- Status: ${wish.status}');
  out.writeln('- Iterations: ${wish.currentIteration}');
  out.writeln('- Exported: ${exportedAt.toUtc().toIso8601String()}');
  out.writeln();

  if (storeApp != null) {
    out.writeln('## TestFlight app');
    out.writeln();
    out.writeln('- Bundle id: `${storeApp.bundleId}`');
    if (storeApp.ascAppId.isNotEmpty) {
      out.writeln('- App Store Connect id: ${storeApp.ascAppId}');
    }
    if (storeApp.testflightLink.isNotEmpty) {
      out.writeln('- Invite link: ${storeApp.testflightLink}');
    }
    out.writeln('- Provisioning: ${storeApp.status}');
    out.writeln();
  }

  for (final build in builds) {
    out.writeln(
      '## Iteration ${build.iteration} — build ${build.buildNumber} '
      '(v${build.version})',
    );
    out.writeln();
    out.writeln('- Status: ${build.status}');
    if (build.testflightState.isNotEmpty) {
      out.writeln('- TestFlight state: ${build.testflightState}');
    }
    if (storeApp != null && storeApp.testflightLink.isNotEmpty) {
      out.writeln('- Install: ${storeApp.testflightLink}');
    }
    out.writeln();

    final recordings = recordingsByBuild[build.id] ?? const [];
    for (final recording in recordings) {
      out.writeln('### Recording ${recording.id} (${recording.status})');
      out.writeln();
      if (recording.transcript.isNotEmpty) {
        out.writeln('Transcript:');
        out.writeln();
        out.writeln('```');
        out.writeln(recording.transcript);
        out.writeln('```');
        out.writeln();
      }
      final comments = commentsByRecording[recording.id] ?? const [];
      for (final comment in comments) {
        final box = comment.resolved ? 'x' : ' ';
        out.writeln(
          '- [$box] **${comment.severity}** ${comment.title}'
          '${comment.timestamps.isNotEmpty ? ' (${comment.timestamps})' : ''}',
        );
        if (comment.text.isNotEmpty) {
          for (final line in comment.text.split('\n')) {
            out.writeln('  $line');
          }
        }
      }
      if (comments.isNotEmpty) out.writeln();
    }
  }

  out.writeln('---');
  out.writeln('Exported from AppLoop.');
  return out.toString();
}
