import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';

showPickerModal(BuildContext context) {
  final pickerData = JsonDecoder().convert(PickerData);
  Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata:pickerData ,isArray: true),
      changeToFirst: true,
      hideHeader: false,
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {

        String ampm = pickerData[0][value[0]];
        int hour = pickerData[1][value[1]];



      }).showModal(context); //_scaffoldKey.currentState);
}