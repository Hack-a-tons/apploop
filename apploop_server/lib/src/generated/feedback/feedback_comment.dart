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
import '../feedback/feedback_recording.dart' as _iema6dlf;

abstract class FeedbackComment
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
          : _ipso8wor.Protocol().deserialize<_iema6dlf.FeedbackRecording>(
              jsonSerialization['recording'],
            ),
      authUserId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      authUser: jsonSerialization['authUser'] == null
          ? null
          : _ipso8wor.Protocol().deserialize<_iacs.AuthUser>(
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
          : _is.BoolJsonExtension.fromJson(jsonSerialization['resolved']),
    );
  }

  static final t = FeedbackCommentTable();

  static const db = FeedbackCommentRepository._();

  @override
  int? id;

  int recordingId;

  /// The recording this comment belongs to.
  _iema6dlf.FeedbackRecording? recording;

  _is.UuidValue authUserId;

  /// The authenticated user who owns this comment.
  _iacs.AuthUser? authUser;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FeedbackComment]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FeedbackComment copyWith({
    int? id,
    int? recordingId,
    _iema6dlf.FeedbackRecording? recording,
    _is.UuidValue? authUserId,
    _iacs.AuthUser? authUser,
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

  static FeedbackCommentInclude include({
    _iema6dlf.FeedbackRecordingInclude? recording,
    _iacs.AuthUserInclude? authUser,
  }) {
    return FeedbackCommentInclude._(
      recording: recording,
      authUser: authUser,
    );
  }

  static FeedbackCommentIncludeList includeList({
    _is.WhereExpressionBuilder<FeedbackCommentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    FeedbackCommentInclude? include,
  }) {
    return FeedbackCommentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FeedbackCommentImpl extends FeedbackComment {
  _FeedbackCommentImpl({
    int? id,
    required int recordingId,
    _iema6dlf.FeedbackRecording? recording,
    required _is.UuidValue authUserId,
    _iacs.AuthUser? authUser,
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
  @_is.useResult
  @override
  FeedbackComment copyWith({
    Object? id = _Undefined,
    int? recordingId,
    Object? recording = _Undefined,
    _is.UuidValue? authUserId,
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
      authUser: authUser is _iacs.AuthUser?
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

class FeedbackCommentUpdateTable extends _is.UpdateTable<FeedbackCommentTable> {
  FeedbackCommentUpdateTable(super.table);

  _is.ColumnValue<int, int> recordingId(int value) => _is.ColumnValue(
    table.recordingId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> authUserId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.authUserId,
    value,
  );

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> text(String value) => _is.ColumnValue(
    table.text,
    value,
  );

  _is.ColumnValue<String, String> audioPath(String value) => _is.ColumnValue(
    table.audioPath,
    value,
  );

  _is.ColumnValue<String, String> screenshotPath(String value) =>
      _is.ColumnValue(
        table.screenshotPath,
        value,
      );

  _is.ColumnValue<String, String> severity(String value) => _is.ColumnValue(
    table.severity,
    value,
  );

  _is.ColumnValue<String, String> timestamps(String value) => _is.ColumnValue(
    table.timestamps,
    value,
  );

  _is.ColumnValue<String, String> origin(String value) => _is.ColumnValue(
    table.origin,
    value,
  );

  _is.ColumnValue<bool, bool> resolved(bool value) => _is.ColumnValue(
    table.resolved,
    value,
  );
}

class FeedbackCommentTable extends _is.Table<int?> {
  FeedbackCommentTable({super.tableRelation})
    : super(tableName: 'feedback_comment') {
    updateTable = FeedbackCommentUpdateTable(this);
    recordingId = _is.ColumnInt(
      'recordingId',
      this,
    );
    authUserId = _is.ColumnUuid(
      'authUserId',
      this,
    );
    title = _is.ColumnString(
      'title',
      this,
    );
    text = _is.ColumnString(
      'text',
      this,
      hasDefault: true,
    );
    audioPath = _is.ColumnString(
      'audioPath',
      this,
      hasDefault: true,
    );
    screenshotPath = _is.ColumnString(
      'screenshotPath',
      this,
      hasDefault: true,
    );
    severity = _is.ColumnString(
      'severity',
      this,
      hasDefault: true,
    );
    timestamps = _is.ColumnString(
      'timestamps',
      this,
      hasDefault: true,
    );
    origin = _is.ColumnString(
      'origin',
      this,
      hasDefault: true,
    );
    resolved = _is.ColumnBool(
      'resolved',
      this,
      hasDefault: true,
    );
  }

  late final FeedbackCommentUpdateTable updateTable;

  late final _is.ColumnInt recordingId;

  /// The recording this comment belongs to.
  _iema6dlf.FeedbackRecordingTable? _recording;

  late final _is.ColumnUuid authUserId;

  /// The authenticated user who owns this comment.
  _iacs.AuthUserTable? _authUser;

  /// Short summary of the issue.
  late final _is.ColumnString title;

  /// Editable comment text.
  late final _is.ColumnString text;

  /// Storage path of an attached audio note.
  late final _is.ColumnString audioPath;

  /// Storage path of an attached screenshot.
  late final _is.ColumnString screenshotPath;

  /// high, medium or low.
  late final _is.ColumnString severity;

  /// Timestamps in the recording this comment refers to.
  late final _is.ColumnString timestamps;

  /// How the comment was created: voice, keyboard or extracted.
  late final _is.ColumnString origin;

  /// Whether the issue is resolved.
  late final _is.ColumnBool resolved;

  _iema6dlf.FeedbackRecordingTable get recording {
    if (_recording != null) return _recording!;
    _recording = _is.createRelationTable(
      relationFieldName: 'recording',
      field: FeedbackComment.t.recordingId,
      foreignField: _iema6dlf.FeedbackRecording.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iema6dlf.FeedbackRecordingTable(tableRelation: foreignTableRelation),
    );
    return _recording!;
  }

  _iacs.AuthUserTable get authUser {
    if (_authUser != null) return _authUser!;
    _authUser = _is.createRelationTable(
      relationFieldName: 'authUser',
      field: FeedbackComment.t.authUserId,
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
    recordingId,
    authUserId,
    title,
    text,
    audioPath,
    screenshotPath,
    severity,
    timestamps,
    origin,
    resolved,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'recording') {
      return recording;
    }
    if (relationField == 'authUser') {
      return authUser;
    }
    return null;
  }
}

class FeedbackCommentInclude extends _is.IncludeObject {
  FeedbackCommentInclude._({
    _iema6dlf.FeedbackRecordingInclude? recording,
    _iacs.AuthUserInclude? authUser,
  }) {
    _recording = recording;
    _authUser = authUser;
  }

  _iema6dlf.FeedbackRecordingInclude? _recording;

  _iacs.AuthUserInclude? _authUser;

  @override
  Map<String, _is.Include?> get includes => {
    'recording': _recording,
    'authUser': _authUser,
  };

  @override
  _is.Table<int?> get table => FeedbackComment.t;
}

class FeedbackCommentIncludeList extends _is.IncludeList {
  FeedbackCommentIncludeList._({
    _is.WhereExpressionBuilder<FeedbackCommentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FeedbackComment.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FeedbackComment.t;
}

class FeedbackCommentRepository {
  const FeedbackCommentRepository._();

  final attachRow = const FeedbackCommentAttachRowRepository._();

  /// Returns a list of [FeedbackComment]s matching the given query parameters.
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
  Future<List<FeedbackComment>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackCommentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    _is.Transaction? transaction,
    FeedbackCommentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FeedbackComment>(
      where: where?.call(FeedbackComment.t),
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FeedbackComment] matching the given query parameters.
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
  Future<FeedbackComment?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackCommentTable>? where,
    int? offset,
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    _is.Transaction? transaction,
    FeedbackCommentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FeedbackComment>(
      where: where?.call(FeedbackComment.t),
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FeedbackComment] by its [id] or null if no such row exists.
  Future<FeedbackComment?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FeedbackCommentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FeedbackComment>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FeedbackComment]s in the list and returns the inserted rows.
  ///
  /// The returned [FeedbackComment]s will have their `id` fields set.
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
  Future<List<FeedbackComment>> insert(
    _is.DatabaseSession session,
    List<FeedbackComment> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FeedbackComment>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FeedbackComment] and returns the inserted row.
  ///
  /// The returned [FeedbackComment] will have its `id` field set.
  Future<FeedbackComment> insertRow(
    _is.DatabaseSession session,
    FeedbackComment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FeedbackComment>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FeedbackComment]s in the list and returns the resulting rows.
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
  /// The returned [FeedbackComment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackComment>> upsert(
    _is.DatabaseSession session,
    List<FeedbackComment> rows, {
    required _is.ColumnSelections<FeedbackCommentTable> conflictColumns,
    _is.ColumnSelections<FeedbackCommentTable>? updateColumns,
    _is.WhereExpressionBuilder<FeedbackCommentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FeedbackComment>(
      rows,
      conflictColumns: conflictColumns(FeedbackComment.t),
      updateColumns: updateColumns?.call(FeedbackComment.t),
      updateWhere: updateWhere?.call(FeedbackComment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FeedbackComment] and returns the resulting row.
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
  /// The returned [FeedbackComment] will have its `id` field set.
  Future<FeedbackComment?> upsertRow(
    _is.DatabaseSession session,
    FeedbackComment row, {
    required _is.ColumnSelections<FeedbackCommentTable> conflictColumns,
    _is.ColumnSelections<FeedbackCommentTable>? updateColumns,
    _is.WhereExpressionBuilder<FeedbackCommentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FeedbackComment>(
      row,
      conflictColumns: conflictColumns(FeedbackComment.t),
      updateColumns: updateColumns?.call(FeedbackComment.t),
      updateWhere: updateWhere?.call(FeedbackComment.t),
      transaction: transaction,
    );
  }

  /// Updates all [FeedbackComment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackComment>> update(
    _is.DatabaseSession session,
    List<FeedbackComment> rows, {
    _is.ColumnSelections<FeedbackCommentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FeedbackComment>(
      rows,
      columns: columns?.call(FeedbackComment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FeedbackComment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FeedbackComment> updateRow(
    _is.DatabaseSession session,
    FeedbackComment row, {
    _is.ColumnSelections<FeedbackCommentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FeedbackComment>(
      row,
      columns: columns?.call(FeedbackComment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FeedbackComment] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FeedbackComment?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FeedbackCommentUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FeedbackComment>(
      id,
      columnValues: columnValues(FeedbackComment.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FeedbackComment]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FeedbackComment>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FeedbackCommentUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FeedbackCommentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FeedbackComment>(
      columnValues: columnValues(FeedbackComment.t.updateTable),
      where: where(FeedbackComment.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FeedbackComment]s in the list and returns the deleted rows.
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
  Future<List<FeedbackComment>> delete(
    _is.DatabaseSession session,
    List<FeedbackComment> rows, {
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FeedbackComment>(
      rows,
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FeedbackComment].
  Future<FeedbackComment> deleteRow(
    _is.DatabaseSession session,
    FeedbackComment row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FeedbackComment>(
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
  Future<List<FeedbackComment>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FeedbackCommentTable> where,
    _is.OrderByBuilder<FeedbackCommentTable>? orderBy,
    _is.OrderByListBuilder<FeedbackCommentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FeedbackComment>(
      where: where(FeedbackComment.t),
      orderBy: orderBy?.call(FeedbackComment.t),
      orderByList: orderByList?.call(FeedbackComment.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FeedbackCommentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FeedbackComment>(
      where: where?.call(FeedbackComment.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FeedbackComment] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FeedbackCommentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FeedbackComment>(
      where: where(FeedbackComment.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FeedbackCommentAttachRowRepository {
  const FeedbackCommentAttachRowRepository._();

  /// Creates a relation between the given [FeedbackComment] and [FeedbackRecording]
  /// by setting the [FeedbackComment]'s foreign key `recordingId` to refer to the [FeedbackRecording].
  Future<void> recording(
    _is.DatabaseSession session,
    FeedbackComment feedbackComment,
    _iema6dlf.FeedbackRecording recording, {
    _is.Transaction? transaction,
  }) async {
    if (feedbackComment.id == null) {
      throw ArgumentError.notNull('feedbackComment.id');
    }
    if (recording.id == null) {
      throw ArgumentError.notNull('recording.id');
    }

    var $feedbackComment = feedbackComment.copyWith(recordingId: recording.id);
    await session.db.updateRow<FeedbackComment>(
      $feedbackComment,
      columns: [FeedbackComment.t.recordingId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [FeedbackComment] and [AuthUser]
  /// by setting the [FeedbackComment]'s foreign key `authUserId` to refer to the [AuthUser].
  Future<void> authUser(
    _is.DatabaseSession session,
    FeedbackComment feedbackComment,
    _iacs.AuthUser authUser, {
    _is.Transaction? transaction,
  }) async {
    if (feedbackComment.id == null) {
      throw ArgumentError.notNull('feedbackComment.id');
    }
    if (authUser.id == null) {
      throw ArgumentError.notNull('authUser.id');
    }

    var $feedbackComment = feedbackComment.copyWith(authUserId: authUser.id);
    await session.db.updateRow<FeedbackComment>(
      $feedbackComment,
      columns: [FeedbackComment.t.authUserId],
      transaction: transaction,
    );
  }
}
