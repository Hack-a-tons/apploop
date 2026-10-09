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
import '../store/store_app.dart' as _iri2eblp;
import '../wishes/wish.dart' as _ionsu37y;

abstract class AppBuild
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _ipso8wor.Protocol().deserialize<_ionsu37y.AppWish>(
              jsonSerialization['wish'],
            ),
      storeAppId: jsonSerialization['storeAppId'] as int,
      storeApp: jsonSerialization['storeApp'] == null
          ? null
          : _ipso8wor.Protocol().deserialize<_iri2eblp.StoreApp>(
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

  static final t = AppBuildTable();

  static const db = AppBuildRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [AppBuild]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static AppBuildInclude include({
    _ionsu37y.AppWishInclude? wish,
    _iri2eblp.StoreAppInclude? storeApp,
  }) {
    return AppBuildInclude._(
      wish: wish,
      storeApp: storeApp,
    );
  }

  static AppBuildIncludeList includeList({
    _is.WhereExpressionBuilder<AppBuildTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    AppBuildInclude? include,
  }) {
    return AppBuildIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class AppBuildUpdateTable extends _is.UpdateTable<AppBuildTable> {
  AppBuildUpdateTable(super.table);

  _is.ColumnValue<int, int> wishId(int value) => _is.ColumnValue(
    table.wishId,
    value,
  );

  _is.ColumnValue<int, int> storeAppId(int value) => _is.ColumnValue(
    table.storeAppId,
    value,
  );

  _is.ColumnValue<int, int> iteration(int value) => _is.ColumnValue(
    table.iteration,
    value,
  );

  _is.ColumnValue<int, int> buildNumber(int value) => _is.ColumnValue(
    table.buildNumber,
    value,
  );

  _is.ColumnValue<String, String> version(String value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<String, String> status(String value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<String, String> statusLog(String value) => _is.ColumnValue(
    table.statusLog,
    value,
  );

  _is.ColumnValue<String, String> testflightState(String value) =>
      _is.ColumnValue(
        table.testflightState,
        value,
      );
}

class AppBuildTable extends _is.Table<int?> {
  AppBuildTable({super.tableRelation}) : super(tableName: 'app_build') {
    updateTable = AppBuildUpdateTable(this);
    wishId = _is.ColumnInt(
      'wishId',
      this,
    );
    storeAppId = _is.ColumnInt(
      'storeAppId',
      this,
    );
    iteration = _is.ColumnInt(
      'iteration',
      this,
    );
    buildNumber = _is.ColumnInt(
      'buildNumber',
      this,
      hasDefault: true,
    );
    version = _is.ColumnString(
      'version',
      this,
      hasDefault: true,
    );
    status = _is.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    statusLog = _is.ColumnString(
      'statusLog',
      this,
      hasDefault: true,
    );
    testflightState = _is.ColumnString(
      'testflightState',
      this,
      hasDefault: true,
    );
  }

  late final AppBuildUpdateTable updateTable;

  late final _is.ColumnInt wishId;

  /// The wish this build belongs to.
  _ionsu37y.AppWishTable? _wish;

  late final _is.ColumnInt storeAppId;

  /// The store app this build is uploaded to.
  _iri2eblp.StoreAppTable? _storeApp;

  /// Loop iteration this build was produced for.
  late final _is.ColumnInt iteration;

  /// TestFlight build number (latest on TestFlight + 1).
  late final _is.ColumnInt buildNumber;

  /// Marketing version, e.g. 1.0.
  late final _is.ColumnString version;

  /// Pipeline status: queued, claimed, generating, building, uploading,
  /// processing, ready, failed.
  late final _is.ColumnString status;

  /// Append-only log of the build pipeline.
  late final _is.ColumnString statusLog;

  /// Mirror of Apple's external build state (e.g. ready, processing).
  late final _is.ColumnString testflightState;

  _ionsu37y.AppWishTable get wish {
    if (_wish != null) return _wish!;
    _wish = _is.createRelationTable(
      relationFieldName: 'wish',
      field: AppBuild.t.wishId,
      foreignField: _ionsu37y.AppWish.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ionsu37y.AppWishTable(tableRelation: foreignTableRelation),
    );
    return _wish!;
  }

  _iri2eblp.StoreAppTable get storeApp {
    if (_storeApp != null) return _storeApp!;
    _storeApp = _is.createRelationTable(
      relationFieldName: 'storeApp',
      field: AppBuild.t.storeAppId,
      foreignField: _iri2eblp.StoreApp.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iri2eblp.StoreAppTable(tableRelation: foreignTableRelation),
    );
    return _storeApp!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    wishId,
    storeAppId,
    iteration,
    buildNumber,
    version,
    status,
    statusLog,
    testflightState,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'wish') {
      return wish;
    }
    if (relationField == 'storeApp') {
      return storeApp;
    }
    return null;
  }
}

class AppBuildInclude extends _is.IncludeObject {
  AppBuildInclude._({
    _ionsu37y.AppWishInclude? wish,
    _iri2eblp.StoreAppInclude? storeApp,
  }) {
    _wish = wish;
    _storeApp = storeApp;
  }

  _ionsu37y.AppWishInclude? _wish;

  _iri2eblp.StoreAppInclude? _storeApp;

  @override
  Map<String, _is.Include?> get includes => {
    'wish': _wish,
    'storeApp': _storeApp,
  };

  @override
  _is.Table<int?> get table => AppBuild.t;
}

class AppBuildIncludeList extends _is.IncludeList {
  AppBuildIncludeList._({
    _is.WhereExpressionBuilder<AppBuildTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(AppBuild.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => AppBuild.t;
}

class AppBuildRepository {
  const AppBuildRepository._();

  final attachRow = const AppBuildAttachRowRepository._();

  /// Returns a list of [AppBuild]s matching the given query parameters.
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
  Future<List<AppBuild>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppBuildTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    _is.Transaction? transaction,
    AppBuildInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<AppBuild>(
      where: where?.call(AppBuild.t),
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [AppBuild] matching the given query parameters.
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
  Future<AppBuild?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppBuildTable>? where,
    int? offset,
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    _is.Transaction? transaction,
    AppBuildInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<AppBuild>(
      where: where?.call(AppBuild.t),
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [AppBuild] by its [id] or null if no such row exists.
  Future<AppBuild?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    AppBuildInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<AppBuild>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [AppBuild]s in the list and returns the inserted rows.
  ///
  /// The returned [AppBuild]s will have their `id` fields set.
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
  Future<List<AppBuild>> insert(
    _is.DatabaseSession session,
    List<AppBuild> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<AppBuild>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [AppBuild] and returns the inserted row.
  ///
  /// The returned [AppBuild] will have its `id` field set.
  Future<AppBuild> insertRow(
    _is.DatabaseSession session,
    AppBuild row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<AppBuild>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [AppBuild]s in the list and returns the resulting rows.
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
  /// The returned [AppBuild]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppBuild>> upsert(
    _is.DatabaseSession session,
    List<AppBuild> rows, {
    required _is.ColumnSelections<AppBuildTable> conflictColumns,
    _is.ColumnSelections<AppBuildTable>? updateColumns,
    _is.WhereExpressionBuilder<AppBuildTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<AppBuild>(
      rows,
      conflictColumns: conflictColumns(AppBuild.t),
      updateColumns: updateColumns?.call(AppBuild.t),
      updateWhere: updateWhere?.call(AppBuild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [AppBuild] and returns the resulting row.
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
  /// The returned [AppBuild] will have its `id` field set.
  Future<AppBuild?> upsertRow(
    _is.DatabaseSession session,
    AppBuild row, {
    required _is.ColumnSelections<AppBuildTable> conflictColumns,
    _is.ColumnSelections<AppBuildTable>? updateColumns,
    _is.WhereExpressionBuilder<AppBuildTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<AppBuild>(
      row,
      conflictColumns: conflictColumns(AppBuild.t),
      updateColumns: updateColumns?.call(AppBuild.t),
      updateWhere: updateWhere?.call(AppBuild.t),
      transaction: transaction,
    );
  }

  /// Updates all [AppBuild]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppBuild>> update(
    _is.DatabaseSession session,
    List<AppBuild> rows, {
    _is.ColumnSelections<AppBuildTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<AppBuild>(
      rows,
      columns: columns?.call(AppBuild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [AppBuild]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<AppBuild> updateRow(
    _is.DatabaseSession session,
    AppBuild row, {
    _is.ColumnSelections<AppBuildTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<AppBuild>(
      row,
      columns: columns?.call(AppBuild.t),
      transaction: transaction,
    );
  }

  /// Updates a single [AppBuild] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<AppBuild?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<AppBuildUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<AppBuild>(
      id,
      columnValues: columnValues(AppBuild.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [AppBuild]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<AppBuild>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<AppBuildUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<AppBuildTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<AppBuild>(
      columnValues: columnValues(AppBuild.t.updateTable),
      where: where(AppBuild.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [AppBuild]s in the list and returns the deleted rows.
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
  Future<List<AppBuild>> delete(
    _is.DatabaseSession session,
    List<AppBuild> rows, {
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<AppBuild>(
      rows,
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [AppBuild].
  Future<AppBuild> deleteRow(
    _is.DatabaseSession session,
    AppBuild row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<AppBuild>(
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
  Future<List<AppBuild>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppBuildTable> where,
    _is.OrderByBuilder<AppBuildTable>? orderBy,
    _is.OrderByListBuilder<AppBuildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<AppBuild>(
      where: where(AppBuild.t),
      orderBy: orderBy?.call(AppBuild.t),
      orderByList: orderByList?.call(AppBuild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<AppBuildTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<AppBuild>(
      where: where?.call(AppBuild.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [AppBuild] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<AppBuildTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<AppBuild>(
      where: where(AppBuild.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class AppBuildAttachRowRepository {
  const AppBuildAttachRowRepository._();

  /// Creates a relation between the given [AppBuild] and [AppWish]
  /// by setting the [AppBuild]'s foreign key `wishId` to refer to the [AppWish].
  Future<void> wish(
    _is.DatabaseSession session,
    AppBuild appBuild,
    _ionsu37y.AppWish wish, {
    _is.Transaction? transaction,
  }) async {
    if (appBuild.id == null) {
      throw ArgumentError.notNull('appBuild.id');
    }
    if (wish.id == null) {
      throw ArgumentError.notNull('wish.id');
    }

    var $appBuild = appBuild.copyWith(wishId: wish.id);
    await session.db.updateRow<AppBuild>(
      $appBuild,
      columns: [AppBuild.t.wishId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [AppBuild] and [StoreApp]
  /// by setting the [AppBuild]'s foreign key `storeAppId` to refer to the [StoreApp].
  Future<void> storeApp(
    _is.DatabaseSession session,
    AppBuild appBuild,
    _iri2eblp.StoreApp storeApp, {
    _is.Transaction? transaction,
  }) async {
    if (appBuild.id == null) {
      throw ArgumentError.notNull('appBuild.id');
    }
    if (storeApp.id == null) {
      throw ArgumentError.notNull('storeApp.id');
    }

    var $appBuild = appBuild.copyWith(storeAppId: storeApp.id);
    await session.db.updateRow<AppBuild>(
      $appBuild,
      columns: [AppBuild.t.storeAppId],
      transaction: transaction,
    );
  }
}
