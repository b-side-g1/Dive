import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';


class RecordService {

  createRecord(Record record) async {
    final db = await DBHelper().database;
    var res = await db.insert(Record.tableName,record.toJson());
    return res;
  }

  getAllRecoard() async {
    final db = await DBHelper().database;
    var res = await db.query(Record.tableName);

    List<Record> records = res.isNotEmpty ? res.map((c) => Record.fromJson(c)).toList() : [];
    return records;
  }

}