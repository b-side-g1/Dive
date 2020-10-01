import 'dart:async';
import 'dart:io';

import 'package:Dive/migrations/migration.dart';
import 'package:Dive/migrations/v1_initialization.dart';
import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/models/emotion_model.dart';
import 'package:Dive/models/record_has_emotion.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/daily/daily_service.dart';
import 'package:Dive/services/database/database_helper.dart'
    deferred as databaseHelper;
import 'package:Dive/services/emotion/emotion_service.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

// 통계 테스트
//
// Flutter test(Android studio run configuration)에서 환경변수 설정이 매우 어렵습니다.
// 하다가 포기하고, cli를 이용한 방법을 선택했으니, 설정법을 아시면 알려주시고, 귀찮으시면 아래방법을 이용해 테스트 해주세요.
//
// jq 설치 권장. brew install jq 이후 깔끔하게 보기 가능. 귀찮으면 grep "success"
// - grep, jq 사용예시
// ~/path/to/Dive$ `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine test/services/statistics/statistics_service_test.dart | grep "success" | jq`
Future<void> main() async {
  Map<String, String> env = Platform.environment;
  if (!env.containsKey('TEST_DB_PATH')) {
    throw new ErrorDescription("""
    테스트용 환경 변수 설정(TEST_DB_PATH)을 해주세요.
    
    예시(전체 테스트):
      `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine test/services/statistics/statistics_service_test.dart`
    예시(서비스 생성 테스트):
      `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine --plain-name "서비스 생성 테스트" test/services/statistics/statistics_service_test.dart`
    예시(메소드 호출 테스트):
      `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine --plain-name "메소드 호출 테스트" test/services/statistics/statistics_service_test.dart`
    예시(테스트 데이터 초기화):
      `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine --plain-name "테스트 데이터 초기화" test/services/statistics/statistics_service_test.dart`
    예시(getAverageScoreByMonth 함수 테스트):
      `TEST_DB_PATH='test/test.sqlite3' flutter --no-color test --machine --plain-name "getAverageScoreByMonth 함수 테스트" test/services/statistics/statistics_service_test.dart`
    """);
  } else
    env.forEach((key, value) {
      print(key);
      print(value);
      return;
    });

  // Test DB로 서비스 생성
  await databaseHelper.loadLibrary().then((_) {
    print('Lazy Load Success!');
  });
  Database db = await databaseHelper.DBHelper().database;
  StatisticsService statisticsService = StatisticsService();
  DailyService dailyService = DailyService();
  RecordService recordService = RecordService();
  EmotionService emotionService = EmotionService();

  test('서비스 생성 테스트', () async {
    expect((statisticsService == null), false);
    expect(statisticsService.getHello(), 'Hello');
  });

  test('메소드 호출 테스트', () async {
    expect(statisticsService.getHello(), 'Hello');
  });

  test('테스트 데이터 초기화', () async {
    // DB 초기화
    Migration v1 = V1Initialization();
    await db.transaction((txn) async {
      await v1.down(txn);
      await v1.up(txn);
      return;
    });

    // DB 초기화 확인
    List results = await Future.wait([
      db.rawQuery('select * from ${Record.tableName}'),
      db.rawQuery('select * from ${Daily.tableName}')
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

    // 테스트 데이터 초기화 - Dailies
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

    // 테스트 데이터 초기화 - Records
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

    List<RecordHasEmotion> emotions = [
      RecordHasEmotion(recordId: 'test1', emotionId: '1'),
      RecordHasEmotion(recordId: 'test1', emotionId: '2'),
      RecordHasEmotion(recordId: 'test1', emotionId: '3'),
      RecordHasEmotion(recordId: 'test2', emotionId: '1'),
      RecordHasEmotion(recordId: 'test2', emotionId: '2'),
      RecordHasEmotion(recordId: 'test3', emotionId: '15'),
      RecordHasEmotion(recordId: 'test3', emotionId: '16'),
      RecordHasEmotion(recordId: 'test4', emotionId: '15'),
      RecordHasEmotion(recordId: 'test4', emotionId: '14'),
      RecordHasEmotion(recordId: 'test5', emotionId: '1'),
      RecordHasEmotion(recordId: 'test5', emotionId: '3'),
      RecordHasEmotion(recordId: 'test6', emotionId: '4'),
      RecordHasEmotion(recordId: 'test7', emotionId: '1'),
      RecordHasEmotion(recordId: 'test9', emotionId: '3'),
      RecordHasEmotion(recordId: 'test10', emotionId: '18'),
    ];

    // 테스트 데이터 저장
    var result1 =
        await Future.wait(dailies.map((e) => dailyService.insertDaily(e)));
    var result2 =
        await Future.wait(records.map((e) => recordService.insertRecord(e)));
    var result3 = await Future.wait(
        emotions.map((e) => emotionService.insertRecordHasEmotion(e)));
    expect(result1.length, 7);
    expect(result2.length, 12);
    expect(result3.length, 15);
  });

  // Test DB의 데이터 수정이 있을 경우, 실행 전 데이터 초기화 필요
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
    double avg =
        scores.reduce((value, element) => value + element) / scores.length;
    expect(await statisticsService.getAverageScoreByMonth(1), avg);
  });

  test('getGraphData 함수 테스트', () async {
    List<Map<String, dynamic>> graphData =
        await statisticsService.getGraphData(1);
    expect(graphData[0]['week'], 7);
    expect(graphData[0]['score'], 61.666666666666664);
    expect(graphData[0]['score'].toStringAsFixed(2), '61.67');
    expect(graphData[0]['score'].toStringAsFixed(4), '61.6667');
    expect(graphData[0]['score'].round(), 62);
  });
}
