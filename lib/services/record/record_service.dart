import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';


class RecordService {

  insertRecord(Record record) async {
    final db = await DBHelper().database;
    var res = await db.insert(Record.tableName,record.toJson());
    return res;
  }

  selectAllRecord() async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName);

    List<Record> records = res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
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

  deleteAllRecord(String recordId) async {
    final db = await DBHelper().database;
    final tableName = Record.tableName;
    await db.rawDelete('DELETE * FROM $tableName');
  }

}