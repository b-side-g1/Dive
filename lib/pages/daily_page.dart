import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/record_card.dart';
import 'package:flutterapp/models/daily_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/pages/setting_page.dart';
import 'package:flutterapp/services/daily/daily_service.dart';
import 'package:flutterapp/services/emotion/emotion_service.dart';
import 'package:flutterapp/services/record/record_service.dart';
import 'package:flutterapp/services/tag/tag_service.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

import 'input_page.dart';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  DateTime _today = DateTime.now();
  DateTime _date = DateTime.now();
  int _dailyScore = 0;
  Daily _daily;
  List<Record> _recordList;

  RecordService _recordService = RecordService();
  DailyService _dailyService = DailyService();
  EmotionService _emotionService = EmotionService();
  TagService _tagService = TagService();

  @override
  void dispose() {}

  @override
  void initState() {
    super.initState();
    _setData();
  }

  _setData() {
    _setDailyByDate(_date);
//    _setRecordList();
//    _setDailyScore();
  }

  void _setDailyByDate(DateTime date) async {
    // TODO: 원래는 Basic model에서 하루 마감시간으로 갖고 와야 함, 현재는 startAt: 00:00:00, endAt: 23:59:59
//    _daily = await _dailyService.selectDailyByDate(date);
    _daily = Daily(
      id: randomString(20),
      startAt: DateTime(date.year, date.month, date.day, 0, 0, 0).toIso8601String(),
      endAt: DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String(),
      weekday: date.weekday,
      day: date.day,
      week: weekNumber(date),
      month: date.month,
      year: date.year,
    );
    if (_daily == null) {
      _daily = Daily(
        id: randomString(20),
        startAt: DateTime(date.year, date.month, date.day, 0, 0, 0).toIso8601String(),
        endAt: DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String(),
        weekday: date.weekday,
        day: date.day,
        week: weekNumber(date),
        month: date.month,
        year: date.year,
      );
      await _dailyService.insertDaily(_daily);
    }
    _recordList = await _recordService.selectAllByDailyId(_daily.id);
    _recordList.forEach((_record) async {
      _record.emotions = await _emotionService.selectEmotionAllByRecordId(_record.id);
      _record.tags = await _tagService.selectTagAllByRecordId(_record.id);
    });

    _dailyScore = _recordList == null || _recordList.isEmpty
        ? 0 :
        (_recordList.map((c) => c.score).reduce((a, b) => a + b) /
        _recordList.length).round();
  }

  void _setRecordList() async {
    if (_daily == null) return;

    _recordList = await _recordService.selectAllByDailyId(_daily.id);
    _recordList.forEach((_record) async {
      _record.emotions = await _emotionService.selectEmotionAllByRecordId(_record.id);
      _record.tags = await _tagService.selectTagAllByRecordId(_record.id);
    });
  }

  void _setDailyScore() {
    _dailyScore = _recordList != null
        ? (_recordList.map((c) => c.score).reduce((a, b) => a + b) /
            _recordList.length).round()
        : 0;
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
        _setData();
      });
  }

  Widget _currentStatusContainer() {
    bool isToday = _today.difference(_date).inDays == 0;
    bool isEmpty = _recordList == null || _recordList.length == 0;

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
      return Row(
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
      return Row(
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
            'lib/src/image/daily/Topnav_logo@3x.png', // TODO: @3x 이거 뭐죠?
            height: 16,
            fit: BoxFit.fill,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(273, 0, 0, 0),
            child: IconButton(
              icon: Image.asset(
                'lib/src/image/daily/Topnav_icon_setting@3x.png',
                height: 24,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingPage(
                              title: "통계",
                            )));
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
        'lib/src/image/daily/img_wave@3x.png',
        height: 160,
      ),
    );
  }

  Widget _createRecordContainer(BuildContext context) {
    bool isToday = _today.difference(_date).inDays == 0;
    bool isEmpty = _recordList == null || _recordList.length == 0;
    if(!isToday && isEmpty){
      return Image.asset(
        'lib/src/image/daily/icon_empty@3x.png',
        height: 140,
      );
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InputPage()));
      },
      child: Image.asset(
        'lib/src/image/daily/btn_dive@3x.png',
        height: 140,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isToday = _today.difference(_date).inDays == 0;
    bool isEmpty = _recordList == null || _recordList.length == 0;

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
          itemExtent: !isToday && !isEmpty ? 0 : 150.0, // TODO: 없애야 되는데 height 0으로 변경한 거;;리팩토링 필수
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
                  record: this._recordList[index],
                ),
              );
            },
            childCount: this._recordList == null ? 0 : this._recordList.length,
          ),
        ),
      ],
    );
  }
}
