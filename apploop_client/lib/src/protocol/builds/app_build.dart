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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../store/store_app.dart' as _iri2eblp;
import '../wishes/wish.dart' as _ionsu37y;

abstract class AppBuild
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppBuild._({
    this.id,
    required this.wishId,
    this.wish,
    required this.storeAppId,
    this.storeApp,
    required this.iteration,
    int? buildNumber,
    String? version,
    String? status,
    String? statusLog,
    String? testflightState,
  }) : buildNumber = buildNumber ?? 0,
       version = version ?? '1.0',
       status = status ?? 'queued',
       statusLog = statusLog ?? '',
       testflightState = testflightState ?? '';

  factory AppBuild({
    int? id,
    required int wishId,
    _ionsu37y.AppWish? wish,
    required int storeAppId,
    _iri2eblp.StoreApp? storeApp,
    required int iteration,
    int? buildNumber,
    String? version,
    String? status,
    String? statusLog,
    String? testflightState,
  }) = _AppBuildImpl;

  factory AppBuild.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppBuild(
      id: jsonSerialization['id'] as int?,
      wishId: jsonSerialization['wishId'] as int,
      wish: jsonSerialization['wish'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_ionsu37y.AppWish>(
              jsonSerialization['wish'],
            ),
      storeAppId: jsonSerialization['storeAppId'] as int,
      storeApp: jsonSerialization['storeApp'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_iri2eblp.StoreApp>(
              jsonSerialization['storeApp'],
            ),
      iteration: jsonSerialization['iteration'] as int,
      buildNumber: jsonSerialization['buildNumber'] as int?,
      version: jsonSerialization['version'] as String?,
      status: jsonSerialization['status'] as String?,
      statusLog: jsonSerialization['statusLog'] as String?,
      testflightState: jsonSerialization['testflightState'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int wishId;

  /// The wish this build belongs to.
  _ionsu37y.AppWish? wish;

  int storeAppId;

  /// The store app this build is uploaded to.
  _iri2eblp.StoreApp? storeApp;

  /// Loop iteration this build was produced for.
  int iteration;

  /// TestFlight build number (latest on TestFlight + 1).
  int buildNumber;

  /// Marketing version, e.g. 1.0.
  String version;

  /// Pipeline status: queued, claimed, generating, building, uploading,
  /// processing, ready, failed.
  String status;

  /// Append-only log of the build pipeline.
  String statusLog;

  /// Mirror of Apple's external build state (e.g. ready, processing).
  String testflightState;

  /// Returns a shallow copy of this [AppBuild]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppBuild copyWith({
    int? id,
    int? wishId,
    _ionsu37y.AppWish? wish,
    int? storeAppId,
    _iri2eblp.StoreApp? storeApp,
    int? iteration,
    int? buildNumber,
    String? version,
    String? status,
    String? statusLog,
    String? testflightState,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppBuild',
      if (id != null) 'id': id,
      'wishId': wishId,
      if (wish != null) 'wish': wish?.toJson(),
      'storeAppId': storeAppId,
      if (storeApp != null) 'storeApp': storeApp?.toJson(),
      'iteration': iteration,
      'buildNumber': buildNumber,
      'version': version,
      'status': status,
      'statusLog': statusLog,
      'testflightState': testflightState,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppBuild',
      if (id != null) 'id': id,
      'wishId': wishId,
      if (wish != null) 'wish': wish?.toJsonForProtocol(),
      'storeAppId': storeAppId,
      if (storeApp != null) 'storeApp': storeApp?.toJsonForProtocol(),
      'iteration': iteration,
      'buildNumber': buildNumber,
      'version': version,
      'status': status,
      'statusLog': statusLog,
      'testflightState': testflightState,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppBuildImpl extends AppBuild {
  _AppBuildImpl({
    int? id,
    required int wishId,
    _ionsu37y.AppWish? wish,
    required int storeAppId,
    _iri2eblp.StoreApp? storeApp,
    required int iteration,
    int? buildNumber,
    String? version,
    String? status,
    String? statusLog,
    String? testflightState,
  }) : super._(
         id: id,
         wishId: wishId,
         wish: wish,
         storeAppId: storeAppId,
         storeApp: storeApp,
         iteration: iteration,
         buildNumber: buildNumber,
         version: version,
         status: status,
         statusLog: statusLog,
         testflightState: testflightState,
       );

  /// Returns a shallow copy of this [AppBuild]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppBuild copyWith({
    Object? id = _Undefined,
    int? wishId,
    Object? wish = _Undefined,
    int? storeAppId,
    Object? storeApp = _Undefined,
    int? iteration,
    int? buildNumber,
    String? version,
    String? status,
    String? statusLog,
    String? testflightState,
  }) {
    return AppBuild(
      id: id is int? ? id : this.id,
      wishId: wishId ?? this.wishId,
      wish: wish is _ionsu37y.AppWish? ? wish : this.wish?.copyWith(),
      storeAppId: storeAppId ?? this.storeAppId,
      storeApp: storeApp is _iri2eblp.StoreApp?
          ? storeApp
          : this.storeApp?.copyWith(),
      iteration: iteration ?? this.iteration,
      buildNumber: buildNumber ?? this.buildNumber,
      version: version ?? this.version,
      status: status ?? this.status,
      statusLog: statusLog ?? this.statusLog,
      testflightState: testflightState ?? this.testflightState,
    );
  }
}
