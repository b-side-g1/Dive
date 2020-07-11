import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';

class PickerTime {
  String ampm;
  int hour;

  PickerTime({this.ampm, this.hour});
}

class TimePickerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TimePickerState();
}

class TimePickerState extends State<TimePickerWidget> {
  final StreamController<PickerTime> _streamController = StreamController();

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  showPickerModal(BuildContext context) {
    final pickerData = JsonDecoder().convert(PickerData);
    Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          String ampm = pickerData[0][value[0]];
          int hour = pickerData[1][value[1]];

          PickerTime pickerTime = PickerTime(ampm: ampm, hour: hour);
          _streamController.sink.add(pickerTime);
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      // 어떤 스트림을 쓸지 정함
      initialData: PickerTime(ampm: "오전", hour: 1),
//      initialData: 0,
      // 초기값 정하기, 스트림에 값이 없을지도 모르니 초기값을 정함.
      builder: (BuildContext context, AsyncSnapshot<PickerTime> snapshot) {
        // UI 만드는 부분.
        return OutlineButton(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${snapshot.data.ampm} ${snapshot.data.hour}시",
//                  "${snapshot.data}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () {
              showPickerModal(context);
            },
            borderSide: BorderSide(
                color: Colors.grey, width: 5, style: BorderStyle.solid),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)));
      },
    );
  }
}
