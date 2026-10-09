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
import '../builds/app_build.dart' as _inhfbybr;

abstract class BuildTask
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BuildTask._({
    required this.build,
    required this.wishTitle,
    required this.wishDescription,
    required this.bundleId,
    required this.organization,
  });

  factory BuildTask({
    required _inhfbybr.AppBuild build,
    required String wishTitle,
    required String wishDescription,
    required String bundleId,
    required String organization,
  }) = _BuildTaskImpl;

  factory BuildTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return BuildTask(
      build: _ipso8wor.Protocol().deserialize<_inhfbybr.AppBuild>(
        jsonSerialization['build'],
      ),
      wishTitle: jsonSerialization['wishTitle'] as String,
      wishDescription: jsonSerialization['wishDescription'] as String,
      bundleId: jsonSerialization['bundleId'] as String,
      organization: jsonSerialization['organization'] as String,
    );
  }

  /// The build to produce.
  _inhfbybr.AppBuild build;

  /// Wish title (app name source).
  String wishTitle;

  /// Wish description (generation source).
  String wishDescription;

  /// Exact bundle id registered in App Store Connect.
  String bundleId;

  /// Bundle id prefix (organization), e.g. com.hurated.loop.
  String organization;

  /// Returns a shallow copy of this [BuildTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BuildTask copyWith({
    _inhfbybr.AppBuild? build,
    String? wishTitle,
    String? wishDescription,
    String? bundleId,
    String? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BuildTask',
      'build': build.toJson(),
      'wishTitle': wishTitle,
      'wishDescription': wishDescription,
      'bundleId': bundleId,
      'organization': organization,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BuildTask',
      'build': build.toJsonForProtocol(),
      'wishTitle': wishTitle,
      'wishDescription': wishDescription,
      'bundleId': bundleId,
      'organization': organization,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _BuildTaskImpl extends BuildTask {
  _BuildTaskImpl({
    required _inhfbybr.AppBuild build,
    required String wishTitle,
    required String wishDescription,
    required String bundleId,
    required String organization,
  }) : super._(
         build: build,
         wishTitle: wishTitle,
         wishDescription: wishDescription,
         bundleId: bundleId,
         organization: organization,
       );

  /// Returns a shallow copy of this [BuildTask]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BuildTask copyWith({
    _inhfbybr.AppBuild? build,
    String? wishTitle,
    String? wishDescription,
    String? bundleId,
    String? organization,
  }) {
    return BuildTask(
      build: build ?? this.build.copyWith(),
      wishTitle: wishTitle ?? this.wishTitle,
      wishDescription: wishDescription ?? this.wishDescription,
      bundleId: bundleId ?? this.bundleId,
      organization: organization ?? this.organization,
    );
  }
}
