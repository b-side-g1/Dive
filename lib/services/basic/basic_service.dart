import 'package:flutter/material.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';
class BasicService extends ChangeNotifier{

  getBasicData() async {
    final db = await DBHelper().database;
    var res = await db.query(Basic.tableName);
    return res;
  }

}