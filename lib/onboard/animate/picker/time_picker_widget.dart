import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/provider/time_picker_provider.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:provider/provider.dart';

class TimePickerWidget extends StatefulWidget {

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  PickerTime pickerTime = PickerTime(ampm: "오전", hour: 1);
  BasicService basicService = BasicService();

  PickerTime parsePickerTime(pickerData, value) {
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
        onConfirm: (Picker picker, List value) async {
          setState(() {
            this.pickerTime = this.parsePickerTime(pickerData, value);
          });
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${this.pickerTime.ampm} ${this.pickerTime.hour}시",
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
        borderSide:
            BorderSide(color: Colors.grey, width: 5, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)));
  }
}
