import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/database/database_helper.dart';
import 'package:flutterapp/services/emotion/emotion_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';


class RecordService {

  EmotionService _emotionService = EmotionService();
  TagService _tagService = TagService();
  DailyService _dailyService = DailyService();

  insertRecord(Record record, int timestamp) async {
    final db = await DBHelper().database;

    Daily daily = await _dailyService.getDailyByTimestamp(timestamp);
    var res = await db.insert(Record.tableName,record.toTableJson());
    return res;
  }

  Future<List<Record>> selectAllRecord() async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName);

    List<Record> records = res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    return records;
  }

  Future<List<Record>> selectAllByDailyId(String dailyId) async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName, where: 'dailyId = ?', whereArgs: [dailyId]);

    List<Record> records = res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    return records;
  }

  Future<List<Record>> selectAllWithEmotionsAndTagsByDailyId(String dailyId) async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName, where: 'dailyId = ?', whereArgs: [dailyId]);

    List<Record> records = res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    records.forEach((_record) async {
      _record.emotions = await _emotionService.selectEmotionAllByRecordId(_record.id);
      _record.tags = await _tagService.selectTagAllByRecordId(_record.id);
    });

    return records;
  }

  updateRecord(Record record) async {
    final db = await DBHelper().database;
    var res = await db.update(Record.tableName,record.toJson(),where: 'id = ?', whereArgs: [record.id]);
    return res;
  }

  deleteRecord(String recordId) async {
    final db = await DBHelper().database;
    await db.delete(Record.tableName,where: 'id = ?' ,whereArgs: [recordId]);
  }

  deleteAllRecord() async {
    final db = await DBHelper().database;
    final tableName = Record.tableName;
    await db.rawDelete('DELETE * FROM $tableName');
  }
}