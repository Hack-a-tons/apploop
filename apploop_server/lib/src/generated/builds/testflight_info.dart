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
import 'package:serverpod/serverpod.dart' as _is;

abstract class TestflightInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TestflightInfo._({
    required this.buildNumber,
    required this.version,
    required this.status,
    required this.testflightState,
    required this.installUrl,
  });

  factory TestflightInfo({
    required int buildNumber,
    required String version,
    required String status,
    required String testflightState,
    required String installUrl,
  }) = _TestflightInfoImpl;

  factory TestflightInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return TestflightInfo(
      buildNumber: jsonSerialization['buildNumber'] as int,
      version: jsonSerialization['version'] as String,
      status: jsonSerialization['status'] as String,
      testflightState: jsonSerialization['testflightState'] as String,
      installUrl: jsonSerialization['installUrl'] as String,
    );
  }

  /// TestFlight build number.
  int buildNumber;

  /// Marketing version, e.g. 1.0.
  String version;

  /// Build pipeline status (queued … ready, failed).
  String status;

  /// Apple's processing state mirror (e.g. READY, PROCESSING).
  String testflightState;

  /// Public TestFlight invite link, empty until the owner sets it.
  String installUrl;

  /// Returns a shallow copy of this [TestflightInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TestflightInfo copyWith({
    int? buildNumber,
    String? version,
    String? status,
    String? testflightState,
    String? installUrl,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TestflightInfo',
      'buildNumber': buildNumber,
      'version': version,
      'status': status,
      'testflightState': testflightState,
      'installUrl': installUrl,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TestflightInfo',
      'buildNumber': buildNumber,
      'version': version,
      'status': status,
      'testflightState': testflightState,
      'installUrl': installUrl,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TestflightInfoImpl extends TestflightInfo {
  _TestflightInfoImpl({
    required int buildNumber,
    required String version,
    required String status,
    required String testflightState,
    required String installUrl,
  }) : super._(
         buildNumber: buildNumber,
         version: version,
         status: status,
         testflightState: testflightState,
         installUrl: installUrl,
       );

  /// Returns a shallow copy of this [TestflightInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TestflightInfo copyWith({
    int? buildNumber,
    String? version,
    String? status,
    String? testflightState,
    String? installUrl,
  }) {
    return TestflightInfo(
      buildNumber: buildNumber ?? this.buildNumber,
      version: version ?? this.version,
      status: status ?? this.status,
      testflightState: testflightState ?? this.testflightState,
      installUrl: installUrl ?? this.installUrl,
    );
  }
}
