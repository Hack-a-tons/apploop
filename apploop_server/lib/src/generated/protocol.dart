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
import 'package:apploop_server/src/generated/builds/app_build.dart'
    as _ia2egj0z;
import 'package:apploop_server/src/generated/feedback/feedback_comment.dart'
    as _idqt9vg1;
import 'package:apploop_server/src/generated/feedback/feedback_recording.dart'
    as _ig60ukux;
import 'package:apploop_server/src/generated/wishes/wish.dart' as _it3mghal;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'builds/app_build.dart' as _i1cc7s5u;
import 'builds/build_task.dart' as _ihkq2rbu;
import 'builds/testflight_info.dart' as _ib1mtbgz;
import 'feedback/feedback_comment.dart' as _idgl1o2e;
import 'feedback/feedback_recording.dart' as _ig7ycgng;
import 'feedback/recording_task.dart' as _iif2nqze;
import 'future_calls_generated_models/provision_app_future_call_provision_app_model.dart'
    as _ipi9xzeo;
import 'greetings/greeting.dart' as _izw8z7ou;
import 'store/store_app.dart' as _i9g2qfab;
import 'wishes/wish.dart' as _ijn0eyds;
export 'builds/app_build.dart';
export 'builds/build_task.dart';
export 'builds/testflight_info.dart';
export 'feedback/feedback_comment.dart';
export 'feedback/feedback_recording.dart';
export 'feedback/recording_task.dart';
export 'greetings/greeting.dart';
export 'store/store_app.dart';
export 'wishes/wish.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'app_build',
      dartName: 'AppBuild',
      schema: 'public',
      module: 'apploop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'wishId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'storeAppId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'iteration',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'buildNumber',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'1.0\'',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'queued\'',
        ),
        _isp.ColumnDefinition(
          name: 'statusLog',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'testflightState',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'heartbeatAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'app_build_fk_0',
          columns: ['wishId'],
          referenceTable: 'app_wish',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'app_build_fk_1',
          columns: ['storeAppId'],
          referenceTable: 'store_app',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'app_build_wish_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'wishId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'app_wish',
      dartName: 'AppWish',
      schema: 'public',
      module: 'apploop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'descriptionText',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'draft\'',
        ),
        _isp.ColumnDefinition(
          name: 'currentIteration',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'app_wish_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'app_wish_owner_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'feedback_comment',
      dartName: 'FeedbackComment',
      schema: 'public',
      module: 'apploop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'recordingId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'text',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'audioPath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'screenshotPath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'severity',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'medium\'',
        ),
        _isp.ColumnDefinition(
          name: 'timestamps',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'keyboard\'',
        ),
        _isp.ColumnDefinition(
          name: 'resolved',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'feedback_comment_fk_0',
          columns: ['recordingId'],
          referenceTable: 'feedback_recording',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'feedback_comment_fk_1',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'feedback_comment_recording_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'recordingId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'feedback_recording',
      dartName: 'FeedbackRecording',
      schema: 'public',
      module: 'apploop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'buildId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'videoPath',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'transcript',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'issuesJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'[]\'',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'uploaded\'',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'feedback_recording_fk_0',
          columns: ['buildId'],
          referenceTable: 'app_build',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'feedback_recording_fk_1',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'feedback_recording_build_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'buildId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'store_app',
      dartName: 'StoreApp',
      schema: 'public',
      module: 'apploop',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'wishId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'bundleId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'ascAppId',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'sku',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'appName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'pending\'',
        ),
        _isp.ColumnDefinition(
          name: 'statusLog',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
        _isp.ColumnDefinition(
          name: 'testflightLink',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'\'',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'store_app_fk_0',
          columns: ['wishId'],
          referenceTable: 'app_wish',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'store_app__bundleId__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bundleId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'store_app_wish_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'wishId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._iacs.Protocol.targetTableDefinitions,
    ..._iais.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

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
      } on _is.DeserializationClassNameNotFoundException catch (_) {
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
    if (t == _iif2nqze.RecordingTask) {
      return _iif2nqze.RecordingTask.fromJson(data) as T;
    }
    if (t == _ipi9xzeo.ProvisionAppFutureCallProvisionAppModel) {
      return _ipi9xzeo.ProvisionAppFutureCallProvisionAppModel.fromJson(data)
          as T;
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
    if (t == _is.getType<_i1cc7s5u.AppBuild?>()) {
      return (data != null ? _i1cc7s5u.AppBuild.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihkq2rbu.BuildTask?>()) {
      return (data != null ? _ihkq2rbu.BuildTask.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ib1mtbgz.TestflightInfo?>()) {
      return (data != null ? _ib1mtbgz.TestflightInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_idgl1o2e.FeedbackComment?>()) {
      return (data != null ? _idgl1o2e.FeedbackComment.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ig7ycgng.FeedbackRecording?>()) {
      return (data != null ? _ig7ycgng.FeedbackRecording.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iif2nqze.RecordingTask?>()) {
      return (data != null ? _iif2nqze.RecordingTask.fromJson(data) : null)
          as T;
    }
    if (t ==
        _is.getType<_ipi9xzeo.ProvisionAppFutureCallProvisionAppModel?>()) {
      return (data != null
              ? _ipi9xzeo.ProvisionAppFutureCallProvisionAppModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izw8z7ou.Greeting?>()) {
      return (data != null ? _izw8z7ou.Greeting.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9g2qfab.StoreApp?>()) {
      return (data != null ? _i9g2qfab.StoreApp.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijn0eyds.AppWish?>()) {
      return (data != null ? _ijn0eyds.AppWish.fromJson(data) : null) as T;
    }
    if (t == List<_ia2egj0z.AppBuild>) {
      return (data as List)
              .map((e) => deserialize<_ia2egj0z.AppBuild>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ig60ukux.FeedbackRecording>) {
      return (data as List)
              .map((e) => deserialize<_ig60ukux.FeedbackRecording>(e))
              .toList()
          as T;
    }
    if (t == List<_idqt9vg1.FeedbackComment>) {
      return (data as List)
              .map((e) => deserialize<_idqt9vg1.FeedbackComment>(e))
              .toList()
          as T;
    }
    if (t == List<_it3mghal.AppWish>) {
      return (data as List)
              .map((e) => deserialize<_it3mghal.AppWish>(e))
              .toList()
          as T;
    }
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i1cc7s5u.AppBuild => 'AppBuild',
      _ihkq2rbu.BuildTask => 'BuildTask',
      _ib1mtbgz.TestflightInfo => 'TestflightInfo',
      _idgl1o2e.FeedbackComment => 'FeedbackComment',
      _ig7ycgng.FeedbackRecording => 'FeedbackRecording',
      _iif2nqze.RecordingTask => 'RecordingTask',
      _ipi9xzeo.ProvisionAppFutureCallProvisionAppModel =>
        'ProvisionAppFutureCallProvisionAppModel',
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
      case _iif2nqze.RecordingTask():
        return 'RecordingTask';
      case _ipi9xzeo.ProvisionAppFutureCallProvisionAppModel():
        return 'ProvisionAppFutureCallProvisionAppModel';
      case _izw8z7ou.Greeting():
        return 'Greeting';
      case _i9g2qfab.StoreApp():
        return 'StoreApp';
      case _ijn0eyds.AppWish():
        return 'AppWish';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
    if (dataClassName == 'RecordingTask') {
      return deserialize<_iif2nqze.RecordingTask>(data['data']);
    }
    if (dataClassName == 'ProvisionAppFutureCallProvisionAppModel') {
      return deserialize<_ipi9xzeo.ProvisionAppFutureCallProvisionAppModel>(
        data['data'],
      );
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
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacs.Protocol().registerHostProtocol('apploop', this);
    _iais.Protocol().registerHostProtocol('apploop', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i1cc7s5u.AppBuild:
        return _i1cc7s5u.AppBuild.t;
      case _idgl1o2e.FeedbackComment:
        return _idgl1o2e.FeedbackComment.t;
      case _ig7ycgng.FeedbackRecording:
        return _ig7ycgng.FeedbackRecording.t;
      case _i9g2qfab.StoreApp:
        return _i9g2qfab.StoreApp.t;
      case _ijn0eyds.AppWish:
        return _ijn0eyds.AppWish.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

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
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
