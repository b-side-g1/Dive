import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';

showPickerModal(BuildContext context) {
  Picker(
      adapter: PickerDataAdapter<String>(
          pickerdata: JsonDecoder().convert(PickerData),isArray: true),
      changeToFirst: true,
      hideHeader: false,
      selectedTextStyle: TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List value) {
        print(value.toString());
        print(picker.adapter.text);
      }).showModal(context); //_scaffoldKey.currentState);
}