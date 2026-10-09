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
import '../wishes/wish.dart' as _ionsu37y;

abstract class StoreApp
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _ipso8wor.Protocol().deserialize<_ionsu37y.AppWish>(
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

  static final t = StoreAppTable();

  static const db = StoreAppRepository._();

  @override
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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StoreApp]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static StoreAppInclude include({_ionsu37y.AppWishInclude? wish}) {
    return StoreAppInclude._(wish: wish);
  }

  static StoreAppIncludeList includeList({
    _is.WhereExpressionBuilder<StoreAppTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    StoreAppInclude? include,
  }) {
    return StoreAppIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class StoreAppUpdateTable extends _is.UpdateTable<StoreAppTable> {
  StoreAppUpdateTable(super.table);

  _is.ColumnValue<int, int> wishId(int value) => _is.ColumnValue(
    table.wishId,
    value,
  );

  _is.ColumnValue<String, String> bundleId(String value) => _is.ColumnValue(
    table.bundleId,
    value,
  );

  _is.ColumnValue<String, String> ascAppId(String value) => _is.ColumnValue(
    table.ascAppId,
    value,
  );

  _is.ColumnValue<String, String> sku(String value) => _is.ColumnValue(
    table.sku,
    value,
  );

  _is.ColumnValue<String, String> appName(String value) => _is.ColumnValue(
    table.appName,
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

  _is.ColumnValue<String, String> testflightLink(String value) =>
      _is.ColumnValue(
        table.testflightLink,
        value,
      );
}

class StoreAppTable extends _is.Table<int?> {
  StoreAppTable({super.tableRelation}) : super(tableName: 'store_app') {
    updateTable = StoreAppUpdateTable(this);
    wishId = _is.ColumnInt(
      'wishId',
      this,
    );
    bundleId = _is.ColumnString(
      'bundleId',
      this,
    );
    ascAppId = _is.ColumnString(
      'ascAppId',
      this,
      hasDefault: true,
    );
    sku = _is.ColumnString(
      'sku',
      this,
    );
    appName = _is.ColumnString(
      'appName',
      this,
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
    testflightLink = _is.ColumnString(
      'testflightLink',
      this,
      hasDefault: true,
    );
  }

  late final StoreAppUpdateTable updateTable;

  late final _is.ColumnInt wishId;

  /// The wish this store app was provisioned for.
  _ionsu37y.AppWishTable? _wish;

  /// Full bundle id: <prefix>.<slug>. Unique across the team.
  late final _is.ColumnString bundleId;

  /// App Store Connect app id, once the app record exists.
  late final _is.ColumnString ascAppId;

  /// SKU used when creating the app record.
  late final _is.ColumnString sku;

  /// Display name used when creating the app record.
  late final _is.ColumnString appName;

  /// Provisioning status: pending, creating, ready, failed.
  late final _is.ColumnString status;

  /// Append-only log of the provisioning steps.
  late final _is.ColumnString statusLog;

  /// Public TestFlight invite link for this app (one per app, copied from
  /// App Store Connect by the owner; same for all its builds).
  late final _is.ColumnString testflightLink;

  _ionsu37y.AppWishTable get wish {
    if (_wish != null) return _wish!;
    _wish = _is.createRelationTable(
      relationFieldName: 'wish',
      field: StoreApp.t.wishId,
      foreignField: _ionsu37y.AppWish.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ionsu37y.AppWishTable(tableRelation: foreignTableRelation),
    );
    return _wish!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    wishId,
    bundleId,
    ascAppId,
    sku,
    appName,
    status,
    statusLog,
    testflightLink,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'wish') {
      return wish;
    }
    return null;
  }
}

class StoreAppInclude extends _is.IncludeObject {
  StoreAppInclude._({_ionsu37y.AppWishInclude? wish}) {
    _wish = wish;
  }

  _ionsu37y.AppWishInclude? _wish;

  @override
  Map<String, _is.Include?> get includes => {'wish': _wish};

  @override
  _is.Table<int?> get table => StoreApp.t;
}

class StoreAppIncludeList extends _is.IncludeList {
  StoreAppIncludeList._({
    _is.WhereExpressionBuilder<StoreAppTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(StoreApp.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StoreApp.t;
}

class StoreAppRepository {
  const StoreAppRepository._();

  final attachRow = const StoreAppAttachRowRepository._();

  /// Returns a list of [StoreApp]s matching the given query parameters.
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
  Future<List<StoreApp>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoreAppTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    _is.Transaction? transaction,
    StoreAppInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StoreApp>(
      where: where?.call(StoreApp.t),
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StoreApp] matching the given query parameters.
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
  Future<StoreApp?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoreAppTable>? where,
    int? offset,
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    _is.Transaction? transaction,
    StoreAppInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StoreApp>(
      where: where?.call(StoreApp.t),
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StoreApp] by its [id] or null if no such row exists.
  Future<StoreApp?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    StoreAppInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StoreApp>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StoreApp]s in the list and returns the inserted rows.
  ///
  /// The returned [StoreApp]s will have their `id` fields set.
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
  Future<List<StoreApp>> insert(
    _is.DatabaseSession session,
    List<StoreApp> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StoreApp>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StoreApp] and returns the inserted row.
  ///
  /// The returned [StoreApp] will have its `id` field set.
  Future<StoreApp> insertRow(
    _is.DatabaseSession session,
    StoreApp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StoreApp>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StoreApp]s in the list and returns the resulting rows.
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
  /// The returned [StoreApp]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoreApp>> upsert(
    _is.DatabaseSession session,
    List<StoreApp> rows, {
    required _is.ColumnSelections<StoreAppTable> conflictColumns,
    _is.ColumnSelections<StoreAppTable>? updateColumns,
    _is.WhereExpressionBuilder<StoreAppTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StoreApp>(
      rows,
      conflictColumns: conflictColumns(StoreApp.t),
      updateColumns: updateColumns?.call(StoreApp.t),
      updateWhere: updateWhere?.call(StoreApp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StoreApp] and returns the resulting row.
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
  /// The returned [StoreApp] will have its `id` field set.
  Future<StoreApp?> upsertRow(
    _is.DatabaseSession session,
    StoreApp row, {
    required _is.ColumnSelections<StoreAppTable> conflictColumns,
    _is.ColumnSelections<StoreAppTable>? updateColumns,
    _is.WhereExpressionBuilder<StoreAppTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StoreApp>(
      row,
      conflictColumns: conflictColumns(StoreApp.t),
      updateColumns: updateColumns?.call(StoreApp.t),
      updateWhere: updateWhere?.call(StoreApp.t),
      transaction: transaction,
    );
  }

  /// Updates all [StoreApp]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoreApp>> update(
    _is.DatabaseSession session,
    List<StoreApp> rows, {
    _is.ColumnSelections<StoreAppTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StoreApp>(
      rows,
      columns: columns?.call(StoreApp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StoreApp]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StoreApp> updateRow(
    _is.DatabaseSession session,
    StoreApp row, {
    _is.ColumnSelections<StoreAppTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StoreApp>(
      row,
      columns: columns?.call(StoreApp.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StoreApp] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StoreApp?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StoreAppUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StoreApp>(
      id,
      columnValues: columnValues(StoreApp.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StoreApp]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StoreApp>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StoreAppUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StoreAppTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StoreApp>(
      columnValues: columnValues(StoreApp.t.updateTable),
      where: where(StoreApp.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StoreApp]s in the list and returns the deleted rows.
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
  Future<List<StoreApp>> delete(
    _is.DatabaseSession session,
    List<StoreApp> rows, {
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StoreApp>(
      rows,
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StoreApp].
  Future<StoreApp> deleteRow(
    _is.DatabaseSession session,
    StoreApp row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StoreApp>(
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
  Future<List<StoreApp>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoreAppTable> where,
    _is.OrderByBuilder<StoreAppTable>? orderBy,
    _is.OrderByListBuilder<StoreAppTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StoreApp>(
      where: where(StoreApp.t),
      orderBy: orderBy?.call(StoreApp.t),
      orderByList: orderByList?.call(StoreApp.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StoreAppTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StoreApp>(
      where: where?.call(StoreApp.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StoreApp] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StoreAppTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StoreApp>(
      where: where(StoreApp.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class StoreAppAttachRowRepository {
  const StoreAppAttachRowRepository._();

  /// Creates a relation between the given [StoreApp] and [AppWish]
  /// by setting the [StoreApp]'s foreign key `wishId` to refer to the [AppWish].
  Future<void> wish(
    _is.DatabaseSession session,
    StoreApp storeApp,
    _ionsu37y.AppWish wish, {
    _is.Transaction? transaction,
  }) async {
    if (storeApp.id == null) {
      throw ArgumentError.notNull('storeApp.id');
    }
    if (wish.id == null) {
      throw ArgumentError.notNull('wish.id');
    }

    var $storeApp = storeApp.copyWith(wishId: wish.id);
    await session.db.updateRow<StoreApp>(
      $storeApp,
      columns: [StoreApp.t.wishId],
      transaction: transaction,
    );
  }
}
