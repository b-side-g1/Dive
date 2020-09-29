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
}
