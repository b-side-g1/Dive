import 'package:flutter/material.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';
class BasicService extends ChangeNotifier{

  Future<Basic> selectBasicData() async {
    final db = await DBHelper().database;

    final List<Map<String,dynamic>> immutableMaps = await db.query(Basic.tableName);

    Basic basic = immutableMaps.isNotEmpty ? immutableMaps.map((e) {
      return Basic.fromJson(e);
    }).toList()[0] : null;

    return basic;
  }

  Future<bool> isSetTodayEndAt() async {
    Basic basic = await this.selectBasicData();
    return basic.today_endAt != null ? true : false;
  }

//  Future<bool> isSetTodayEndAt() async {
//    Basic basic = await this.selectBasicData();
//    return basic.today_endAt != null ? true : false;
//  }
}