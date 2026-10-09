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
import 'package:apploop_client/src/protocol/protocol.dart' as _ib88ok8n;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../feedback/feedback_recording.dart' as _iema6dlf;

abstract class FeedbackComment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackComment._({
    this.id,
    required this.recordingId,
    this.recording,
    required this.authUserId,
    this.authUser,
    required this.title,
    String? text,
    String? audioPath,
    String? screenshotPath,
    String? severity,
    String? timestamps,
    String? origin,
    bool? resolved,
  }) : text = text ?? '',
       audioPath = audioPath ?? '',
       screenshotPath = screenshotPath ?? '',
       severity = severity ?? 'medium',
       timestamps = timestamps ?? '',
       origin = origin ?? 'keyboard',
       resolved = resolved ?? false;

  factory FeedbackComment({
    int? id,
    required int recordingId,
    _iema6dlf.FeedbackRecording? recording,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String title,
    String? text,
    String? audioPath,
    String? screenshotPath,
    String? severity,
    String? timestamps,
    String? origin,
    bool? resolved,
  }) = _FeedbackCommentImpl;

  factory FeedbackComment.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackComment(
      id: jsonSerialization['id'] as int?,
      recordingId: jsonSerialization['recordingId'] as int,
      recording: jsonSerialization['recording'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_iema6dlf.FeedbackRecording>(
              jsonSerialization['recording'],
            ),
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      title: jsonSerialization['title'] as String,
      text: jsonSerialization['text'] as String?,
      audioPath: jsonSerialization['audioPath'] as String?,
      screenshotPath: jsonSerialization['screenshotPath'] as String?,
      severity: jsonSerialization['severity'] as String?,
      timestamps: jsonSerialization['timestamps'] as String?,
      origin: jsonSerialization['origin'] as String?,
      resolved: jsonSerialization['resolved'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int recordingId;

  /// The recording this comment belongs to.
  _iema6dlf.FeedbackRecording? recording;

  _isc.UuidValue authUserId;

  /// The authenticated user who owns this comment.
  _iacc.AuthUser? authUser;

  /// Short summary of the issue.
  String title;

  /// Editable comment text.
  String text;

  /// Storage path of an attached audio note.
  String audioPath;

  /// Storage path of an attached screenshot.
  String screenshotPath;

  /// high, medium or low.
  String severity;

  /// Timestamps in the recording this comment refers to.
  String timestamps;

  /// How the comment was created: voice, keyboard or extracted.
  String origin;

  /// Whether the issue is resolved.
  bool resolved;

  /// Returns a shallow copy of this [FeedbackComment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackComment copyWith({
    int? id,
    int? recordingId,
    _iema6dlf.FeedbackRecording? recording,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? title,
    String? text,
    String? audioPath,
    String? screenshotPath,
    String? severity,
    String? timestamps,
    String? origin,
    bool? resolved,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackComment',
      if (id != null) 'id': id,
      'recordingId': recordingId,
      if (recording != null) 'recording': recording?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'title': title,
      'text': text,
      'audioPath': audioPath,
      'screenshotPath': screenshotPath,
      'severity': severity,
      'timestamps': timestamps,
      'origin': origin,
      'resolved': resolved,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackComment',
      if (id != null) 'id': id,
      'recordingId': recordingId,
      if (recording != null) 'recording': recording?.toJsonForProtocol(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'title': title,
      'text': text,
      'audioPath': audioPath,
      'screenshotPath': screenshotPath,
      'severity': severity,
      'timestamps': timestamps,
      'origin': origin,
      'resolved': resolved,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackCommentImpl extends FeedbackComment {
  _FeedbackCommentImpl({
    int? id,
    required int recordingId,
    _iema6dlf.FeedbackRecording? recording,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String title,
    String? text,
    String? audioPath,
    String? screenshotPath,
    String? severity,
    String? timestamps,
    String? origin,
    bool? resolved,
  }) : super._(
         id: id,
         recordingId: recordingId,
         recording: recording,
         authUserId: authUserId,
         authUser: authUser,
         title: title,
         text: text,
         audioPath: audioPath,
         screenshotPath: screenshotPath,
         severity: severity,
         timestamps: timestamps,
         origin: origin,
         resolved: resolved,
       );

  /// Returns a shallow copy of this [FeedbackComment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackComment copyWith({
    Object? id = _Undefined,
    int? recordingId,
    Object? recording = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? title,
    String? text,
    String? audioPath,
    String? screenshotPath,
    String? severity,
    String? timestamps,
    String? origin,
    bool? resolved,
  }) {
    return FeedbackComment(
      id: id is int? ? id : this.id,
      recordingId: recordingId ?? this.recordingId,
      recording: recording is _iema6dlf.FeedbackRecording?
          ? recording
          : this.recording?.copyWith(),
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      title: title ?? this.title,
      text: text ?? this.text,
      audioPath: audioPath ?? this.audioPath,
      screenshotPath: screenshotPath ?? this.screenshotPath,
      severity: severity ?? this.severity,
      timestamps: timestamps ?? this.timestamps,
      origin: origin ?? this.origin,
      resolved: resolved ?? this.resolved,
    );
  }
}
