import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class DailyService {

  selectDailyById(String dailyId) async {
    final db = await DBHelper().database;
    var res = await db.query(Daily.tableName, where: 'id = ?', whereArgs: [dailyId]);

    return res;
  }

  selectDailyByDate(DateTime date) async {
    final db = await DBHelper().database;
    var res = await db.query(Daily.tableName,
        where: 'day = ? and month = ? and year = ?',
        whereArgs: [date.day, date.month, date.year]);

    return Daily.fromJson(res[0]);
  }

  insertDaily(Daily daily) async {
    final db = await DBHelper().database;
    var res = await db.insert(Daily.tableName, daily.toJson());
    return res;
  }
}
