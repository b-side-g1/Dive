import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'dart:async';

class InputPageStep1 extends StatefulWidget {
  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  int hour, min;
  String mid, curDate;
  Timer _timer;
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    setState(() {
      var now = new DateTime.now();
      hour = now.hour > 12 ? now.hour - 12 : now.hour;
      min = now.minute;
      mid = now.hour >= 12 ? "오후" : "오전";
      curDate = "${mid} ${hour}시 ${min}분 ";
    });
    changeTime();
  }

  changeTime() {
    _timer = new Timer.periodic(
      const Duration(seconds: 10),
      (Timer timer) => setState(
        () {
          var now = new DateTime.now();
          hour = now.hour > 12 ? now.hour - 12 : now.hour;
          min = now.minute;
          mid = now.hour >= 12 ? "오후" : "오전";
          curDate = "${mid} ${hour}시 ${min}분 ";
        },
      ),
    );
  }

  showPickerModal(BuildContext context) {
    print("showPickerModal");
    const PickerData2 = '''
[
    [
      오전,
      오후
    ],
    [
        11,
        22,
        33,
        44
    ],
    [
        "aaa",
        "bbb",
        "ccc"
    ]
]
    ''';
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData2), isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.adapter.text);
        }).showModal(context);
  }

  renderTimeSelect() {
    String title = "당신의 기분을 알려주세요.";
    return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(curDate == null ? '' : curDate,
                  style: TextStyle(
                      fontSize: 21,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
              IconButton(
                icon: Image.asset(
                  'lib/src/image/daily/icon_arrow.png',
                  height: 24,
                ),
                tooltip: 'change date',
                onPressed: () {
                  print("클릭");
                  showPickerModal(context);
                },
              ),
            ],
          ),
          Text(title,
              style: TextStyle(
                  fontSize: 21,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal))
        ]));
  }

  renderScoreSelect() {
    var score = new List<Widget>(10);
    for (var i = 0; i < score.length; i++) {
      var val = i * 10;

      score[i] = Text(
        val.toString(),
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xffffffff),
          fontSize: 28,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.28,
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/src/image/daily/img_bubble.png'),
              fit: BoxFit.cover,
            )),
            child: Container(
              child: Center(
                  child: ListWheelScrollView(
                children: score,
                itemExtent: 60,
                diameterRatio: 1.5,
              )),
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    print('${mid} ${hour}, ${min},  render time ');

    return new Scaffold(
        body: Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(43, 99, 194, 1.0),
      ),
      child: Column(
        children: <Widget>[renderTimeSelect(), renderScoreSelect()],
      ),
    ));
  }
}
