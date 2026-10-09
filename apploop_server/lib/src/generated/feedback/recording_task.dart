/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:apploop_server/src/generated/protocol.dart' as _ipso8wor;
import 'package:serverpod/serverpod.dart' as _is;
import '../feedback/feedback_recording.dart' as _iema6dlf;

abstract class RecordingTask
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RecordingTask._({
    required this.recording,
    required this.videoUrl,
    required this.audioUrl,
  });

  factory RecordingTask({
    required _iema6dlf.FeedbackRecording recording,
    required String videoUrl,
    required String audioUrl,
  }) = _RecordingTaskImpl;

  factory RecordingTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return RecordingTask(
      recording: _ipso8wor.Protocol().deserialize<_iema6dlf.FeedbackRecording>(
        jsonSerialization['recording'],
      ),
      videoUrl: jsonSerialization['videoUrl'] as String,
      audioUrl: jsonSerialization['audioUrl'] as String,
    );
  }

  /// The recording to process.
  _iema6dlf.FeedbackRecording recording;

  /// Time-limited video URL, empty when no video was uploaded.
  String videoUrl;

  /// Time-limited audio URL, empty when no audio was uploaded.
  String audioUrl;

  /// Returns a shallow copy of this [RecordingTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RecordingTask copyWith({
    _iema6dlf.FeedbackRecording? recording,
    String? videoUrl,
    String? audioUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RecordingTask',
      'recording': recording.toJson(),
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RecordingTask',
      'recording': recording.toJsonForProtocol(),
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RecordingTaskImpl extends RecordingTask {
  _RecordingTaskImpl({
    required _iema6dlf.FeedbackRecording recording,
    required String videoUrl,
    required String audioUrl,
  }) : super._(
         recording: recording,
         videoUrl: videoUrl,
         audioUrl: audioUrl,
       );

  /// Returns a shallow copy of this [RecordingTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RecordingTask copyWith({
    _iema6dlf.FeedbackRecording? recording,
    String? videoUrl,
    String? audioUrl,
  }) {
    return RecordingTask(
      recording: recording ?? this.recording.copyWith(),
      videoUrl: videoUrl ?? this.videoUrl,
      audioUrl: audioUrl ?? this.audioUrl,
    );
  }
}
