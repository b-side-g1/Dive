import 'dart:async';

import 'package:Dive/components/record_card.dart';
import 'package:Dive/components/daily/daily_appbar.dart';
import 'package:Dive/components/daily/daily_picker.dart';

import 'package:Dive/config/size_config.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/models/record_model.dart';

import 'package:Dive/services/daily/daily_service.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'input_page.dart';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  DateTime _today = DateTime.now();
  DateTime _date = DateTime.now();
  DateTime _currentDate;
  int _dailyScore = 0;
  List<Record> _firstRecordList = [];
  List<Record> _secondRecordList = [];
  bool isToday = true;
  bool isEmpty = true;
  bool existDifferentDayRecord = false;

  RecordService _recordService = RecordService();
  DailyService _dailyService = DailyService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setDataByDate(_date, true);
  }

  void _setDataByDate(DateTime date, bool createDaily) async {
    var resDaily = await _dailyService.getDailyByTimestamp(
        date.millisecondsSinceEpoch, createDaily);

    var records = List<Record>();
    if (resDaily != null) {
      _setDateByDaily(resDaily);
      records = await _recordService
          .selectAllWithEmotionsAndTagsByDailyId(resDaily.id);
      records.forEach((element) {
        element.daily = resDaily;
      });
    }

    setDataByRecord(records, date);
  }

  void _setDateByDaily(Daily daily) {
    DateTime datetime = DateTime.parse(daily.endAt);
    setState(() {
      _date =
          datetime.hour <= 6 ? datetime.subtract(Duration(days: 1)) : datetime;
      if (_currentDate == null) {
        _currentDate = _date;
      }
    });
  }

  void setDataByRecord(List<Record> records, DateTime date) {
    var resDailyScore = records.isEmpty
        ? 0
        : (records.map((c) => c.score).reduce((a, b) => a + b) / records.length)
            .round();

    var resIsToday =
        _today.difference(date).inDays == 0 && _today.day == date.day;
    var resIsEmpty = records.length == 0;

    int differentDayIndex = getDifferentDayIndex(records);

    setState(() {
      _firstRecordList = differentDayIndex > 0
          ? records.sublist(0, differentDayIndex)
          : records;
      _secondRecordList =
          differentDayIndex > 0 ? records.sublist(differentDayIndex) : [];
      existDifferentDayRecord = differentDayIndex > 0
          ? true
          : records.any((element) => !element.isCreatedSameDay());

      _dailyScore = resDailyScore;
      isToday = resIsToday;
      isEmpty = resIsEmpty;
    });
  }

  void setScore() {
    var records = [..._firstRecordList, ..._secondRecordList];
    var resDailyScore = records.isEmpty
        ? 0
        : (records.map((c) => c.score).reduce((a, b) => a + b) / records.length)
            .round();
    var resIsEmpty = records.length == 0;
    setState(() {
      _dailyScore = resDailyScore;
      isEmpty = resIsEmpty;
    });
  }

  int getDifferentDayIndex(List<Record> records) {
    for (int i = 0; i < records.length - 1; i++) {
      if ((records[i].isCreatedSameDay() &&
              !records[i + 1].isCreatedSameDay()) ||
          (!records[i].isCreatedSameDay() &&
              records[i + 1].isCreatedSameDay())) {
        return i + 1;
      }
    }

    return -1;
  }

  int weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  Widget _currentStatusContainer() {
    /*
    * 1. 오늘 O, 기록 X -> Text(지금 이 순간\n나의 기분을 남겨주세요)
    * 2. 오늘 O, 기록 O -> Text(점수)\n Text(오늘 하루의 점수)
    * 3. 오늘 X, 기록 X -> Text(이날은 기록했던\n기분이 없네요) + 중간 이미지 변경
    * 4. 오늘 X, 기록 O -> Text(점수)\n Text(이날 하루의 점수)
    * */
    if (isToday && isEmpty) {
      return Text(
        "지금 이 순간 \n나의 기분을 남겨보세요.",
        style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
        textAlign: TextAlign.center,
      );
    }
    if (isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(
                fontSize: 34,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Text(
            "오늘 하루의 점수",
            style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
            textAlign: TextAlign.center,
          )
        ],
      );
    }
    if (!isToday && isEmpty) {
      return Text(
        "이날은 기록했던\n기분이 없네요.",
        style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
        textAlign: TextAlign.center,
      );
    }
    if (!isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(
                fontSize: 34,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Text(
            "이날 하루의 점수",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          )
        ],
      );
    }

    return Container();
  }

  void changeDate(DateTime date) {
    setState(() {
      _date = date
          .add(Duration(hours: 12)); // 마감시간에 상관 없이 정오는 무조건 동일한 날로 포함됨
      _setDataByDate(_date, false);
    });
  }

  Widget _dailyContainer(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DailyPicker(_date,changeDate),
          _currentStatusContainer()
        ],
      ),
    );
  }

  Widget _waveContainer() {
    return Container(
        width: SizeConfig.screenWidth,
        height: 160,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/img_wave.png"))));
  }

  Widget _createRecordContainer(BuildContext context) {
    if (!isToday && isEmpty) {
      return Image.asset(
        'assets/images/icon_empty.png',
        height: 140,
      );
    }
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StateContainer(child: InputPage())));
      },
      child: Image.asset(
        'assets/images/btn_dive.png',
        height: 140,
      ),
    );
  }

  Widget _dividerWidget(String dateStr) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
      Text(dateStr),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: CustomScrollView(
              slivers: <Widget>[
                /* 맨 위 상테바 (Dive 로고, 환경설정 버튼) */
                DailyAppbar(),
                SliverFixedExtentList(
                  itemExtent: 300,
                  delegate: SliverChildListDelegate([
                    Column(
                      children: [
                        /* 달력 및 안내 문구 */
                        _dailyContainer(context),
                        Stack(
                          children: [
                            /* 물결 (Wave) 이미지 */
                            _waveContainer(),
                            /* 감정 등록 버튼 */
                            Positioned.fill(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: _createRecordContainer(context))),
                          ],
                        )
                      ],
                    )
                  ]),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final record = _firstRecordList[index];
                      return Dismissible(
                        key: Key(record.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.transparent,
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 45),
                              child: Container(
                                width: 60,
                                height: 60,
                                child: Transform.scale(
                                  scale: 0.5,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: new Image.asset(
                                        "lib/src/image/daily/icon_trash_ori.png"),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.red),
                              )),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                content: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: const Text(
                                      "감정을 삭제하면 되돌릴 수 없습니다.\n정말 삭제하실 건가요?",
                                      style:
                                          TextStyle(height: 1.5, fontSize: 15),
                                    )),
                                actions: <Widget>[
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: Text("삭제하기"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                  CupertinoDialogAction(
                                    child: Text("취소"),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  )
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (direction) {
                          setState(() {
                            _firstRecordList.removeAt(index);
                          });
                          _recordService.deleteRecord(record.id);
                          setScore();
                        },
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: RecordCard(
                              record: record,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StateContainer(
                                        child: InputPage(),
                                        score: record.score,
                                        emotions: record.emotions,
                                        tags: record.tags,
                                        description: record.description,
                                        record: record)));
                          },
                        ),
                        // swipe 시 옆으로 삭제 되는 기능
//                    background: Container(
//                      color: Colors.red,
//                      child: Icon(Icons.cancel)
//                    ),
                      );
                    },
                    childCount:
                        _firstRecordList == null ? 0 : _firstRecordList.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    DateTime dateTime =
                        DateTime.parse(_firstRecordList[0].createdAt);
                    return _dividerWidget("${dateTime.month}/${dateTime.day}");
                  },
                      childCount: (_secondRecordList.isNotEmpty ||
                                  existDifferentDayRecord) &&
                              _firstRecordList.length != 0
                          ? 1
                          : 0),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final record = _secondRecordList[index];
                      return Dismissible(
                        key: Key(record.id),
                        onDismissed: (direction) {
                          setState(() {
                            _secondRecordList.removeAt(index);
                          });
                          _recordService.deleteRecord(record.id);
                          setScore();
                        },
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: RecordCard(
                              record: record,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StateContainer(
                                        child: InputPage(),
                                        score: record.score,
                                        emotions: record.emotions,
                                        tags: record.tags,
                                        description: record.description,
                                        record: record)));
                          },
                        ),
                        // swipe 시 옆으로 삭제 되는 기능
//                    background: Container(
//                      color: Colors.red,
//                      child: Icon(Icons.cancel)
//                    ),
                      );
                    },
                    childCount: _secondRecordList == null
                        ? 0
                        : _secondRecordList.length,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    DateTime dateTime =
                        DateTime.parse(_secondRecordList[0].createdAt);
                    return _dividerWidget("${dateTime.month}/${dateTime.day}");
                  },
                      childCount: _secondRecordList.isNotEmpty &&
                              !_secondRecordList[0].isCreatedSameDay()
                          ? 1
                          : 0),
                ),
              ],
            )));
  }
}
