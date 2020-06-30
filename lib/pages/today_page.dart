import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/InputComponent.dart';
import 'package:flutterapp/components/record_slide.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/models/today_model.dart';
import 'input_page.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TodayPage extends StatefulWidget {
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {
  DateTime _date = DateTime.now();
  int _todayScore = 0;
  Function validator;
  TextInputType keyboardType = TextInputType.number;
  final TextEditingController controller = TextEditingController();

  final int minScore = 0;
  final int maxScore = 100;
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

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2020), // TODO: 기록한 첫번 째 날짜 데이터!
        lastDate: DateTime.now());
    if (picked != null) setState(() => _date = picked);
  }

  Widget _todayContainer(date) {
    return Container(
        child: FlatButton(
            onPressed: _selectDate,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(new DateFormat("M.d").format(date)),
                Icon(Icons.keyboard_arrow_down)
              ],
            )));
  }

  Widget _getScore(score) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(score.toString()),
              FlatButton(
                onPressed: () => {
                  setState((){
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _todayContainer(_date),
          _getScore(_todayScore),
          RecordSlide(recordList: this.recordList),
        ],
      ),
    );
  }
}
