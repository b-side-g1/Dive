import 'package:Dive/components/daily/daily_calendar.dart';
import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';

class DailyPicker extends StatelessWidget  {

  DateTime _date;
  Function changeDate;

  DailyPicker(this._date,this.changeDate);

  @override
  Widget build(BuildContext context) {

    YYDialog.init(context);

    return Container(
        child: makeTextButton("테스트", () {
          YYAlertDialogBody(context);
        }));
  }

  Widget makeTextButton(title, Function() function) {
    return SizedBox(
      width: 70.0,
      height: 35.0,
      child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () {
          function();
        },
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12.0),
        ),
      ),
    );
  }

  YYDialog YYAlertDialogBody(BuildContext context) {

    return YYDialog().build()
      ..width = SizeConfig.screenWidth * 0.8
      ..borderRadius = 4.0
      ..widget(DailyCalendar(this._date,this.changeDate))
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.right,
        text1: "취소",
        color1: Colors.deepPurpleAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        text2: "확인",
        color2: Colors.deepPurpleAccent,
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
      )
      ..show();
  }
}