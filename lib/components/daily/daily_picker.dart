import 'package:Dive/components/daily/calendar_body.dart';
import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:intl/intl.dart';

class DailyPicker extends StatefulWidget {

  DateTime _date;
  Function changeDate;


  DailyPicker(this._date,this.changeDate);

  @override
  _DailyPickerState createState() => _DailyPickerState();
}

class _DailyPickerState extends State<DailyPicker> {
  DateTime _currentDate;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);

    return Container(
      child:  FlatButton(
          onPressed: () => {YYAlertDialogBody(context)},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(Icons.calendar_today),
                margin: EdgeInsets.only(right: 10),
              ),
              Text(
                DateFormat("M.d").format(widget._date),
                style: TextStyle(fontSize: 19),
              ),
              Container(
                child: Image.asset("assets/images/icon_date_arrow.png"),
                margin: EdgeInsets.only(left: 5),
              )
            ],
          )),
    );
  }

  void changeCurrentDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
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
      ..widget(buildDialogBody())
      ..doubleButton(
        padding: EdgeInsets.only(top: 10.0),
        gravity: Gravity.right,
        text1: "취소",
        color1: Colors.deepPurpleAccent,
        fontSize1: 14.0,
        fontWeight1: FontWeight.bold,
        text2: "확인",
        color2: Colors.deepPurpleAccent,
        onTap2: () {
          widget.changeDate(_currentDate);
        },
        fontSize2: 14.0,
        fontWeight2: FontWeight.bold,
      )
      ..show();
  }

  Widget buildDialogBody() {
    return CalendarBody(widget._date,_currentDate, changeCurrentDate);
  }
}