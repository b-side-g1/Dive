import 'dart:async';

import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class BasicService {
  Future<Basic> selectBasicData() async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> immutableMaps =
        await db.query(Basic.tableName);

    Basic basic = immutableMaps.isNotEmpty
        ? immutableMaps.map((e) {
            return Basic.fromJson(e);
          }).toList()[0]
        : null;

    return basic;
  }

  Future<bool> isSetTodayEndAt() async {
    Basic basic = await this.selectBasicData();
    return basic.today_endAt != null ? true : false;
  }

  updateTodayAt(String hour) async {
    final db = await DBHelper().database;
    int updateCount = await db.rawUpdate('''
    UPDATE ${Basic.tableName} 
    SET today_endAt = ?, today_startAt = ?
    WHERE id = ?
    ''', [hour, hour, '1']);
    return updateCount;
  }

  void printHello() {
    print("Hello");
  }

  Future<int> updatePush(int isPush) async {
    final db = await DBHelper().database;
    int updateCount = await db.rawUpdate('''
    UPDATE ${Basic.tableName} 
    SET is_push = ?
    WHERE id = ?
    ''', [isPush, '1']);
    return updateCount;
  }

//  Future<bool> isSetTodayEndAt() async {
//    Basic basic = await this.selectBasicData();
//    return basic.today_endAt != null ? true : false;
//  }
}
