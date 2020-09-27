import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/daily/daily_service.dart';
import 'package:Dive/services/database/database_helper.dart';
import 'package:Dive/services/emotion/emotion_service.dart';
import 'package:Dive/services/tag/tag_service.dart';
import 'package:sqflite/sqflite.dart';

class RecordService {
  EmotionService _emotionService = EmotionService();
  TagService _tagService = TagService();
  DailyService _dailyService = DailyService();

  Future<int> insertRecord(Record record) async {
    final db = await DBHelper().database;
    return await db.insert(Record.tableName, record.toTableJson());
  }

  Future<List<Record>> selectAllRecord() async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName);

    List<Record> records =
        res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    return records;
  }

  Future<List<Record>> selectAllByDailyId(String dailyId) async {
    final db = await DBHelper().database;
    var res = await db
        .query(Record.tableName, where: 'dailyId = ?', whereArgs: [dailyId]);

    List<Record> records =
        res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    return records;
  }

  Future<List<Record>> selectAllWithEmotionsAndTagsByDailyId(
      String dailyId) async {
    final db = await DBHelper().database;
    var res = await db
        .query(Record.tableName, where: 'dailyId = ?', whereArgs: [dailyId]);

    List<Record> records =
        res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    records.sort((r1, r2) =>
        DateTime.parse(r2.createdAt).compareTo(DateTime.parse(r1.createdAt)));
    for (var _record in records) {
      _record.emotions =
          await _emotionService.selectEmotionAllByRecordId(_record.id);
      _record.tags = await _tagService.selectTagAllByRecordId(_record.id);
    }

    return records;
  }

  Future<List<Record>> selectAllWithEmotionsAndTagsByTimestampBetween(
      int startTimestamp, int endTimestamp) async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName,
        where: 'createdTimestamp >= ? and createdTimestamp < ?',
        whereArgs: [startTimestamp, endTimestamp]);

    List<Record> records =
        res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    records.sort((r1, r2) =>
        DateTime.parse(r2.createdAt).compareTo(DateTime.parse(r1.createdAt)));
    for (var _record in records) {
      _record.emotions =
          await _emotionService.selectEmotionAllByRecordId(_record.id);
      _record.tags = await _tagService.selectTagAllByRecordId(_record.id);
    }

    return records;
  }

  Future<int> updateRecord(Record record) async {
    final db = await DBHelper().database;
    var res = await db.update(Record.tableName, record.toJson(),
        where: 'id = ?', whereArgs: [record.id]);
    return res;
  }

  Future<int> deleteRecord(String recordId) async {
    final db = await DBHelper().database;
    return db
        .delete(Record.tableName, where: 'id = ?', whereArgs: [recordId]);
  }

  Future<int> deleteAllRecord() async {
    final db = await DBHelper().database;
    final tableName = Record.tableName;
    return db.rawDelete('DELETE * FROM $tableName');
  }
}
