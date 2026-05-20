import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/services/basic/basic_service.dart';

class TimePickerProvider {
  PickerTime? pickerTime;

  // ignore: close_sinks
  final StreamController<PickerTime> _pickerController =
      StreamController<PickerTime>.broadcast();
  Stream<PickerTime> get pickerStream => _pickerController.stream;

  PickerTime parsePickerTime(List pickerData, List value) {
    String hour = pickerData[0][value[0]] as String;
    return PickerTime(hour: hour);
  }

  void changePickerTime(List pickerData, List value) {
    debugPrint("[time_picker_provider.dart] #changePickerTime !!");
    pickerTime = parsePickerTime(pickerData, value);
    _pickerController.sink.add(pickerTime!);
  }

  void printPickerTime() {
    debugPrint(
        "[time_picker_provider.dart] #printPickerTime -> ${pickerTime?.hour}");
  }

  void updateEndAt(PickerTime pickerTime) async {
    BasicService basicService = BasicService();
    if (pickerTime.hour == null) return;
    await basicService.updateTodayAt(pickerTime.hour!);
    Basic resultBasic = await basicService.selectBasicData();
    print(resultBasic.toJson());
  }

  void dispose() {
    _pickerController.close();
  }
}
