import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:Dive/onboard/animate/picker/picker_data.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/provider/time_picker_provider.dart';
import 'package:Dive/services/basic/basic_service.dart';
import 'package:provider/provider.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({super.key});

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimePickerProvider? _timePickerProvider;

  PickerTime pickerTime = PickerTime(hour: '00');
  BasicService basicService = BasicService();

  PickerTime parsePickerTime(List pickerData, List value) {
    String hour = pickerData[0][value[0]] as String;
    return PickerTime(hour: hour);
  }

  void showPickerModal(BuildContext context) {
    final pickerData = const JsonDecoder().convert(PickerData);

    Picker(
        adapter:
            PickerDataAdapter<String>(pickerData: pickerData, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: const TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) async {
          _timePickerProvider?.changePickerTime(pickerData as List, value);
        }).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    _timePickerProvider = Provider.of<TimePickerProvider>(context);

    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
              color: Colors.grey, width: 5, style: BorderStyle.solid),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
        ),
        onPressed: () {
          showPickerModal(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "${Provider.of<PickerTime>(context).hour}시",
              style: TextStyle(
                  fontSize: width * 0.07,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                  fontFamily: "NotoSans"),
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ));
  }
}
