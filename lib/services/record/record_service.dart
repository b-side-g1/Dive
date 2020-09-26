import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/database/database_helper.dart';
import 'package:flutterapp/services/emotion/emotion_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:sqflite/sqflite.dart';

class RecordService {
  EmotionService _emotionService = EmotionService();
  TagService _tagService = TagService();
  DailyService _dailyService = DailyService();
  Future<Database> get db => getDB();
  Function getDB = () => DBHelper().database;

  RecordService([this.getDB]);

  Future<int> insertRecord(Record record, [DatabaseExecutor txn]) async {
    return (txn ?? await db).insert(Record.tableName, record.toTableJson());
  }

  Future<List<Record>> selectAllRecord() async {
    var res = await (await db).query(Record.tableName);

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
    var res = await (await db)
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
    var res = await (await db).query(Record.tableName,
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
    var res = await (await db).update(Record.tableName, record.toJson(),
        where: 'id = ?', whereArgs: [record.id]);
    return res;
  }

  Future<int> deleteRecord(String recordId) async {
    return (await db)
        .delete(Record.tableName, where: 'id = ?', whereArgs: [recordId]);
  }

  Future<int> deleteAllRecord() async {
    final tableName = Record.tableName;
    return (await db).rawDelete('DELETE * FROM $tableName');
  }
}
