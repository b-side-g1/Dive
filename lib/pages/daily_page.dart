import 'dart:async';

import 'package:Dive/components/record_card.dart';
import 'package:Dive/config/size_config.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/models/daily_model.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/pages/setting_page.dart';
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
      existDifferentDayRecord = differentDayIndex > 0 ? true : records.any((element) => !element.isCreatedSameDay());

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

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020),
        lastDate: _currentDate,
        cancelText: "취소",
        confirmText: "확인",
        helpText: "");
    if (picked != null)
      setState(() {
        _date =
            picked.add(Duration(hours: 12)); // 마감시간에 상관 없이 정오는 무조건 동일한 날로 포함됨
        _setDataByDate(_date, false);
      });
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

  Widget _dailyContainer(BuildContext context, date) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              onPressed: () => {_selectDate(context)},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Icon(Icons.calendar_today),
                    margin: EdgeInsets.only(right: 10),
                  ),
                  Text(
                    new DateFormat("M.d").format(date),
                    style: TextStyle(fontSize: 19),
                  ),
                  Container(
                    child: Image.asset("assets/images/icon_date_arrow.png"),
                    margin: EdgeInsets.only(left: 5),
                  )
                ],
              )),
          Container(
            child: _currentStatusContainer(),
          ),
        ],
      ),
    );
  }

  Widget _topNav(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/topnav_logo.png',
            fit: BoxFit.fill,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Image.asset(
                'assets/images/topnav_icon_setting.png',
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _waveContainer() {
    return FittedBox(
      fit: BoxFit.fill, // width 100% 적용!
      child: Image.asset(
        'assets/images/img_wave.png',
        height: 160,
      ),
    );
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

    return Row(
      children: <Widget>[Expanded(
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
      ),]
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: false,
              // 스크롤 내릴때 남아 있음
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              expandedHeight: SizeConfig.blockSizeVertical * 9,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: EdgeInsets.fromLTRB(15, 0, 0, 5),
                  title: _topNav(context)),
            ),
            SliverFixedExtentList(
              itemExtent: SizeConfig.blockSizeVertical * 20,
              delegate: SliverChildListDelegate([
                _dailyContainer(context, _date),
              ]),
            ),
            SliverFixedExtentList(
              itemExtent: SizeConfig.blockSizeVertical * 26,
              delegate: SliverChildListDelegate([
                _waveContainer(),
              ]),
            ),
            SliverFixedExtentList(
//              itemExtent: !isToday && !isEmpty ? 0 : 150.0,
              itemExtent: !isToday && !isEmpty ? 0 : SizeConfig.blockSizeVertical * 24,
              // TODO: 없애야 되는데 height 0으로 변경한 거;;리팩토링 필수
              delegate: SliverChildListDelegate([
                _createRecordContainer(context),
              ]),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final record = _firstRecordList[index];
                  return Dismissible(
                    key: Key(record.id),
                    onDismissed: (direction) {
                      setState(() {
                        _firstRecordList.removeAt(index);
                      });
                      _recordService.deleteRecord(record.id);
                      setScore();
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("기록이 삭제 됐습니다.")));
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
                    DateTime dateTime = DateTime.parse(_firstRecordList[0].createdAt);
                    return _dividerWidget(
                      "${dateTime.month}/${dateTime.day}"
                    );
                  },
                childCount: (_secondRecordList.isNotEmpty || existDifferentDayRecord) && _firstRecordList.length != 0 ? 1 : 0
              ),
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
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("기록이 삭제 됐습니다.")));
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
                _secondRecordList == null ? 0 : _secondRecordList.length,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    DateTime dateTime = DateTime.parse(_secondRecordList[0].createdAt);
                    return _dividerWidget(
                        "${dateTime.month}/${dateTime.day}"
                    );
                  },
                  childCount: _secondRecordList.isNotEmpty && !_secondRecordList[0].isCreatedSameDay() ? 1 : 0
              ),
            ),
          ],
        ));
  }
}
