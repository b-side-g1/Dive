import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';

class TimePickerProvider {
  PickerTime pickerTime;

  // ignore: close_sinks
  StreamController<PickerTime> _pickerController = StreamController.broadcast();
  Stream<PickerTime> get pickerStream => _pickerController.stream;

  PickerTime parsePickerTime(pickerData,value) {
    String ampm = pickerData[0][value[0]];
    int hour = pickerData[1][value[1]];

    return PickerTime(ampm: ampm, hour: hour);
  }

  void changePickerTime(pickerData,value) {
    debugPrint("[time_picker_provider.dart] #changePickerTime !!");
    this.pickerTime = parsePickerTime(pickerData,value);
    _pickerController.sink.add(pickerTime);
  }

  void printPickerTime() {
    debugPrint("[time_picker_provider.dart] #printPickerTime -> ${this.pickerTime.ampm}");
    debugPrint("[time_picker_provider.dart] #printPickerTime -> ${this.pickerTime.hour}");
  }

  void saveEndAt() {

  }



  void dispose() {
    this._pickerController.close();
  }

}