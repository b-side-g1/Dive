import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/services/basic/basic_service.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:Dive/services/database/database_helper.dart';
import 'package:intl/intl.dart';

class DailyService {
  final BasicService _basicService = BasicService();

  Future<List<Map<String, dynamic>>> selectDailyById(String dailyId) async {
    final db = await DBHelper().database;
    return await db
        .query(Daily.tableName, where: 'id = ?', whereArgs: [dailyId]);
  }

  Future<Daily?> selectDailyByDate(DateTime date) async {
    final db = await DBHelper().database;
    var res = await db.query(Daily.tableName,
        where: 'day = ? and month = ? and year = ?',
        whereArgs: [date.day, date.month, date.year]);

    return res.isEmpty ? null : Daily.fromJson(res[0]);
  }

  Future<List<DateTime>> selectRecordedDaily(int year) async {
    final db = await DBHelper().database;
    return db.rawQuery("""
      SELECT year,month,day FROM record
      JOIN daily
      ON dailyId = daily.id
      WHERE year = ?
      GROUP BY day;
    """, [year]).then((value) => value
        .map((e) => DateTime(
            e["year"] as int, e["month"] as int, e["day"] as int))
        .toList());
  }

  Future<int> insertDaily(Daily daily) async {
    final db = await DBHelper().database;
    return await db.insert(Daily.tableName, daily.toJson());
  }

  Future<Daily?> getDailyByTimestamp(int timestamp, bool create) async {
    final db = await DBHelper().database;
    final List<Map<String, dynamic>> immutableMaps = await db.query(
        Daily.tableName,
        where: 'startTimestamp <= ? and endTimestamp > ?',
        whereArgs: [timestamp, timestamp]);

    if (immutableMaps.isNotEmpty) {
      return immutableMaps.map((e) => Daily.fromJson(e)).toList()[0];
    } else if (create) {
      return insertDailyByTimestamp(timestamp);
    }

    return null;
  }

  Future<Daily> insertDailyByTimestamp(int timestamp, [Basic? basic]) async {
    basic = basic ?? await _basicService.selectBasicData();
    Daily daily = createDaily(
      timestamp,
      int.parse(basic.today_startAt ?? '0'),
      int.parse(basic.today_endAt),
    );
    return insertDaily(daily).then((value) => daily);
  }

  Daily createDaily(int timestamp, int startHour, int endHour) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime startDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, startHour)
            .subtract(Duration(days: dateTime.hour >= startHour ? 0 : 1));

    DateTime endDate =
        DateTime(dateTime.year, dateTime.month, dateTime.day, endHour)
            .add(Duration(days: dateTime.hour >= endHour ? 1 : 0));

    return Daily(
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
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}
