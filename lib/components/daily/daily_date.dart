import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyDate extends StatelessWidget {

  DateTime _date;
  DateTime _currentDate;

  DailyDate(this._date,this._currentDate);

//  Future _selectDate(BuildContext context) async {
//    DateTime picked = await showDatePicker(
//        context: context,
//        initialDate: _date,
//        firstDate: new DateTime(2020),
//        lastDate: _currentDate,
//        cancelText: "취소",
//        confirmText: "확인",
//        helpText: "");
//    if (picked != null)
//      setState(() {
//        _date =
//            picked.add(Duration(hours: 12)); // 마감시간에 상관 없이 정오는 무조건 동일한 날로 포함됨
//        _setDataByDate(_date, false);
//      });
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
  child:  FlatButton(
//      onPressed: () => {_selectDate(context)},
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
