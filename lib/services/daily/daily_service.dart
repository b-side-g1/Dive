import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/database/database_helper.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class DailyService {
  BasicService _basicService = BasicService();

  selectDailyById(String dailyId) async {
    final db = await DBHelper().database;
    var res =
        await db.query(Daily.tableName, where: 'id = ?', whereArgs: [dailyId]);

    return res;
  }

  selectDailyByDate(DateTime date) async {
    final db = await DBHelper().database;
    var res = await db.query(Daily.tableName,
        where: 'day = ? and month = ? and year = ?',
        whereArgs: [date.day, date.month, date.year]);

    return res.isEmpty ? null : Daily.fromJson(res[0]);
  }

  insertDaily(Daily daily) async {
    final db = await DBHelper().database;
    var res = await db.insert(Daily.tableName, daily.toJson());
    return res;
  }

  Future<Daily> getDailyByTimestamp(int timestamp) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> immutableMaps = await db.query(
        Daily.tableName,
        where: 'startTimestamp <= ? and endTimestamp > ?',
        whereArgs: [timestamp, timestamp]);

    Daily daily;
    if (immutableMaps.isNotEmpty) {
      daily = immutableMaps.map((e) {
        return Daily.fromJson(e);
      }).toList()[0];
    } else {
      daily = await _insertDailyByTimestamp(timestamp);
    }

    return daily;
  }

  Future<Daily> _insertDailyByTimestamp(int timestamp) async {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    Basic basic = await _basicService.selectBasicData();
    int startHour = int.parse(basic.today_startAt);
    int endHour = int.parse(basic.today_endAt);

    DateTime startDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, startHour)
            .subtract(Duration(days: dateTime.hour > startHour ? 0 : 1));

    DateTime endDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, endHour)
            .add(Duration(days: dateTime.hour > endHour ? 1 : 0));

    Daily daily = Daily(
        id: CommonService.generateUUID(),
        startTimestamp: startDate.millisecondsSinceEpoch,
        endTimestamp: endDate.millisecondsSinceEpoch,
        startAt: startDate.toIso8601String(),
        endAt: endDate.toIso8601String(),
        weekday: startDate.weekday,
        day: startDate.day,
        week: weekNumber(startDate),
        month: startDate.month,
        year: startDate.year);

    await insertDaily(daily);

    return daily;
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
