import 'dart:convert';

import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';
import 'package:sqflite/sqlite_api.dart';

class StatisticsService {
  Future<Database> get db => getDB();
  Function getDB = () => DBHelper().database;

  StatisticsService([this.getDB]);

  String getHello() {
    return 'Hello';
  }

  Future<double> getAverageScoreByMonth([int month, int year]) async {
    DateTime now = new DateTime.now();
    month = month ?? now.month;
    year = year ?? now.year;
    // , groupBy: '(year, month)'
    return db.then((db) {
      return db
          .query(Daily.tableName,
              columns: ['id'], where: 'month = $month AND year = $year')
          .then((ids) async {
        return db
            .query(Record.tableName,
                where: "dailyId IN('${ids.map((e) => e['id']).join("', '")}')")
            .then((records) {
          var sum = records
              .map((e) => Record.fromJson(e).score)
              .reduce((a, b) => a + b);
          print(sum);
          return sum / records.length;
        });
      });
    });
  }
}
