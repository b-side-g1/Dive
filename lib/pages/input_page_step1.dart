import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'dart:async';

class InputPageStep1 extends StatefulWidget {
  final int score;

  InputPageStep1({Key key, this.score}) : super(key: key);

  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  int hour, min, score;
  String mid, curDate;

  final _scrollController = FixedExtentScrollController(initialItem: 5);

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
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
    final width = MediaQuery.of(context).size.width;

    String title = "당신의 기분을 알려주세요.";
    return Padding(
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
                child: IconButton(
                  icon: Image.asset(
                    'lib/src/image/daily/icon_arrow.png',
                    height: 60,
                    width: 60,
                  ),
                  tooltip: 'change date',
                  onPressed: () {
                    showTimePicker(context);
                  },
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
        ]));
  }

  renderScoreSelect(StateContainerState container) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
                        print('${scoreList[i]}___changed value');
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

    final height = MediaQuery.of(context).size.height;

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
