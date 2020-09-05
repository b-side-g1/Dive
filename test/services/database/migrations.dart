import 'dart:core';

import 'package:flutterapp/commons/static.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:sqflite/sqflite.dart';

final createTableQueries = [
  "CREATE TABLE record (id TEXT PRIMARY KEY, score INTEGER, description TEXT, dailyId TEXT, createdAt TEXT, updatedAt TEXT, createdTimestamp INTEGER)",
  "CREATE TABLE daily (id TEXT PRIMARY KEY, startTimestamp INTEGER, endTimestamp INTEGER, startAt TEXT, endAt TEXT, weekday INTEGER, day INTEGER, week INTEGER, month INTEGER, year INTEGER)",
  "CREATE TABLE tag (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)",
  "CREATE TABLE recordHasTag (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, tagId TEXT, createdAt TEXT)",
  "CREATE TABLE emotion (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)",
  "CREATE TABLE recordHasEmotion (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, emotionId TEXT, createdAt TEXT)",
  "CREATE TABLE basic (id TEXT PRIMARY KEY, today_startAt TEXT, today_endAt TEXT, status TEXT, is_push INTEGER, uuid TEXT, createdAt TEXT)",
];

final dropTableQueries = [
  "DROP TABLE IF EXISTS basic",
  "DROP TABLE IF EXISTS recordHasEmotion",
  "DROP TABLE IF EXISTS emotion",
  "DROP TABLE IF EXISTS recordHasTag",
  "DROP TABLE IF EXISTS tag",
  "DROP TABLE IF EXISTS daily",
  "DROP TABLE IF EXISTS record",
];

createTables(Database db) async {
  return db.transaction((txn) async {
    return Future.wait(createTableQueries.map((e) => txn.execute(e)));
  });
}

dropTables(Database db) async {
  return db.transaction((txn) async {
    return Future.wait(dropTableQueries.map((e) => txn.execute(e)));
  });
}

insertTagNames(Database db) async {
  String nowDate = DateTime.now().toString();
  db.transaction((txn) async {
    return Future.wait(TagNames.map((tag) async {
      String uuid = CommonService.generateUUID();
      return txn.rawInsert(
          'INSERT INTO tag(id,name,createdAt) VALUES(?,?,?)',
          [uuid, tag, nowDate]);
    }));
  });
}

insertBasic(DatabaseExecutor executor) async {
  return executor.rawInsert(
      'INSERT INTO basic(id,status,is_push,uuid) VALUES("1","FST","0","0123456789")');
}

insertEmotions(Database db) async {
  List<String> queries = [];
  for(int i=0; i<EmotionNames.length; i++) {
    queries.add('INSERT INTO emotion(id,name) VALUES(${(i+1).toString()},${EmotionNames[i]})');
  }
  return db.transaction((txn) async {
    return Future.wait(queries.map((e) async => txn.rawInsert(e)));
  });
}