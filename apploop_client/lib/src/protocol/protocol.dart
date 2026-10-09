/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:apploop_client/src/protocol/builds/app_build.dart' as _i6akcqfa;
import 'package:apploop_client/src/protocol/wishes/wish.dart' as _isssl1tb;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'builds/app_build.dart' as _i1cc7s5u;
import 'builds/build_task.dart' as _ihkq2rbu;
import 'builds/testflight_info.dart' as _ib1mtbgz;
import 'feedback/feedback_comment.dart' as _idgl1o2e;
import 'feedback/feedback_recording.dart' as _ig7ycgng;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'store/store_app.dart' as _i9g2qfab;
import 'wishes/wish.dart' as _ijn0eyds;
export 'builds/app_build.dart';
export 'builds/build_task.dart';
export 'builds/testflight_info.dart';
export 'feedback/feedback_comment.dart';
export 'feedback/feedback_recording.dart';
export 'greetings/greeting.dart';
export 'store/store_app.dart';
export 'wishes/wish.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i1cc7s5u.AppBuild) {
      return _i1cc7s5u.AppBuild.fromJson(data) as T;
    }
    if (t == _ihkq2rbu.BuildTask) {
      return _ihkq2rbu.BuildTask.fromJson(data) as T;
    }
    if (t == _ib1mtbgz.TestflightInfo) {
      return _ib1mtbgz.TestflightInfo.fromJson(data) as T;
    }
    if (t == _idgl1o2e.FeedbackComment) {
      return _idgl1o2e.FeedbackComment.fromJson(data) as T;
    }
    if (t == _ig7ycgng.FeedbackRecording) {
      return _ig7ycgng.FeedbackRecording.fromJson(data) as T;
    }
    if (t == _izw8z7ou.Greeting) {
      return _izw8z7ou.Greeting.fromJson(data) as T;
    }
    if (t == _i9g2qfab.StoreApp) {
      return _i9g2qfab.StoreApp.fromJson(data) as T;
    }
    if (t == _ijn0eyds.AppWish) {
      return _ijn0eyds.AppWish.fromJson(data) as T;
    }
    if (t == _isc.getType<_i1cc7s5u.AppBuild?>()) {
      return (data != null ? _i1cc7s5u.AppBuild.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihkq2rbu.BuildTask?>()) {
      return (data != null ? _ihkq2rbu.BuildTask.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib1mtbgz.TestflightInfo?>()) {
      return (data != null ? _ib1mtbgz.TestflightInfo.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_idgl1o2e.FeedbackComment?>()) {
      return (data != null ? _idgl1o2e.FeedbackComment.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ig7ycgng.FeedbackRecording?>()) {
      return (data != null ? _ig7ycgng.FeedbackRecording.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9g2qfab.StoreApp?>()) {
      return (data != null ? _i9g2qfab.StoreApp.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijn0eyds.AppWish?>()) {
      return (data != null ? _ijn0eyds.AppWish.fromJson(data) : null) as T;
    }
    if (t == List<_i6akcqfa.AppBuild>) {
      return (data as List)
              .map((e) => deserialize<_i6akcqfa.AppBuild>(e))
              .toList()
          as T;
    }
    if (t == List<_isssl1tb.AppWish>) {
      return (data as List)
              .map((e) => deserialize<_isssl1tb.AppWish>(e))
              .toList()
          as T;
    }
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i1cc7s5u.AppBuild => 'AppBuild',
      _ihkq2rbu.BuildTask => 'BuildTask',
      _ib1mtbgz.TestflightInfo => 'TestflightInfo',
      _idgl1o2e.FeedbackComment => 'FeedbackComment',
      _ig7ycgng.FeedbackRecording => 'FeedbackRecording',
      _izw8z7ou.Greeting => 'Greeting',
      _i9g2qfab.StoreApp => 'StoreApp',
      _ijn0eyds.AppWish => 'AppWish',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('apploop.', '');
    }

    switch (data) {
      case _i1cc7s5u.AppBuild():
        return 'AppBuild';
      case _ihkq2rbu.BuildTask():
        return 'BuildTask';
      case _ib1mtbgz.TestflightInfo():
        return 'TestflightInfo';
      case _idgl1o2e.FeedbackComment():
        return 'FeedbackComment';
      case _ig7ycgng.FeedbackRecording():
        return 'FeedbackRecording';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i9g2qfab.StoreApp():
        return 'StoreApp';
      case _ijn0eyds.AppWish():
        return 'AppWish';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppBuild') {
      return deserialize<_i1cc7s5u.AppBuild>(data['data']);
    }
    if (dataClassName == 'BuildTask') {
      return deserialize<_ihkq2rbu.BuildTask>(data['data']);
    }
    if (dataClassName == 'TestflightInfo') {
      return deserialize<_ib1mtbgz.TestflightInfo>(data['data']);
    }
    if (dataClassName == 'FeedbackComment') {
      return deserialize<_idgl1o2e.FeedbackComment>(data['data']);
    }
    if (dataClassName == 'FeedbackRecording') {
      return deserialize<_ig7ycgng.FeedbackRecording>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_izw8z7ou.Greeting>(data['data']);
    }
    if (dataClassName == 'StoreApp') {
      return deserialize<_i9g2qfab.StoreApp>(data['data']);
    }
    if (dataClassName == 'AppWish') {
      return deserialize<_ijn0eyds.AppWish>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacc.Protocol().registerHostProtocol('apploop', this);
    _iaic.Protocol().registerHostProtocol('apploop', this);
  }

  @override
  String getModuleName() => 'apploop';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
