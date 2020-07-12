import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/provider/time_picker_provider.dart';
import 'package:provider/provider.dart';

class TimePickerWidget extends StatelessWidget {
  showPickerModal(TimePickerProvider timePickerProvider, BuildContext context) {
    final pickerData = JsonDecoder().convert(PickerData);

    Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) {
          timePickerProvider.changePickerTime(pickerData, value);
        }).showModal(context); //_scaffoldKey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    TimePickerProvider timePickerProvider =
        Provider.of<TimePickerProvider>(context);
    PickerTime dataPickerTime = Provider.of<PickerTime>(context);

    return OutlineButton(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${dataPickerTime.ampm} ${dataPickerTime.hour}시",
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
          showPickerModal(timePickerProvider, context);
        },
        borderSide:
            BorderSide(color: Colors.grey, width: 5, style: BorderStyle.solid),
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)));
  }
}
