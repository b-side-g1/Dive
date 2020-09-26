import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:flutterapp/services/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';

class DailyService {
  BasicService _basicService = BasicService();
  Future<Database> db;

  DailyService([Future<Database> db]) {
    this.db = db ?? DBHelper().database;
  }

  Future<List<Map<String, dynamic>>> selectDailyById(String dailyId) async {
    return (await db)
        .query(Daily.tableName, where: 'id = ?', whereArgs: [dailyId]);
  }

  selectDailyByDate(DateTime date) async {
    var res = await (await db).query(Daily.tableName,
        where: 'day = ? and month = ? and year = ?',
        whereArgs: [date.day, date.month, date.year]);

    return res.isEmpty ? null : Daily.fromJson(res[0]);
  }

  Future<int> insertDaily(Daily daily) async {
    return (await db).insert(Daily.tableName, daily.toJson());
  }

  Future<Daily> getDailyByTimestamp(int timestamp, bool create) async {
    final List<Map<String, dynamic>> immutableMaps = await (await db).query(
        Daily.tableName,
        where: 'startTimestamp <= ? and endTimestamp > ?',
        whereArgs: [timestamp, timestamp]);

    Daily daily;
    if (immutableMaps.isNotEmpty) {
      daily = immutableMaps.map((e) {
        return Daily.fromJson(e);
      }).toList()[0];
    } else if (create) {
      return insertDailyByTimestamp(timestamp);
    }

    return daily;
  }

  Future<Daily> insertDailyByTimestamp(int timestamp) async {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    Basic basic = await _basicService.selectBasicData();
    int startHour = int.parse(basic.today_startAt);
    int endHour = int.parse(basic.today_endAt);

    DateTime startDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, startHour)
            .subtract(Duration(days: dateTime.hour >= startHour ? 0 : 1));

    DateTime endDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, endHour)
            .add(Duration(days: dateTime.hour >= endHour ? 1 : 0));

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
