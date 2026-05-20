import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:Dive/inherited/state_container.dart';
import 'dart:convert';
import 'package:Dive/services/basic/basic_service.dart';

import 'package:intl/intl.dart';

class InputPageStep1 extends StatefulWidget {
  const InputPageStep1({super.key});

  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  int hour = 0;
  int min = 0;
  int? score;
  String mid = '오전';
  String curDate = '';

  FixedExtentScrollController? _scrollController;

  static const int defaultScore = 50;

  @override
  void initState() {
    super.initState();

    score = defaultScore;
    final now = DateTime.now();
    hour = now.hour > 12 ? now.hour - 12 : now.hour;
    min = now.minute;
    mid = now.hour >= 12 ? "오후" : "오전";
    curDate = "$mid $hour시 $min분 ";
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  Future<void> showTimePickerSheet(BuildContext context) async {
    var now = DateTime.now();
    var minutes = List<int>.generate(60, (int index) => index);
    var timePicker = [];
    BasicService basicService = BasicService();
    var basicTime = await basicService.selectBasicData();
    final startStr = basicTime.today_startAt ?? '0';
    var start = int.parse(startStr);
    final container = StateContainer.of(context);
    if (start < now.hour) {
      for (var i = start; i <= now.hour; i++) {
        timePicker.add(jsonDecode(
            '{"$i": ${i == now.hour ? minutes.sublist(0, now.minute) : minutes}}'));
      }
    } else if (start > now.hour) {
      for (var i = start; i <= 23; i++) {
        timePicker.add(jsonDecode('{"$i": $minutes}'));
      }

      for (var i = 0; i <= now.hour; i++) {
        timePicker.add(jsonDecode(
            '{"$i": ${i == now.hour ? minutes.sublist(0, now.minute) : minutes}}'));
      }
    } else {
      timePicker
          .add(jsonDecode('{"$start": ${minutes.sublist(0, now.minute)}}'));
    }

    int? selectedTimeInx;

    for (var i in timePicker) {
      var inx = i.keys.toList()[0];
      if ('$inx' == '${now.hour}') {
        selectedTimeInx = timePicker.indexOf(i);
        break;
      }
    }

    Picker(
        adapter: PickerDataAdapter<String>(pickerData: timePicker),
        changeToFirst: true,
        hideHeader: false,
        selecteds: [selectedTimeInx ?? 0, now.minute],
        onConfirm: (Picker picker, List value) {
          var selectedHour = int.parse(timePicker[value[0]].keys.toList()[0]);
          setState(() {
            mid = selectedHour < 12 ? "오전" : "오후";
            hour = selectedHour;
            min = value[1];
            curDate = "$mid $hour시 $min분 ";
            score = null;
          });
          DateTime selectedDateTime =
              DateTime(now.year, now.month, now.day, hour, min);
          container.updateTime(selectedDateTime.isAfter(now)
              ? selectedDateTime.subtract(const Duration(days: 1)).toString()
              : selectedDateTime.toString());
        }).showModal(context);
  }

  Widget renderTimeSelect() {
    String title = "당신의 기분을 알려주세요.";

    return GestureDetector(
      onTap: () {
        showTimePickerSheet(context);
      },
      child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(curDate,
                    style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal * 7,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontFamily: "NotoSans",
                    )),
                SizedBox(
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
                    fontSize: SizeConfig.blockSizeHorizontal * 5.8,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w400,
                    fontFamily: "NotoSans"))
          ])),
    );
  }

  Widget renderScoreSelect(StateContainerState container) {
    List<int> scoreList = [for (var i = 0; i <= 100; i += 10) i];

    return Padding(
        padding: const EdgeInsets.only(top: 25),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            width: SizeConfig.blockSizeHorizontal * 73.5,
            height: SizeConfig.blockSizeHorizontal * 73.5,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/src/image/daily/img_bubble.png'),
              fit: BoxFit.cover,
            )),
            child: Center(
              child: SizedBox(
                  height: 170,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 60,
                    diameterRatio: 1.5,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (i) {
                      setState(() {
                        score = scoreList[i];
                        container.updateScore(score!);
                      });
                    },
                    childDelegate: ListWheelChildLoopingListDelegate(
                      children: [
                        for (var i in scoreList)
                          Opacity(
                            opacity: score == i ? 1 : 0.4,
                            child: Text(
                              i.toString(),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: const Color(0xffffffff),
                                fontSize: SizeConfig.blockSizeHorizontal * 11,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.normal,
                                letterSpacing: 0.28,
                              ),
                            ),
                          )
                      ],
                    ),
                  )),
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final container = StateContainer.of(context);

    if (container.record != null && container.record!.createdAt != null) {
      DateFormat dateFormat = DateFormat('h:mm');
      DateTime createDate = DateTime.parse(container.record!.createdAt!);
      curDate =
          "${createDate.month}월 ${createDate.day}일 ${(createDate.hour >= 12 ? "오후 " : "오전 ") + dateFormat.format(createDate)}";
    }

    _scrollController ??= FixedExtentScrollController(
        initialItem: container.score ~/ 10);

    return Container(
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 23),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              renderTimeSelect(),
              renderScoreSelect(container),
              Container(
                margin:
                    EdgeInsets.only(top: SizeConfig.blockSizeVertical * 8),
                height: SizeConfig.blockSizeVertical * 5,
                width: SizeConfig.blockSizeHorizontal * 80,
                decoration: const BoxDecoration(
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
