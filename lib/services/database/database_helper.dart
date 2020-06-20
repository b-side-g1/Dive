import 'dart:io';

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
    var ddl = "";
    var recordDDL = "CREATE TABLE $recordTable(id TEXT PRIMARY KEY, score INTEGER, description TEXT)";

    ddl += recordDDL;

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(ddl);
      }
    );
  }


}