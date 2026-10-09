/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:apploop_server/src/generated/protocol.dart' as _ipso8wor;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import '../builds/app_build.dart' as _inhfbybr;

abstract class FeedbackRecording
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
          : _ipso8wor.Protocol().deserialize<_inhfbybr.AppBuild>(
              jsonSerialization['build'],
            ),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ipso8wor.Protocol().deserialize<_iacs.AuthUser>(
              jsonSerialization['authUser'],
            ),
      videoPath: jsonSerialization['videoPath'] as String?,
      transcript: jsonSerialization['transcript'] as String?,
      issuesJson: jsonSerialization['issuesJson'] as String?,
      status: jsonSerialization['status'] as String?,
    );
  }

  static final t = FeedbackRecordingTable();

  static const db = FeedbackRecordingRepository._();

  @override
  int? id;

  int buildId;

  /// The build that was tested in this recording.
  _inhfbybr.AppBuild? build;

  _is.UuidValue authUserId;

  /// The authenticated user who recorded and owns this recording.
  _iacs.AuthUser? authUser;

  /// Storage path of the uploaded video file.
  String videoPath;

  /// Verbatim transcript of the spoken comments.
  String transcript;

  /// Extracted issues as JSON list
  /// [{title, severity, timestamps, quote, fix}].
  String issuesJson;

  /// Processing status: uploaded, processing, ready, failed.
  String status;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FeedbackRecording]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FeedbackRecording copyWith({
    int? id,
    int? buildId,
    _inhfbybr.AppBuild? build,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
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

  static FeedbackRecordingInclude include({
    _inhfbybr.AppBuildInclude? build,
    _iacs.AuthUserInclude? authUser,
  }) {
    return FeedbackRecordingInclude._(
      build: build,
      authUser: authUser,
    );
  }

  static FeedbackRecordingIncludeList includeList({
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    FeedbackRecordingInclude? include,
  }) {
    return FeedbackRecordingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackRecordingImpl extends FeedbackRecording {
  _FeedbackRecordingImpl({
    int? id,
    required int buildId,
    _inhfbybr.AppBuild? build,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
  @_is.useResult
  @override
  FeedbackRecording copyWith({
    Object? id = _Undefined,
    int? buildId,
    Object? build = _Undefined,
    _is.UuidValue? authUserId,
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
      authUser: authUser is _iacs.AuthUser?
          ? authUser
          : this.authUser?.copyWith(),
      videoPath: videoPath ?? this.videoPath,
      transcript: transcript ?? this.transcript,
      issuesJson: issuesJson ?? this.issuesJson,
      status: status ?? this.status,
    );
  }
}

class FeedbackRecordingUpdateTable
    extends _is.UpdateTable<FeedbackRecordingTable> {
  FeedbackRecordingUpdateTable(super.table);

  _is.ColumnValue<int, int> buildId(int value) => _is.ColumnValue(
    table.buildId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> videoPath(String value) => _is.ColumnValue(
    table.videoPath,
    value,
  );

  _is.ColumnValue<String, String> transcript(String value) => _is.ColumnValue(
    table.transcript,
    value,
  );

  _is.ColumnValue<String, String> issuesJson(String value) => _is.ColumnValue(
    table.issuesJson,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );
}

class FeedbackRecordingTable extends _is.Table<int?> {
  FeedbackRecordingTable({super.tableRelation})
    : super(tableName: 'feedback_recording') {
    updateTable = FeedbackRecordingUpdateTable(this);
    buildId = _is.ColumnInt(
      'buildId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    videoPath = _is.ColumnString(
      'videoPath',
      this,
      hasDefault: true,
    );
    transcript = _is.ColumnString(
      'transcript',
      this,
      hasDefault: true,
    );
    issuesJson = _is.ColumnString(
      'issuesJson',
      this,
      hasDefault: true,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
  }

  late final FeedbackRecordingUpdateTable updateTable;

  late final _is.ColumnInt buildId;

  /// The build that was tested in this recording.
  _inhfbybr.AppBuildTable? _build;

  late final _is.ColumnUuid authUserId;

  /// The authenticated user who recorded and owns this recording.
  _iacs.AuthUserTable? _authUser;

  /// Storage path of the uploaded video file.
  late final _is.ColumnString videoPath;

  /// Verbatim transcript of the spoken comments.
  late final _is.ColumnString transcript;

  /// Extracted issues as JSON list
  /// [{title, severity, timestamps, quote, fix}].
  late final _is.ColumnString issuesJson;

  /// Processing status: uploaded, processing, ready, failed.
  late final _is.ColumnString status;

  _inhfbybr.AppBuildTable get build {
    if (_build != null) return _build!;
    _build = _is.createRelationTable(
      relationFieldName: 'build',
      field: FeedbackRecording.t.buildId,
      foreignField: _inhfbybr.AppBuild.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inhfbybr.AppBuildTable(tableRelation: foreignTableRelation),
    );
    return _build!;
  }

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: FeedbackRecording.t.authUserId,
      foreignField: _iacs.AuthUser.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iacs.AuthUserTable(tableRelation: foreignTableRelation),
    );
    return _authUser!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    buildId,
    authUserId,
    videoPath,
    transcript,
    issuesJson,
    status,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'build') {
      return build;
    }
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class FeedbackRecordingInclude extends _is.IncludeObject {
  FeedbackRecordingInclude._({
    _inhfbybr.AppBuildInclude? build,
    _iacs.AuthUserInclude? authUser,
  }) {
    _build = build;
    _authUser = authUser;
  }

  _inhfbybr.AppBuildInclude? _build;

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {
    'build': _build,
    'authUser': _authUser,
  };

  @override
  _is.Table<int?> get table => FeedbackRecording.t;
}

class FeedbackRecordingIncludeList extends _is.IncludeList {
  FeedbackRecordingIncludeList._({
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FeedbackRecording.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FeedbackRecording.t;
}

class FeedbackRecordingRepository {
  const FeedbackRecordingRepository._();

  final attachRow = const FeedbackRecordingAttachRowRepository._();

  /// Returns a list of [FeedbackRecording]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<FeedbackRecording>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    _is.Transaction? transaction,
    FeedbackRecordingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FeedbackRecording>(
      where: where?.call(FeedbackRecording.t),
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FeedbackRecording] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<FeedbackRecording?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? where,
    int? offset,
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    _is.Transaction? transaction,
    FeedbackRecordingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FeedbackRecording>(
      where: where?.call(FeedbackRecording.t),
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FeedbackRecording] by its [id] or null if no such row exists.
  Future<FeedbackRecording?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FeedbackRecordingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FeedbackRecording>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FeedbackRecording]s in the list and returns the inserted rows.
  ///
  /// The returned [FeedbackRecording]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> insert(
    _is.DatabaseSession session,
    List<FeedbackRecording> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FeedbackRecording>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FeedbackRecording] and returns the inserted row.
  ///
  /// The returned [FeedbackRecording] will have its `id` field set.
  Future<FeedbackRecording> insertRow(
    _is.DatabaseSession session,
    FeedbackRecording row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FeedbackRecording>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FeedbackRecording]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [FeedbackRecording]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> upsert(
    _is.DatabaseSession session,
    List<FeedbackRecording> rows, {
    required _is.ColumnSelections<FeedbackRecordingTable> conflictColumns,
    _is.ColumnSelections<FeedbackRecordingTable>? updateColumns,
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FeedbackRecording>(
      rows,
      conflictColumns: conflictColumns(FeedbackRecording.t),
      updateColumns: updateColumns?.call(FeedbackRecording.t),
      updateWhere: updateWhere?.call(FeedbackRecording.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FeedbackRecording] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [FeedbackRecording] will have its `id` field set.
  Future<FeedbackRecording?> upsertRow(
    _is.DatabaseSession session,
    FeedbackRecording row, {
    required _is.ColumnSelections<FeedbackRecordingTable> conflictColumns,
    _is.ColumnSelections<FeedbackRecordingTable>? updateColumns,
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FeedbackRecording>(
      row,
      conflictColumns: conflictColumns(FeedbackRecording.t),
      updateColumns: updateColumns?.call(FeedbackRecording.t),
      updateWhere: updateWhere?.call(FeedbackRecording.t),
      transaction: transaction,
    );
  }

  /// Updates all [FeedbackRecording]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> update(
    _is.DatabaseSession session,
    List<FeedbackRecording> rows, {
    _is.ColumnSelections<FeedbackRecordingTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FeedbackRecording>(
      rows,
      columns: columns?.call(FeedbackRecording.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FeedbackRecording]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FeedbackRecording> updateRow(
    _is.DatabaseSession session,
    FeedbackRecording row, {
    _is.ColumnSelections<FeedbackRecordingTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FeedbackRecording>(
      row,
      columns: columns?.call(FeedbackRecording.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FeedbackRecording] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FeedbackRecording?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FeedbackRecordingUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FeedbackRecording>(
      id,
      columnValues: columnValues(FeedbackRecording.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FeedbackRecording]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FeedbackRecordingUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FeedbackRecordingTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FeedbackRecording>(
      columnValues: columnValues(FeedbackRecording.t.updateTable),
      where: where(FeedbackRecording.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FeedbackRecording]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> delete(
    _is.DatabaseSession session,
    List<FeedbackRecording> rows, {
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FeedbackRecording>(
      rows,
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FeedbackRecording].
  Future<FeedbackRecording> deleteRow(
    _is.DatabaseSession session,
    FeedbackRecording row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FeedbackRecording>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackRecording>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FeedbackRecordingTable> where,
    _is.OrderByBuilder<FeedbackRecordingTable>? orderBy,
    _is.OrderByListBuilder<FeedbackRecordingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FeedbackRecording>(
      where: where(FeedbackRecording.t),
      orderBy: orderBy?.call(FeedbackRecording.t),
      orderByList: orderByList?.call(FeedbackRecording.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackRecordingTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FeedbackRecording>(
      where: where?.call(FeedbackRecording.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FeedbackRecording] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FeedbackRecordingTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FeedbackRecording>(
      where: where(FeedbackRecording.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FeedbackRecordingAttachRowRepository {
  const FeedbackRecordingAttachRowRepository._();

  /// Creates a relation between the given [FeedbackRecording] and [AppBuild]
  /// by setting the [FeedbackRecording]'s foreign key `buildId` to refer to the [AppBuild].
  Future<void> build(
    _is.DatabaseSession session,
    FeedbackRecording feedbackRecording,
    _inhfbybr.AppBuild build, {
    _is.Transaction? transaction,
  }) async {
    if (feedbackRecording.id == null) {
      throw ArgumentError.notNull('feedbackRecording.id');
    }
    if (build.id == null) {
      throw ArgumentError.notNull('build.id');
    }

    var $feedbackRecording = feedbackRecording.copyWith(buildId: build.id);
    await session.db.updateRow<FeedbackRecording>(
      $feedbackRecording,
      columns: [FeedbackRecording.t.buildId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [FeedbackRecording] and [AuthUser]
  /// by setting the [FeedbackRecording]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    FeedbackRecording feedbackRecording,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (feedbackRecording.id == null) {
      throw ArgumentError.notNull('feedbackRecording.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $feedbackRecording = feedbackRecording.copyWith(
      authUserId: authUser.id,
    );
    await session.db.updateRow<FeedbackRecording>(
      $feedbackRecording,
      columns: [FeedbackRecording.t.authUserId],
      transaction: transaction,
    );
  }
}
