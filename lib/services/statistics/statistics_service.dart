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

  Future<List<Map<String, dynamic>>> getHappyReasons(
      [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT t.id, t.name name,
           COUNT(*) count,
           MAX(r.updatedAt) lastUpdatedAt
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasTag rt ON r.id = rt.recordId
                 JOIN tag t ON t.id = rt.tagId
    WHERE d.month = ? AND d.year = ? AND r.score >= 70
    GROUP BY t.id, t.name
    ORDER BY count DESC, lastUpdatedAt DESC
    limit 5
    """, [month, year]).then((value) => value.toList());
  }

  Future<List<Map<String, dynamic>>> getUnHappyReasons(
      [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT t.id, t.name name,
           COUNT(*) count,
           MAX(r.updatedAt) lastUpdatedAt
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasTag rt ON r.id = rt.recordId
                 JOIN tag t ON t.id = rt.tagId
    WHERE d.month = ? AND d.year = ? AND r.score <= 30
    GROUP BY t.id, t.name
    ORDER BY count DESC, lastUpdatedAt DESC
    limit 5
    """, [month, year]).then((value) => value.toList());
  }

  Future<List<Map<String, dynamic>>> getMostFrequentTags(
      [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    int totalCount = await getTagCount(month, year);
    return db.rawQuery("""
    SELECT t.id, t.name name,
           COUNT(*) / CAST( ? as REAL) * 100 percent,
           MAX(r.updatedAt) lastUpdatedAt
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasTag rt ON r.id = rt.recordId
                 JOIN tag t ON t.id = rt.tagId
    WHERE d.month = ? AND d.year = ?
    GROUP BY t.id, t.name
    ORDER BY percent DESC, lastUpdatedAt DESC
    limit 3
    """, [totalCount, month, year]).then((value) => value.toList());
  }

  Future<List<Map<String, dynamic>>> getMostFrequentEmotions(
      [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    int totalCount = await getEmotionCount(month, year);
    return db.rawQuery("""
    SELECT e.id, e.name name,
           COUNT(*) / CAST( ? as REAL) * 100 percent,
           MAX(r.updatedAt) lastUpdatedAt
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasEmotion re ON r.id = re.recordId
                 JOIN emotion e ON e.id = re.emotionId
    WHERE d.month = ? AND d.year = ?
    GROUP BY e.id, e.name
    ORDER BY percent DESC, lastUpdatedAt DESC
    limit 3
    """, [totalCount, month, year]).then((value) => value.toList());
  }

  Future<int> getTagCount([int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT COUNT(*) cnt 
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasTag rt ON r.id = rt.recordId
                 JOIN tag t ON t.id = rt.tagId
    WHERE d.month = ? AND d.year = ?
    """, [month, year]).then((value) => value[0]['cnt']);
  }

  Future<int> getEmotionCount([int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT COUNT(*) cnt
    FROM daily d JOIN record r ON d.id = r.dailyId
                 JOIN recordHasEmotion re ON r.id = re.recordId
                 JOIN emotion e ON e.id = re.emotionId
    WHERE d.month = ? AND d.year = ?
    """, [month, year]).then((value) => value[0]['cnt']);
  }

  Future getDetailsByEmotionName(String name, [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT d.day day,
           r.score score,
           r.description description,
           GROUP_CONCAT(t.name) tags
    FROM emotion e JOIN recordHasEmotion re ON e.id = re.emotionId
                   JOIN record r ON r.id = re.recordId
                   JOIN daily d ON d.id = r.dailyId
                   LEFT OUTER JOIN recordHasTag rt ON r.id = rt.recordId
                   LEFT OUTER JOIN tag t ON t.id = rt.tagId
    WHERE e.name = ? AND d.month = ? AND d.year = ?
    GROUP BY d.day, r.id
    ORDER BY d.day DESC
    """, [name, month, year]).then((value) => value.toList());
  }

  Future getDetailsByTagName(String name, [int month, int year]) async {
    month = month ?? DateTime.now().month;
    year = year ?? DateTime.now().year;
    final db = await DBHelper().database;
    return db.rawQuery("""
    SELECT d.day day,
           r.score score,
           r.description description,
           GROUP_CONCAT(e.name) emotions
    FROM tag t JOIN recordHasTag rt ON t.id = rt.tagId
                   JOIN record r ON r.id = rt.recordId
                   JOIN daily d ON d.id = r.dailyId
                   LEFT OUTER JOIN recordHasEmotion re ON r.id = re.recordId
                   LEFT OUTER JOIN emotion e ON e.id = re.emotionId
    WHERE t.name = ? AND d.month = ? AND d.year = ?
    GROUP BY d.day, t.id
    ORDER BY d.day DESC
    """, [name, month, year]).then((value) => value.toList());
  }
}
