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
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await (Platform.environment.containsKey('TEST_DB_PATH')
        ? databaseFactoryFfi.openDatabase(Platform.environment['TEST_DB_PATH'])
        : initDB());
    return _database;
  }

  initDB() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return openDatabase(join(await getDatabasesPath(), 'diary_app_database.db'),
        version: 1, onCreate: (Database db, int version) async {
      Migration v1 = new V1Initialization();
      await db.transaction((txn) async {
        await v1.up(txn);
        txn.query('COMMIT');
        return;
        // TOOD: 배포 이후에는 DB 스키마 변경 시, v1을 대체하는 게 아니라, v2를 만들어 줘야 함.
        // 그래야, v1 DB를 갖고 있는 사람과 v1을 받지 않은 사람 모두 동일한 스키마를 가질 수 있음.
      });
    });
  }
}
