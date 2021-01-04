import 'package:Dive/components/daily/daily_calendar.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:flutter/material.dart';
import 'package:Dive/services/basic/basic_service.dart';

class CalendarBody extends StatefulWidget {

  DateTime _currentDate;
  Function changeCurrentDate;
  DateTime _date;

  CalendarBody(this._date,this._currentDate,this.changeCurrentDate);

  @override
  _CalendarBodyState createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  String _currentEndAt = "...";
  BasicService _basicService = BasicService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        DailyCalendar(widget._date,widget.changeCurrentDate),
        endAtText(),
      ])
    );
  }

  @override
  void initState() {
    _basicService.selectBasicData().then((basic) {
      setState(() {
        _currentEndAt = basic.today_endAt;
      });
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  Widget endAtText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text("하루 마감시간 $_currentEndAt시",
        style: TextStyle(
          fontFamily: "NotoSans",
          fontSize: 14,
          color: CommonService.hexToColor("#959da6"),
          fontWeight: FontWeight.w700
        )),
    );
  }
}
