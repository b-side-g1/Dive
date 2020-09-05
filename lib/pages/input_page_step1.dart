import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutterapp/services/basic/basic_service.dart';

import 'package:intl/intl.dart';

class InputPageStep1 extends StatefulWidget {
  InputPageStep1({Key key}) : super(key: key);

  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  int hour, min, score;
  String mid, curDate;

  var _scrollController;
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
print("time == ${new DateTime.fromMillisecondsSinceEpoch(1598533200000)}");

    setState(() {
      //TODO : step1 data
      var now = new DateTime.now();
      hour = now.hour > 12 ? now.hour - 12 : now.hour;
      min = now.minute;
      mid = now.hour >= 12 ? "오후" : "오전";
      curDate = "${mid} ${hour}시 ${min}분 ";
    });
  }

  @override
  void dispose() {
    this._scrollController.dispose();
    super.dispose();
  }

  showTimePicker(BuildContext context) async{
    var now = new DateTime.now();
    var minutes = List<int>.generate(60, (int index) => index);
    var timePicker = [];
    BasicService _basicService = BasicService();
    var basicTime= await _basicService.selectBasicData();
    var start = int.parse(basicTime.today_startAt);
    final container = StateContainer.of(context);
    if(start < now.hour){
      for(var i = start ; i<=now.hour;i++)
      {
        timePicker.add(jsonDecode('{"${i}": ${ i == now.hour ? minutes.sublist(0,  now.minute)  : minutes}}'));
      }
    } else if(start > now.hour) {
      for(var i = start ; i<=23;i++)
      {
        timePicker.add(jsonDecode('{"${i}": ${minutes}}'));

      }

      for(var i = 0 ; i<=now.hour;i++)
      {
        timePicker.add(jsonDecode('{"${i}": ${ i == now.hour ? minutes.sublist(0,  now.minute)  : minutes}}'));

      }
    }else{
      timePicker.add(jsonDecode('{"${start}": ${ minutes.sublist(0,  now.minute) }}'));
    }

    var selectedTimeInx = null;

    for(var i in timePicker) {
      var inx = i.keys.toList()[0];
      // 왜 스트링으로 체크해야만 조건 통과하는건지 모르겠음...
      if ('${inx}' == '${now.hour}') {
        selectedTimeInx = timePicker.indexOf(i);
        break;
      }
    }

    new Picker(
        adapter: PickerDataAdapter<String>(pickerdata: timePicker),
        changeToFirst: true,
        hideHeader: false,
        selecteds: [selectedTimeInx, now.minute],
        onConfirm: (Picker picker, List value) {
          var selectedHour = int.parse(timePicker[value[0]].keys.toList()[0]);
          setState(() {
            mid = selectedHour < 12 ? "오전" : "오후";
            hour = selectedHour;
            min = value[1];
            curDate = "${mid} ${hour}시 ${min}분 ";
            score = null;
          });
          DateTime selectedDateTime = new DateTime(now.year, now.month, now.day, hour, min);
          container.updateTime(selectedDateTime.isAfter(now) ? selectedDateTime.subtract(Duration(days: 1)).toString(): selectedDateTime.toString());
        }).showModal(context);
  }

  renderTimeSelect() {
    final width = MediaQuery.of(context).size.width;
    final container = StateContainer.of(context);
    String title = "당신의 기분을 알려주세요.";

    return GestureDetector(
      onTap: () {
        showTimePicker(context);
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(curDate == null ? '' : curDate,
                    style: TextStyle(
                      fontSize: width * 0.07,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontFamily: "NotoSans",
                    )),
                Container(
                  padding: const EdgeInsets.all(0.0),
                  height: 30,
                  width: 30,
                  child: Image.asset(
                    'lib/src/image/daily/icon_arrow.png',
                    height: 60,
                    width: 60,
                  ),
                ),
              ],
            ),
            Text(title,
                style: TextStyle(
                    fontSize: width * 0.07,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "NotoSans"))
          ])),
    );
  }

  renderScoreSelect(StateContainerState container) {
    final width = MediaQuery.of(context).size.width;

    List<int> scoreList = [for (var i = 0; i <= 100; i += 10) i];

    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            width: width * 0.73,
            height: width * 0.73,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/src/image/daily/img_bubble.png'),
              fit: BoxFit.cover,
            )),
            child: Container(
              child: Center(
                child: Container(
                    height: 170,
                    child: new ListWheelScrollView.useDelegate(
                      controller: _scrollController,
                      itemExtent: 60,
                      diameterRatio: 1.5,
                      physics: FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) {
//                        print('${scoreList[i]}___changed value');
                        setState(() {
                          score = scoreList[i];
                          container.updateScore(score);
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
                                fontSize: width * 0.11,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.28,
                              ),
                            )
                        ],
                      ),
                    )),
              ),
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);

    if (container.record != null) {
      DateFormat dateFormat = DateFormat('h:mm');
      DateTime createDate = DateTime.parse(container.record.createdAt);
      setState(() {
        this.curDate =
            "${createDate.month}월 ${createDate.day}일 ${(createDate.hour >= 12 ? "오후 " : "오전 ") + dateFormat.format(createDate)}";
      });
    }
    final height = MediaQuery.of(context).size.height;

    setState(() {
      _scrollController = FixedExtentScrollController(
          initialItem: container.score != null ? container.score ~/ 10 : 5);
    });

    return Container(
      padding: EdgeInsets.only(top: height * 0.23),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              renderTimeSelect(),
              renderScoreSelect(container),
              Container(
                margin: EdgeInsets.only(top: 45),
                height: 35,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/src/image/daily/img_shadow.png'),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
