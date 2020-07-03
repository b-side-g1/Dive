import 'dart:io';

import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_has_emotion.dart';
import 'package:flutterapp/models/record_has_tag.dart';
import 'package:flutterapp/models/tag_model.dart';
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
    String path = join(documentsDirectory.path, 'diary_app_database.db');

    var ddlList = [];
    var ddl = "";
    var recordTable = Record.tableName;
    var recordDDL = "CREATE TABLE $recordTable(id TEXT PRIMARY KEY, score INTEGER, description TEXT, dailyId TEXT, createdAt DATETIME, updatedAt DATETIME)";
    ddlList.add(recordDDL);

    var dailyTable = Daily.tableName;
    var dailyDDL = "CREATE TABLE $dailyTable(id TEXT PRIMARY KEY, startAt DATETIME, endAt DATETIME, weekday INTEGER, day INTEGER, week INTEGER, month INTEGER, year INTEGER)";
    ddlList.add(dailyDDL);

    var tagTable = Tag.tableName;
    var tagDDL = "CREATE TABLE $tagTable(id TEXT PRIMARY KEY, name TEXT)";
    ddlList.add(tagDDL);

    var recordHasTagTable = RecordHasTag.tableName;
    var recordHasTagDDL = "CREATE TABLE $recordHasTagTable(idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, tagId TEXT, name TEXT)";
    ddlList.add(recordHasTagDDL);

    var emotionTable = Emotion.tableName;
    var emotionDDL = "CREATE TABLE $emotionTable(id TEXT PRIMARY KEY, name TEXT)";
    ddlList.add(emotionDDL);

    var recordHasEmotionTable = RecordHasEmotion.tableName;
    var recordHasEmotionDDL = "CREATE TABLE $recordHasEmotionTable(idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, emotionId TEXT, name TEXT)";
    ddlList.add(recordHasEmotionDDL);

    ddl +=  dailyDDL + ";";
//    ddl +=  "\n" + dailyDDL + ";";
//    ddl +=  "\n" + tagDDL + ";";
//    ddl +=  "\n" + recordHasTagDDL + ";";
//    ddl +=  "\n" + emotionDDL + ";";
//    ddl +=  "\n" + recordHasEmotionDDL + ";";
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        ddlList.forEach((ddl) async {
          print("@@@@@@@@@@ddl: " + ddl);
          await db.execute(ddl);
        });
      }
    );
  }
}