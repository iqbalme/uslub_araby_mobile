// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UslubTable extends Uslub with TableInfo<$UslubTable, UslubData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UslubTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _arabMeta = const VerificationMeta('arab');
  @override
  late final GeneratedColumn<String> arab = GeneratedColumn<String>(
    'arab',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latinMeta = const VerificationMeta('latin');
  @override
  late final GeneratedColumn<String> latin = GeneratedColumn<String>(
    'latin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, arab, latin];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'uslub';
  @override
  VerificationContext validateIntegrity(
    Insertable<UslubData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('arab')) {
      context.handle(
        _arabMeta,
        arab.isAcceptableOrUnknown(data['arab']!, _arabMeta),
      );
    } else if (isInserting) {
      context.missing(_arabMeta);
    }
    if (data.containsKey('latin')) {
      context.handle(
        _latinMeta,
        latin.isAcceptableOrUnknown(data['latin']!, _latinMeta),
      );
    } else if (isInserting) {
      context.missing(_latinMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UslubData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UslubData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      arab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}arab'],
      )!,
      latin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}latin'],
      )!,
    );
  }

  @override
  $UslubTable createAlias(String alias) {
    return $UslubTable(attachedDatabase, alias);
  }
}

class UslubData extends DataClass implements Insertable<UslubData> {
  final int id;
  final String arab;
  final String latin;
  const UslubData({required this.id, required this.arab, required this.latin});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['arab'] = Variable<String>(arab);
    map['latin'] = Variable<String>(latin);
    return map;
  }

  UslubCompanion toCompanion(bool nullToAbsent) {
    return UslubCompanion(
      id: Value(id),
      arab: Value(arab),
      latin: Value(latin),
    );
  }

  factory UslubData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UslubData(
      id: serializer.fromJson<int>(json['id']),
      arab: serializer.fromJson<String>(json['arab']),
      latin: serializer.fromJson<String>(json['latin']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'arab': serializer.toJson<String>(arab),
      'latin': serializer.toJson<String>(latin),
    };
  }

  UslubData copyWith({int? id, String? arab, String? latin}) => UslubData(
    id: id ?? this.id,
    arab: arab ?? this.arab,
    latin: latin ?? this.latin,
  );
  UslubData copyWithCompanion(UslubCompanion data) {
    return UslubData(
      id: data.id.present ? data.id.value : this.id,
      arab: data.arab.present ? data.arab.value : this.arab,
      latin: data.latin.present ? data.latin.value : this.latin,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UslubData(')
          ..write('id: $id, ')
          ..write('arab: $arab, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, arab, latin);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UslubData &&
          other.id == this.id &&
          other.arab == this.arab &&
          other.latin == this.latin);
}

class UslubCompanion extends UpdateCompanion<UslubData> {
  final Value<int> id;
  final Value<String> arab;
  final Value<String> latin;
  const UslubCompanion({
    this.id = const Value.absent(),
    this.arab = const Value.absent(),
    this.latin = const Value.absent(),
  });
  UslubCompanion.insert({
    this.id = const Value.absent(),
    required String arab,
    required String latin,
  }) : arab = Value(arab),
       latin = Value(latin);
  static Insertable<UslubData> custom({
    Expression<int>? id,
    Expression<String>? arab,
    Expression<String>? latin,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (arab != null) 'arab': arab,
      if (latin != null) 'latin': latin,
    });
  }

  UslubCompanion copyWith({
    Value<int>? id,
    Value<String>? arab,
    Value<String>? latin,
  }) {
    return UslubCompanion(
      id: id ?? this.id,
      arab: arab ?? this.arab,
      latin: latin ?? this.latin,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (arab.present) {
      map['arab'] = Variable<String>(arab.value);
    }
    if (latin.present) {
      map['latin'] = Variable<String>(latin.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UslubCompanion(')
          ..write('id: $id, ')
          ..write('arab: $arab, ')
          ..write('latin: $latin')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UslubTable uslub = $UslubTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [uslub];
}

typedef $$UslubTableCreateCompanionBuilder =
    UslubCompanion Function({
      Value<int> id,
      required String arab,
      required String latin,
    });
typedef $$UslubTableUpdateCompanionBuilder =
    UslubCompanion Function({
      Value<int> id,
      Value<String> arab,
      Value<String> latin,
    });

class $$UslubTableFilterComposer extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get arab => $composableBuilder(
    column: $table.arab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UslubTableOrderingComposer
    extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get arab => $composableBuilder(
    column: $table.arab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get latin => $composableBuilder(
    column: $table.latin,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UslubTableAnnotationComposer
    extends Composer<_$AppDatabase, $UslubTable> {
  $$UslubTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get arab =>
      $composableBuilder(column: $table.arab, builder: (column) => column);

  GeneratedColumn<String> get latin =>
      $composableBuilder(column: $table.latin, builder: (column) => column);
}

class $$UslubTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UslubTable,
          UslubData,
          $$UslubTableFilterComposer,
          $$UslubTableOrderingComposer,
          $$UslubTableAnnotationComposer,
          $$UslubTableCreateCompanionBuilder,
          $$UslubTableUpdateCompanionBuilder,
          (UslubData, BaseReferences<_$AppDatabase, $UslubTable, UslubData>),
          UslubData,
          PrefetchHooks Function()
        > {
  $$UslubTableTableManager(_$AppDatabase db, $UslubTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UslubTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UslubTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UslubTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> arab = const Value.absent(),
                Value<String> latin = const Value.absent(),
              }) => UslubCompanion(id: id, arab: arab, latin: latin),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String arab,
                required String latin,
              }) => UslubCompanion.insert(id: id, arab: arab, latin: latin),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UslubTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UslubTable,
      UslubData,
      $$UslubTableFilterComposer,
      $$UslubTableOrderingComposer,
      $$UslubTableAnnotationComposer,
      $$UslubTableCreateCompanionBuilder,
      $$UslubTableUpdateCompanionBuilder,
      (UslubData, BaseReferences<_$AppDatabase, $UslubTable, UslubData>),
      UslubData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UslubTableTableManager get uslub =>
      $$UslubTableTableManager(_db, _db.uslub);
}
