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
import '../wishes/wish.dart' as _ionsu37y;

abstract class StoreApp
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  StoreApp._({
    this.id,
    required this.wishId,
    this.wish,
    required this.bundleId,
    String? ascAppId,
    required this.sku,
    required this.appName,
    String? status,
    String? statusLog,
    String? testflightLink,
  }) : ascAppId = ascAppId ?? '',
       status = status ?? 'pending',
       statusLog = statusLog ?? '',
       testflightLink = testflightLink ?? '';

  factory StoreApp({
    int? id,
    required int wishId,
    _ionsu37y.AppWish? wish,
    required String bundleId,
    String? ascAppId,
    required String sku,
    required String appName,
    String? status,
    String? statusLog,
    String? testflightLink,
  }) = _StoreAppImpl;

  factory StoreApp.fromJson(Map<String, dynamic> jsonSerialization) {
    return StoreApp(
      id: jsonSerialization['id'] as int?,
      wishId: jsonSerialization['wishId'] as int,
      wish: jsonSerialization['wish'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_ionsu37y.AppWish>(
              jsonSerialization['wish'],
            ),
      bundleId: jsonSerialization['bundleId'] as String,
      ascAppId: jsonSerialization['ascAppId'] as String?,
      sku: jsonSerialization['sku'] as String,
      appName: jsonSerialization['appName'] as String,
      status: jsonSerialization['status'] as String?,
      statusLog: jsonSerialization['statusLog'] as String?,
      testflightLink: jsonSerialization['testflightLink'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int wishId;

  /// The wish this store app was provisioned for.
  _ionsu37y.AppWish? wish;

  /// Full bundle id: <prefix>.<slug>. Unique across the team.
  String bundleId;

  /// App Store Connect app id, once the app record exists.
  String ascAppId;

  /// SKU used when creating the app record.
  String sku;

  /// Display name used when creating the app record.
  String appName;

  /// Provisioning status: pending, creating, ready, failed.
  String status;

  /// Append-only log of the provisioning steps.
  String statusLog;

  /// Public TestFlight invite link for this app (one per app, copied from
  /// App Store Connect by the owner; same for all its builds).
  String testflightLink;

  /// Returns a shallow copy of this [StoreApp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  StoreApp copyWith({
    int? id,
    int? wishId,
    _ionsu37y.AppWish? wish,
    String? bundleId,
    String? ascAppId,
    String? sku,
    String? appName,
    String? status,
    String? statusLog,
    String? testflightLink,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StoreApp',
      if (id != null) 'id': id,
      'wishId': wishId,
      if (wish != null) 'wish': wish?.toJson(),
      'bundleId': bundleId,
      'ascAppId': ascAppId,
      'sku': sku,
      'appName': appName,
      'status': status,
      'statusLog': statusLog,
      'testflightLink': testflightLink,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StoreApp',
      if (id != null) 'id': id,
      'wishId': wishId,
      if (wish != null) 'wish': wish?.toJsonForProtocol(),
      'bundleId': bundleId,
      'ascAppId': ascAppId,
      'sku': sku,
      'appName': appName,
      'status': status,
      'statusLog': statusLog,
      'testflightLink': testflightLink,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StoreAppImpl extends StoreApp {
  _StoreAppImpl({
    int? id,
    required int wishId,
    _ionsu37y.AppWish? wish,
    required String bundleId,
    String? ascAppId,
    required String sku,
    required String appName,
    String? status,
    String? statusLog,
    String? testflightLink,
  }) : super._(
         id: id,
         wishId: wishId,
         wish: wish,
         bundleId: bundleId,
         ascAppId: ascAppId,
         sku: sku,
         appName: appName,
         status: status,
         statusLog: statusLog,
         testflightLink: testflightLink,
       );

  /// Returns a shallow copy of this [StoreApp]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  StoreApp copyWith({
    Object? id = _Undefined,
    int? wishId,
    Object? wish = _Undefined,
    String? bundleId,
    String? ascAppId,
    String? sku,
    String? appName,
    String? status,
    String? statusLog,
    String? testflightLink,
  }) {
    return StoreApp(
      id: id is int? ? id : this.id,
      wishId: wishId ?? this.wishId,
      wish: wish is _ionsu37y.AppWish? ? wish : this.wish?.copyWith(),
      bundleId: bundleId ?? this.bundleId,
      ascAppId: ascAppId ?? this.ascAppId,
      sku: sku ?? this.sku,
      appName: appName ?? this.appName,
      status: status ?? this.status,
      statusLog: statusLog ?? this.statusLog,
      testflightLink: testflightLink ?? this.testflightLink,
    );
  }
}
