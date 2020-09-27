import 'dart:async';
import 'dart:ffi';

import 'package:flutterapp/migrations/migration.dart';
import 'package:flutterapp/migrations/v1_initialization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/record/record_service.dart';
import 'package:flutterapp/services/statistics/statistics_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../config_test.dart';

/// 통계 테스트
/// 테스트 DB 최초 생성 시, 사전에 migration 해주어야 함.
Future<void> main() async {
  /// Test DB로 서비스 생성
//  Future<Database> db = databaseFactoryFfi.openDatabase(TEST_DATABASE_PATH);
  Function getDB = () => databaseFactoryFfi.openDatabase(TEST_DATABASE_PATH);
  Future<Database> db = getDB();
  StatisticsService statisticsService = StatisticsService(getDB);
  DailyService dailyService = DailyService(getDB);
  RecordService recordService = RecordService(getDB);

  test('서비스 생성 테스트', () async {
    expect((statisticsService == null), false);
    expect(statisticsService.getHello(), 'Hello');
  });

  test('메소드 호출 테스트', () async {
    expect(statisticsService.getHello(), 'Hello');
  });

  test('테스트 데이터 초기화', () async {
    /// DB 초기화
    Migration v1 = V1Initialization();
    await (await db).transaction((txn) async {
      await v1.down(txn);
      await v1.up(txn);
    });

    /// DB 초기화 확인
    List results = await Future.wait([
      (await db).rawQuery('select * from ${Record.tableName}'),
      (await db).rawQuery('select * from ${Daily.tableName}')
    ]);
    expect(results[0].length, 0);
    expect(results[1].length, 0);

    Basic basic = Basic(
        id: 'test_basic_id',
        today_startAt: '0',
        today_endAt: '0',
        status: '딱히 안 쓰이는 값 같은데...',
        uuid: '딱히 안 쓰이는 값 같은데2...',
        createdAt: new DateTime(2019, 12, 31));

    int startHour = 0, endHour = 0;

    /// 테스트 데이터 초기화 - Dailies
    List<Daily> dailies = [
      dailyService.createDaily(
          DateTime(2020, 1, 1).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 2).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 3).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 4).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 5).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 6).millisecondsSinceEpoch, startHour, endHour),
      dailyService.createDaily(
          DateTime(2020, 1, 7).millisecondsSinceEpoch, startHour, endHour),
    ];

    /// 테스트 데이터 초기화 - Records
//    int i = 0;
    List<Record> records = [
      Record(
          id: 'test1', score: 100, dailyId: dailies[0].id, description: '새해~!'),
      Record(
          id: 'test2',
          score: 100,
          dailyId: dailies[0].id,
          description: '새해 첫날 끝!'),
      Record(id: 'test3', score: 30, dailyId: dailies[1].id),
      Record(id: 'test4', score: 10, dailyId: dailies[1].id),
      Record(id: 'test5', score: 90, dailyId: dailies[2].id),
      Record(id: 'test6', score: 60, dailyId: dailies[3].id),
      Record(id: 'test7', score: 80, dailyId: dailies[4].id),
      Record(id: 'test8', score: 60, dailyId: dailies[5].id),
      Record(id: 'test9', score: 50, dailyId: dailies[6].id),
      Record(id: 'test10', score: 40, dailyId: dailies[6].id),
      Record(id: 'test11', score: 60, dailyId: dailies[6].id),
      Record(id: 'test12', score: 60, dailyId: dailies[6].id),
    ];
//    List<Record> records = dailies.map((daily) {
//      i++;
//      return Record(
//          id: 'test$i', score: 10, dailyId: daily.id, description: 'test');
//    });

    /// 테스트 데이터 저장
    await (await db).transaction((txn) async {
      List result = [
        await Future.wait(dailies.map((e) => dailyService.insertDaily(e, txn))),
        await Future.wait(
            records.map((e) => recordService.insertRecord(e, txn)))
      ];
      return result;
    }).then((values) {
      expect(values[0].length, 7);
      expect(values[1].length, 12);
    });
  });

  /// Test DB의 데이터 수정이 있을 경우, 실행 전 데이터 초기화 필요
  test('getAverageScoreByMonth 함수 테스트', () async {
    /**
     * 1월 점수 리스트
     *
     * 위 '테스트 데이터 초기화'에서 초기화 시킨 점수만 복붙
     */
    List<int> scores = [
      100,
      100,
      30,
      10,
      90,
      60,
      80,
      60,
      50,
      40,
      60,
      60,
    ];
    double avg = scores.reduce((value, element) => value + element) / scores.length; // 54
    expect(await statisticsService.getAverageScoreByMonth(1), avg);
  });
}
