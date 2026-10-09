import '../generated/protocol.dart';

/// Storage paths for feedback files. Always derived server-side from
/// trusted state — clients never choose paths.
String feedbackVideoPath(FeedbackRecording recording) =>
    'feedback/${recording.authUserId}/${recording.id}/video.mov';

String feedbackAudioPath(FeedbackRecording recording) =>
    'feedback/${recording.authUserId}/${recording.id}/audio.m4a';

String feedbackShotPath(FeedbackRecording recording, String fileName) =>
    'feedback/${recording.authUserId}/${recording.id}/shots/$fileName';

/// Screenshot names are restricted to safe `.jpg` basenames.
bool isSafeShotName(String fileName) =>
    RegExp(r'^[A-Za-z0-9_-]+\.jpg$').hasMatch(fileName);
