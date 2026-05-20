import 'dart:io';

import 'package:Dive/migrations/migration.dart';
import 'package:Dive/migrations/v1_initialization.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    final testDbPath = Platform.environment['TEST_DB_PATH'];
    _database = await (testDbPath != null
        ? databaseFactoryFfi.openDatabase(testDbPath)
        : initDB());
    return _database!;
  }

  Future<Database> initDB() async {
    return openDatabase(
        join(await getDatabasesPath(), 'diary_app_database.db'),
        version: 1, onCreate: (Database db, int version) async {
      Migration v1 = V1Initialization();
      await db.transaction((txn) async {
        await v1.up(txn);
        return;
      });
    });
  }
}
