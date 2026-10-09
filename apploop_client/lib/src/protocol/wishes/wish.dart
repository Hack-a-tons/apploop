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

abstract class AppWish
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppWish._({
    this.id,
    required this.authUserId,
    this.authUser,
    required this.title,
    String? descriptionText,
    String? status,
    int? currentIteration,
  }) : descriptionText = descriptionText ?? '',
       status = status ?? 'draft',
       currentIteration = currentIteration ?? 0;

  factory AppWish({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String title,
    String? descriptionText,
    String? status,
    int? currentIteration,
  }) = _AppWishImpl;

  factory AppWish.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppWish(
      id: jsonSerialization['id'] as int?,
      authUserId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ib88ok8n.Protocol().deserialize<_iacc.AuthUser>(
              jsonSerialization['authUser'],
            ),
      title: jsonSerialization['title'] as String,
      descriptionText: jsonSerialization['descriptionText'] as String?,
      status: jsonSerialization['status'] as String?,
      currentIteration: jsonSerialization['currentIteration'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _isc.UuidValue authUserId;

  /// The authenticated user who owns this wish.
  _iacc.AuthUser? authUser;

  /// Short title of the wished app.
  String title;

  /// Free-text description of the wished app.
  String descriptionText;

  /// Lifecycle status: draft, provisioning, provisioned, building,
  /// testing, satisfied, exported.
  String status;

  /// Current loop iteration (bumped on every requested build).
  int currentIteration;

  /// Returns a shallow copy of this [AppWish]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppWish copyWith({
    int? id,
    _isc.UuidValue? authUserId,
    _iacc.AuthUser? authUser,
    String? title,
    String? descriptionText,
    String? status,
    int? currentIteration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppWish',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'title': title,
      'descriptionText': descriptionText,
      'status': status,
      'currentIteration': currentIteration,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppWish',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      if (authUser != null) 'authUser': authUser?.toJson(),
      'title': title,
      'descriptionText': descriptionText,
      'status': status,
      'currentIteration': currentIteration,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppWishImpl extends AppWish {
  _AppWishImpl({
    int? id,
    required _isc.UuidValue authUserId,
    _iacc.AuthUser? authUser,
    required String title,
    String? descriptionText,
    String? status,
    int? currentIteration,
  }) : super._(
         id: id,
         authUserId: authUserId,
         authUser: authUser,
         title: title,
         descriptionText: descriptionText,
         status: status,
         currentIteration: currentIteration,
       );

  /// Returns a shallow copy of this [AppWish]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppWish copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? authUserId,
    Object? authUser = _Undefined,
    String? title,
    String? descriptionText,
    String? status,
    int? currentIteration,
  }) {
    return AppWish(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      authUser: authUser is _iacc.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      title: title ?? this.title,
      descriptionText: descriptionText ?? this.descriptionText,
      status: status ?? this.status,
      currentIteration: currentIteration ?? this.currentIteration,
    );
  }
}
