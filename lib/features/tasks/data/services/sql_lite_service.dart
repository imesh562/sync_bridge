import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sync_bridge/utils/app_constants.dart';

@lazySingleton
class SQLiteService {
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), AppConstants.dbSchemaName);

    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createTasksTable);
    await db.execute(_createOfflineQueueTable);
  }

  static const _createTasksTable = '''
    CREATE TABLE tasks (
      id          INTEGER PRIMARY KEY,
      user_id     INTEGER NOT NULL,
      title       TEXT    NOT NULL,
      completed   INTEGER NOT NULL DEFAULT 0,
      updated_at  INTEGER NOT NULL,
      is_dirty    INTEGER NOT NULL DEFAULT 0,
      is_conflict INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const _createOfflineQueueTable = '''
    CREATE TABLE offline_queue (
      id          INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id     INTEGER NOT NULL UNIQUE ON CONFLICT REPLACE,
      payload     TEXT    NOT NULL,
      created_at  INTEGER NOT NULL
    )
  ''';

  Future<void> dispose() async {
    await _db?.close();
    _db = null;
  }
}
