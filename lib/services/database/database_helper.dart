import 'dart:io';

import 'package:flutterapp/models/basic_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutterapp/models/record_model.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MoodTrackDB');

    var recordTable = Record.tableName;
    var basicTable = Basic.tableName;
    String recordDDL = "CREATE TABLE $recordTable(id TEXT PRIMARY KEY, score INTEGER, description TEXT)";
    String basicDDL = "CREATE TABLE $basicTable(id TEXT PRIMARY KEY, today_startAt TEXT, today_endAt TEXT, status TEXT, is_push INTEGER, uuid TEXT, createdAt TEXT)";

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(recordDDL);
        await db.execute(basicDDL);
        await db.rawInsert(
          'INSERT INTO basic(id,status,is_push,uuid) VALUES("1","FST","0","0123456789")'
        );
      }
    );
  }


}