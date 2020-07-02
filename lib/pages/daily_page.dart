import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/InputComponent.dart';
import 'package:flutterapp/components/record_card.dart';
import 'package:flutterapp/components/record_slide.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/models/today_model.dart';
import 'package:flutterapp/pages/setting_page.dart';
import 'package:path/path.dart';
import 'input_page.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class DailyPage extends StatefulWidget {
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  DateTime _date = DateTime.now();
  int _todayScore = 0;
  Function validator;
  TextInputType keyboardType = TextInputType.number;
  final TextEditingController controller = TextEditingController();

  final int minScore = 0;
  final int maxScore = 100;

  @override
  void dispose() {}

  List<Record> recordList = [
    Record(
        id: '1',
        score: 80,
        description: '저녁 밤바람이 시원하고, 일도 다 끝내서 기분이 좋다.',
        today: Today(id: '1', date: DateTime(2020, 06, 27, 14, 28, 0)),
        emotions: [
          Emotion(id: '1', name: '신남'),
          Emotion(id: '2', name: '행복함'),
          Emotion(id: '3', name: '기분좋음'),
          Emotion(id: '4', name: '편안함'),
        ],
        tags: [
          Tag(id: '1', name: '운동'),
          Tag(id: '2', name: '취미'),
          Tag(id: '3', name: '친구'),
        ]),
    Record(
        id: '2',
        score: 20,
        description: '모든게 다 지루하다.',
        today: Today(id: '1', date: DateTime(2020, 06, 27, 13, 2, 0)),
        emotions: [
          Emotion(id: '5', name: '무미건조'),
          Emotion(id: '6', name: '지루함'),
        ]),
  ];

  @override
  void initState() {
    super.initState();
  }

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020), // TODO: 기록한 첫번 째 날짜 데이터!
        lastDate: DateTime.now());
    if (picked != null) setState(() => _date = picked);
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
            child: Text(
                "지금 이 순간 \n나의 기분을 남겨보세요",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScore(BuildContext context, score) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(score.toString()),
              FlatButton(
                onPressed: () => {
                  setState(() {
                    _todayScore = int.parse(controller.value.text);
                  })
                },
                child: Text("edit"),
              ),
              Container(
                width: 100,
                child: InputComponent(
                  title: '오늘 하루 총점',
                  validator: (value) {
                    var i = value == '' ? null : int.parse(value);
                    if (i == null || i < this.minScore || i > this.maxScore) {
                      return '${this.minScore} ~ ${this.maxScore} 사이의 값을 입력해주세요';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: controller,
                ),
              ),
            ],
          ),
          Text("오늘 하루의 점수"),
          RaisedButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputPage()),
              )
            },
            child: Text("버튼"),
          )
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

  Widget _waveContainer(){
    return FittedBox(
      fit: BoxFit.fill, // width 100% 적용!
      child: Image.asset(
        'lib/src/image/daily/img_wave@3x.png',
        height: 160,
      ),
    );
  }
  Widget _createRecordContainer(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => InputPage()));
      },
      child: Image.asset(
        'lib/src/image/daily/btn_dive@3x.png',
        height: 140,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
//    return Container(
//      child: Column(
//        children: <Widget>[
//          _todayContainer(_date),
//          _getScore(_todayScore),
//          RecordSlide(recordList: this.recordList),
//        ],
//      ),
//    );
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
          itemExtent: 150.0,
          delegate: SliverChildListDelegate([
            _createRecordContainer(context),
          ]),
        ),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              print(index);
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: RecordCard(record: this.recordList[index],),
              );
            },
            childCount: this.recordList.length,
          ),
        ),
      ],
    );
  }
}
