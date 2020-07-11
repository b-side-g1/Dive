import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';

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

  PickerTime parsePickerTime(pickerData,value) {
    String ampm = pickerData[0][value[0]];
    int hour = pickerData[1][value[1]];

    return PickerTime(ampm: ampm, hour: hour);
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
          /* 선택한 시간을 파싱 */
          PickerTime pickerTime = parsePickerTime(pickerData,value);

          /*위에서 파싱한 모델을 스트림으로 전달 */
          _streamController.sink.add(pickerTime);
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    /* 시간 선택 버튼을 StreamBuilder 위젯으로 감싼다. */
    return StreamBuilder(
      stream: _streamController.stream,
      /* 초기값  */
      initialData: PickerTime(ampm: "오전", hour: 1),
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
