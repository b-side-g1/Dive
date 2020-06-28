import 'package:flutter/cupertino.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

Widget CustomTimePickerSpinner(onTimeChange) {
  return new TimePickerSpinner(
    onTimeChange: (time) {
      onTimeChange(time);
    },
    is24HourMode: false,
  );
}
