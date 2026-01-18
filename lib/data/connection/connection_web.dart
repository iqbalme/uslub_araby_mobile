
import 'package:drift/wasm.dart';

QueryExecutor connect() {
  return WasmDatabase.opened(name: 'db');
}
