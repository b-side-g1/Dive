import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/record_card.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/pages/setting_page.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/record/record_service.dart';
import 'package:intl/intl.dart';

import 'input_page.dart';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  Basic _basic;
  DateTime _today = DateTime.now();
  DateTime _date = DateTime.now();
  int _dailyScore = 0;
  List<Record> _recordList;
  bool isToday = true;
  bool isEmpty = true;

  BasicService _basicService = BasicService();
  RecordService _recordService = RecordService();
  DailyService _dailyService = DailyService();

  @override
  void dispose() {}

  @override
  void initState() {
    super.initState();
    _setDataByDate(_date);
  }

  void _setDataByDate(DateTime date) async {
    var resDaily = await _dailyService.selectDailyByDate(date);

    var resRecords = resDaily == null
        ? List<Record>()
        : await _recordService
            .selectAllWithEmotionsAndTagsByDailyId(resDaily.id);

    var resDailyScore = resRecords.isEmpty
        ? 0
        : (resRecords.map((c) => c.score).reduce((a, b) => a + b) /
                resRecords.length)
            .round();

    var resIsToday = _today.difference(date).inDays == 0;
    var resIsEmpty = resRecords.length == 0;
    setState(() {
      _recordList = resRecords;
      _dailyScore = resDailyScore;
      isToday = resIsToday;
      isEmpty = resIsEmpty;
    });
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
        lastDate: DateTime.now());
    if (picked != null)
      setState(() {
        _date = picked;
        _setDataByDate(_date);
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
        "지금 이 순간 \n나의 기분을 남겨보세요",
        style: TextStyle(fontSize: 17),
        textAlign: TextAlign.center,
      );
    }
    if (isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
          Text(
            "오늘 하루의 점수",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          )
        ],
      );
    }
    if (!isToday && isEmpty) {
      return Text(
        "이날은 기록했던\n기분이 없네요",
        style: TextStyle(fontSize: 17),
        textAlign: TextAlign.center,
      );
    }
    if (!isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(fontSize: 17),
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
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  ),
                  Text(
                    new DateFormat("M.d").format(date),
                    style: TextStyle(fontSize: 19),
                  ),
                  Icon(Icons.keyboard_arrow_down)
                ],
              )),
          Container(
            margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: _currentStatusContainer(),
          ),
        ],
      ),
    );
  }

  Widget _topNav(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Image.asset(
            'lib/src/image/daily/Topnav_logo.png',
            height: 16,
            fit: BoxFit.fill,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(273, 0, 0, 0),
            child: IconButton(
              icon: Image.asset(
                'lib/src/image/daily/Topnav_icon_setting.png',
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingPage()));
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
        'lib/src/image/daily/img_wave.png',
        height: 160,
      ),
    );
  }

  Widget _createRecordContainer(BuildContext context) {
    if (!isToday && isEmpty) {
      return Image.asset(
        'lib/src/image/daily/icon_empty.png',
        height: 140,
      );
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InputPage()));
      },
      child: Image.asset(
        'lib/src/image/daily/btn_dive.png',
        height: 140,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true, // 스크롤 내릴때 남아 있음
          backgroundColor: Colors.white,
          expandedHeight: 56.0,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.fromLTRB(15, 0, 0, 5),
              title: _topNav(context)),
        ),
        SliverFixedExtentList(
          itemExtent: 121.0,
          delegate: SliverChildListDelegate([
            _dailyContainer(context, _date),
          ]),
        ),
        SliverFixedExtentList(
          itemExtent: 160.0,
          delegate: SliverChildListDelegate([
            _waveContainer(),
          ]),
        ),
        SliverFixedExtentList(
          itemExtent: !isToday && !isEmpty ? 0 : 150.0,
          // TODO: 없애야 되는데 height 0으로 변경한 거;;리팩토링 필수
          delegate: SliverChildListDelegate([
            _createRecordContainer(context),
          ]),
        ),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: RecordCard(
                  record: _recordList[index],
                ),
              );
            },
            childCount: _recordList == null ? 0 : _recordList.length,
          ),
        ),
      ],
    );
  }
}
