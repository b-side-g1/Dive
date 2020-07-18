import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'dart:convert';
import 'dart:async';
import 'package:numberpicker/numberpicker.dart';

class InputPageStep1 extends StatefulWidget {
  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  int hour, min, score;
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
      score = 50;
    });
    // changeTime();
  }

  // changeTime() {
  //   _timer = new Timer.periodic(
  //     const Duration(seconds: 10),
  //     (Timer timer) => setState(
  //       () {
  //         var now = new DateTime.now();
  //         hour = now.hour > 12 ? now.hour - 12 : now.hour;
  //         min = now.minute;
  //         mid = now.hour >= 12 ? "오후" : "오전";
  //         curDate = "${mid} ${hour}시 ${min}분 ";
  //       },
  //     ),
  //   );
  // }

  showTimePicker(BuildContext context) {
    print("showTimePicker");
    List<String> midArr = ["오전", "오후"];
    List<int> timeArr = [for (var i = 0; i <= 12; i += 1) i];
    List<int> minArr = [for (var i = 0; i < 60; i += 1) i];
    var timePicker = [midArr, timeArr, minArr];

    new Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: timePicker, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        onConfirm: (Picker picker, List value) {
          setState(() {
            mid = value[0] == 0 ? "오전" : "오후";
            hour = value[1];
            min = value[2];
            curDate = "${mid} ${hour}시 ${min}분 ";
            score = null;
          });
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
                  showTimePicker(context);
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
    List<int> scoreList = [for (var i = 0; i <= 100; i += 10) i];

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
                child: new ListWheelScrollView.useDelegate(
                  itemExtent: 60,
                  diameterRatio: 1.5,
                  useMagnifier: true,
                  onSelectedItemChanged: (i) {
                    print('${scoreList[i]}___changed value');
                    setState(() {
                      score = scoreList[i];
                    });
                  },
                  childDelegate: ListWheelChildLoopingListDelegate(
                    children: [
                      for (var i in scoreList)
                        Text(
                          i.toString(),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xffffffff),
                            fontSize: 28,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0.28,
                          ),
                        )
                    ],
                  ),
                ),
              ),
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
