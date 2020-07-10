import 'package:flutter/material.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';
class BasicService extends ChangeNotifier{

  Future<Basic> selectBasicData() async {
    final db = await DBHelper().database;
    final List<Map<String,dynamic>> maps = await db.query(Basic.tableName);

    Basic basic = maps.isNotEmpty ? maps.map((e) => Basic.fromJson(e)).toList()[0] : null;

    return basic;
  }

}