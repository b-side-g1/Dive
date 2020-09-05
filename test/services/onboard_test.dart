import 'package:flutter/material.dart';
import 'package:test/test.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../config_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  test('BASIC 테이블 쿼리', () async {
    sqfliteFfiInit();
    String path = TEST_DATABASE_PATH;

    var db = await databaseFactoryFfi.openDatabase(path);

    List<Map<String, dynamic>> maps = await db.query(Basic.tableName);

    Basic basic = maps.isNotEmpty ? maps.map((e) {
      return Basic.fromJson(e);
    }).toList()[0] : null;

    print(basic.toJson());

    await db.close();
    expect(0, 0);
  });
}
