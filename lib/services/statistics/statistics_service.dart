import 'package:Dive/commons/function.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/database/database_helper.dart';

import '../../models/daily_model.dart';
import '../../models/record_model.dart';
import '../database/database_helper.dart';

class StatisticsService {
  String getHello() {
    return 'Hello';
  }

  Future<double> getAverageScoreByMonth([int month, int year]) async {
    DateTime now = new DateTime.now();
    month = month ?? now.month;
    year = year ?? now.year;
    // , groupBy: '(year, month)'
    final db = await DBHelper().database;
    return db
        .query(Daily.tableName,
            columns: ['id'], where: 'month = $month AND year = $year')
        .then((ids) async => db
                .query(Record.tableName,
                    where:
                        "dailyId IN('${ids.map((e) => e['id']).join("', '")}')")
                .then((records) {
              var sum = records
                  .map((e) => Record.fromJson(e).score)
                  .reduce((a, b) => a + b);
              print(sum);
              return sum / records.length;
            }));
  }

//  Future<List<GraphDto>> getGraphData([int month, int year]) async {
  Future<List<Map<String, dynamic>>> getGraphData([int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT week, CAST(SUM(sum) AS REAL) / SUM(cnt) score
    FROM (SELECT CASE WHEN 7 >= day THEN 7
                      WHEN day BETWEEN 8 AND 14 THEN 14
                      WHEN day BETWEEN 15 AND 21 THEN 21
                      ELSE ?
                 END week,
                 SUM(r.score) sum,
                 COUNT(r.id) cnt
         FROM daily d JOIN record r ON d.id = r.dailyId
         WHERE d.month = ? AND d.year = ?
         GROUP BY d.year, d.month, d.day) t
    GROUP BY week
    ORDER BY week
    """,
        [getLastDay(month, year), month, year]).then((value) => value.toList());
  }

  Future<List<Map<String, dynamic>>> getHappyReasons() async {}
  Future<List<Map<String, dynamic>>> getUnHappyReasons() async {}
  Future<List<Map<String, dynamic>>> getMostFrequentReasons() async {}
  Future<List<Map<String, dynamic>>> getMostFrequentEmotions() async {}
}
