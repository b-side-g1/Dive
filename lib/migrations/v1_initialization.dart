import 'dart:core';

import 'package:Dive/commons/static.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:sqflite/sqflite.dart';

import 'migration.dart';

_createTables(DatabaseExecutor executor) async {
  final createTableQueries = [
    "CREATE TABLE record (id TEXT PRIMARY KEY, score INTEGER, description TEXT, dailyId TEXT, createdAt TEXT, updatedAt TEXT, createdTimestamp INTEGER)",
    "CREATE TABLE daily (id TEXT PRIMARY KEY, startTimestamp INTEGER, endTimestamp INTEGER, startAt TEXT, endAt TEXT, weekday INTEGER, day INTEGER, week INTEGER, month INTEGER, year INTEGER)",
    "CREATE TABLE tag (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)",
    "CREATE TABLE recordHasTag (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, tagId TEXT, createdAt TEXT)",
    "CREATE TABLE emotion (id TEXT PRIMARY KEY, name TEXT, createdAt TEXT, deletedAt TEXT)",
    "CREATE TABLE recordHasEmotion (idx INTEGER PRIMARY KEY AUTOINCREMENT, recordId TEXT, emotionId TEXT, createdAt TEXT)",
    "CREATE TABLE basic (id TEXT PRIMARY KEY, today_startAt TEXT, today_endAt TEXT, status TEXT, is_push INTEGER, uuid TEXT, createdAt TEXT)",
  ];
  return Future.wait(createTableQueries.map((e) => executor.execute(e)));
}

_dropTables(DatabaseExecutor executor) async {
  final dropTableQueries = [
    "DROP TABLE IF EXISTS basic",
    "DROP TABLE IF EXISTS recordHasEmotion",
    "DROP TABLE IF EXISTS emotion",
    "DROP TABLE IF EXISTS recordHasTag",
    "DROP TABLE IF EXISTS tag",
    "DROP TABLE IF EXISTS daily",
    "DROP TABLE IF EXISTS record",
  ];
  return Future.wait(dropTableQueries.map((e) => executor.execute(e)));
}

_insertTagNames(DatabaseExecutor executor) async {
  String nowDate = DateTime.now().toString();
  return Future.wait(TagNames.map((tag) async {
    String uuid = CommonService.generateUUID();
    return executor.rawInsert(
        'INSERT INTO tag(id,name,createdAt) VALUES(?,?,?)',
        [uuid, tag, nowDate]);
  }));
}

_insertBasic(DatabaseExecutor executor) async {
  return executor.rawInsert(
      'INSERT INTO basic(id,status,is_push,uuid) VALUES("1","FST","0","0123456789")');
}

_insertEmotions(DatabaseExecutor executor) async {
  List<String> queries = [];
  for (int i = 0; i < EmotionNames.length; i++) {
    queries.add(
        'INSERT INTO emotion(id,name) VALUES(${(i + 1).toString()},\'${EmotionNames[i]}\')');
  }
  return Future.wait(queries.map((e) async => executor.rawInsert(e)));
}

class V1Initialization extends Migration {
  int migrationVersion = 1;

  V1Initialization() : super();

  @override
  down(Transaction txn) async {
    await _dropTables(txn);
  }

  @override
  up(Transaction txn) async {
    await _createTables(txn);
    await _insertBasic(txn);
    await _insertTagNames(txn);
    await _insertEmotions(txn);
  }
}
