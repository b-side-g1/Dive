import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/models/record_has_emotion.dart';
import 'package:Dive/models/record_has_tag.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/models/tag_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Dive/commons/static.dart';
import 'package:Dive/services/common/common_service.dart';
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
    var recordDDL = "CREATE TABLE $recordTable (id TEXT PRIMARY KEY, score INTEGER, description TEXT, dailyId TEXT, createdAt TEXT, updatedAt TEXT, createdTimestamp INTEGER)";
    ddlList.add(recordDDL);

    var dailyTable = Daily.tableName;
    var dailyDDL = "CREATE TABLE $dailyTable (id TEXT PRIMARY KEY, startTimestamp INTEGER, endTimestamp INTEGER, startAt TEXT, endAt TEXT, weekday INTEGER, day INTEGER, week INTEGER, month INTEGER, year INTEGER)";
    ddlList.add(dailyDDL);

    var tagTable = Tag.tableName;
    var tagDDL = "CREATE TABLE $tagTable (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)";
    ddlList.add(tagDDL);

    var recordHasTagTable = RecordHasTag.tableName;
    var recordHasTagDDL = "CREATE TABLE $recordHasTagTable (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, tagId TEXT, createdAt TEXT)";
    ddlList.add(recordHasTagDDL);

    var emotionTable = Emotion.tableName;
    var emotionDDL = "CREATE TABLE $emotionTable (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)";
    ddlList.add(emotionDDL);

    var recordHasEmotionTable = RecordHasEmotion.tableName;
    var recordHasEmotionDDL = "CREATE TABLE $recordHasEmotionTable (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, emotionId TEXT, createdAt TEXT)";
    ddlList.add(recordHasEmotionDDL);

    var basicTable = Basic.tableName;
    String basicDDL = "CREATE TABLE $basicTable (id TEXT PRIMARY KEY, today_startAt TEXT, today_endAt TEXT, status TEXT, is_push INTEGER, uuid TEXT, createdAt TEXT)";
    ddlList.add(basicDDL);


    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        ddlList.forEach((ddl) async {
          await db.execute(ddl);
        });
        await db.rawInsert(
            'INSERT INTO basic(id,status,is_push,uuid) VALUES("1","FST","0","0123456789")'
        );
        String nowDate = DateTime.now().toString();

        TagNames.forEach((tag) async {
          String uuid = CommonService.generateUUID();
          await db.rawInsert(
              'INSERT INTO tag(id,name,createdAt) VALUES(?,?,?)',
              [uuid,tag,nowDate]
          );
        });

        for(int i=0; i<EmotionNames.length; i++) {
          await db.rawInsert(
              'INSERT INTO emotion(id,name) VALUES(?,?)',
              [(i+1).toString(),EmotionNames[i]]
          );
        }
      });
  }
}