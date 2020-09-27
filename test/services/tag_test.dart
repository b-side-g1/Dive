import 'package:Dive/models/tag_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  test('TAG 테이블 쿼리', () async {
    sqfliteFfiInit();
    String path = "D:\\android\\diary-app\\diary_app_database.db";

    var db = await databaseFactoryFfi.openDatabase(path);

    List<Map<String, dynamic>> res = await db.query(Tag.tableName);
    List<Tag> tags =
    res.isNotEmpty ? res.map((c) => Tag.fromJson(c)).toList() : [];

    print(res);
    print(tags.length);

    await db.close();

    expect(0, 0);
  });

  test('TAG 등록', () async {
    sqfliteFfiInit();
    String path = "D:\\android\\diary-app\\diary_app_database.db";
    var db = await databaseFactoryFfi.openDatabase(path);
    final tagParam = Tag(id: "123456789", name: "테스트1");
    final res = await db.insert(Tag.tableName,tagParam.toJson());
    print(res);
    await db.close();
    expect(0, 0);
  });
}
