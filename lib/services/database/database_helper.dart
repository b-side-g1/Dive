import 'dart:io';

import 'package:flutterapp/models/basic_model.dart';
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
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(await getDatabasesPath(), 'diary_app_database.db');

    var ddlList = [];
    var recordTable = Record.tableName;
    var recordDDL = "CREATE TABLE $recordTable (id TEXT PRIMARY KEY, score INTEGER, description TEXT, dailyId TEXT, createdAt TEXT, updatedAt TEXT)";
    ddlList.add(recordDDL);

    var dailyTable = Daily.tableName;
    var dailyDDL = "CREATE TABLE $dailyTable (id TEXT PRIMARY KEY, startAt TEXT, endAt TEXT, weekday INTEGER, day INTEGER, week INTEGER, month INTEGER, year INTEGER)";
    ddlList.add(dailyDDL);

    var tagTable = Tag.tableName;
    var tagDDL = "CREATE TABLE $tagTable (id TEXT PRIMARY KEY, name TEXT)";
    ddlList.add(tagDDL);

    var recordHasTagTable = RecordHasTag.tableName;
    var recordHasTagDDL = "CREATE TABLE $recordHasTagTable (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, tagId TEXT, name TEXT)";
    ddlList.add(recordHasTagDDL);

    var emotionTable = Emotion.tableName;
    var emotionDDL = "CREATE TABLE $emotionTable (id TEXT PRIMARY KEY, name TEXT)";
    ddlList.add(emotionDDL);

    var basicTable = Basic.tableName;
    String basicDDL = "CREATE TABLE $basicTable(id TEXT PRIMARY KEY, today_startAt TEXT, today_endAt TEXT, status TEXT, is_push INTEGER, uuid TEXT, createdAt TEXT)";
    ddlList.add(basicDDL);

    var recordHasEmotionTable = RecordHasEmotion.tableName;
    var recordHasEmotionDDL = "CREATE TABLE $recordHasEmotionTable (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, emotionId TEXT, name TEXT)";
    ddlList.add(recordHasEmotionDDL);

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) {
        ddlList.forEach((ddl) async {
          await db.execute(ddl);
        });
        await db.rawInsert(
            'INSERT INTO basic(id,status,is_push,uuid) VALUES("1","FST","0","0123456789")'
        );
    );
  }
}