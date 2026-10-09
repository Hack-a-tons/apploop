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
import '../builds/app_build.dart' as _inhfbybr;

abstract class FeedbackRecording
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  FeedbackRecording._({
    this.id,
    required this.buildId,
    this.build,
    required this.authUserId,
    this.authUser,
    String? videoPath,
    String? transcript,
    String? issuesJson,
    String? status,
  }) : videoPath = videoPath ?? '',
       transcript = transcript ?? '',
       issuesJson = issuesJson ?? '[]',
       status = status ?? 'uploaded';

  factory FeedbackRecording({
    int? id,
    required int buildId,
    _inhfbybr.AppBuild? build,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    String? videoPath,
    String? transcript,
    String? issuesJson,
    String? status,
  }) = _FeedbackRecordingImpl;

  factory FeedbackRecording.fromJson(Map<String, dynamic> jsonSerialization) {
    return FeedbackRecording(
      id: jsonSerialization['id'] as int?,
      buildId: jsonSerialization['buildId'] as int,
      build: jsonSerialization['build'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_inhfbybr.AppBuild>(
              jsonSerialization['build'],
            ),
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      videoPath: jsonSerialization['videoPath'] as String?,
      transcript: jsonSerialization['transcript'] as String?,
      issuesJson: jsonSerialization['issuesJson'] as String?,
      status: jsonSerialization['status'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int buildId;

  /// The build that was tested in this recording.
  _inhfbybr.AppBuild? build;

  _isc.UuidValue authUserId;

  /// The authenticated user who recorded and owns this recording.
  _iacc.AuthUser? authUser;

  /// Storage path of the uploaded video file.
  String videoPath;

  /// Verbatim transcript of the spoken comments.
  String transcript;

  /// Extracted issues as JSON list
  /// [{title, severity, timestamps, quote, fix}].
  String issuesJson;

  /// Processing status: uploading, uploaded, processing, ready, failed.
  String status;

  /// Returns a shallow copy of this [FeedbackRecording]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  FeedbackRecording copyWith({
    int? id,
    int? buildId,
    _inhfbybr.AppBuild? build,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? videoPath,
    String? transcript,
    String? issuesJson,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FeedbackRecording',
      if (id != null) 'id': id,
      'buildId': buildId,
      if (build != null) 'build': build?.toJson(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'videoPath': videoPath,
      'transcript': transcript,
      'issuesJson': issuesJson,
      'status': status,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FeedbackRecording',
      if (id != null) 'id': id,
      'buildId': buildId,
      if (build != null) 'build': build?.toJsonForProtocol(),
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'videoPath': videoPath,
      'transcript': transcript,
      'issuesJson': issuesJson,
      'status': status,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackRecordingImpl extends FeedbackRecording {
  _FeedbackRecordingImpl({
    int? id,
    required int buildId,
    _inhfbybr.AppBuild? build,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    String? videoPath,
    String? transcript,
    String? issuesJson,
    String? status,
  }) : super._(
         id: id,
         buildId: buildId,
         build: build,
         authUserId: authUserId,
         authUser: authUser,
         videoPath: videoPath,
         transcript: transcript,
         issuesJson: issuesJson,
         status: status,
       );

  /// Returns a shallow copy of this [FeedbackRecording]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  FeedbackRecording copyWith({
    Object? id = _Undefined,
    int? buildId,
    Object? build = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? videoPath,
    String? transcript,
    String? issuesJson,
    String? status,
  }) {
    return FeedbackRecording(
      id: id is int? ? id : this.id,
      buildId: buildId ?? this.buildId,
      build: build is _inhfbybr.AppBuild? ? build : this.build?.copyWith(),
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      videoPath: videoPath ?? this.videoPath,
      transcript: transcript ?? this.transcript,
      issuesJson: issuesJson ?? this.issuesJson,
      status: status ?? this.status,
    );
  }
}
