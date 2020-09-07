import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/services/basic/basic_service.dart';

class TimePickerProvider {
  PickerTime pickerTime;

  // ignore: close_sinks
  StreamController<PickerTime> _pickerController = StreamController();
  Stream<PickerTime> get pickerStream => _pickerController.stream;

  PickerTime parsePickerTime(pickerData,value) {
    String hour = pickerData[0][value[0]];

    return PickerTime(hour: hour);
  }

  void changePickerTime(pickerData,value) {
    debugPrint("[time_picker_provider.dart] #changePickerTime !!");
    this.pickerTime = parsePickerTime(pickerData,value);
    _pickerController.sink.add(pickerTime);
  }

  void printPickerTime() {
    debugPrint("[time_picker_provider.dart] #printPickerTime -> ${this.pickerTime.hour}");
  }

  void updateEndAt(PickerTime pickerTime) async {
    BasicService basicService = BasicService();
    await basicService.updateTodayAt(pickerTime.hour);
    Basic resultBasic = await basicService.selectBasicData();
    print(resultBasic.toJson());
  }

  void dispose() {
    this._pickerController.close();
  }

}