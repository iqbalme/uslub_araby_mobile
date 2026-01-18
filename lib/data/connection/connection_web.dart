import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor connect() {
  // Gunakan localStorage sebagai fallback yang lebih compatible
  return WebDatabase('uslub_araby_db');
}
