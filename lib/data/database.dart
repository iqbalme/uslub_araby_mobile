
import 'package:drift/drift.dart';
import 'connection/connection.dart' as impl;

part 'database.g.dart';

@DataClassName('UslubData')
class Uslub extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get arab => text()();
  TextColumn get latin => text()();
}

@DriftDatabase(tables: [Uslub])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 1;

  Future<List<UslubData>> getAllWords() => select(uslub).get();

  Future<List<UslubData>> searchWords(String query) {
    return (select(uslub)..where((t) => t.arab.like('%$query%') | t.latin.like('%$query%'))).get();
  }
}
