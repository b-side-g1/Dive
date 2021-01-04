import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyDate extends StatelessWidget {

  DateTime _date;
  DateTime _currentDate;
  Function selectDateCallBack;
  DailyDate(this._date,this._currentDate,this.selectDateCallBack);

  @override
  Widget build(BuildContext context) {
    return Container(
  child:  FlatButton(
      onPressed: () => {selectDateCallBack(context)},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Icon(Icons.calendar_today),
            margin: EdgeInsets.only(right: 10),
          ),
          Text(
            new DateFormat("M.d").format(_date),
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
}
