import 'package:Dive/components/daily/daily_calendar.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:flutter/material.dart';
import 'package:Dive/services/basic/basic_service.dart';

class CalendarBody extends StatefulWidget {
  final DateTime _currentDate;
  final ValueChanged<DateTime> changeCurrentDate;
  final DateTime _date;

  const CalendarBody(this._date, this._currentDate, this.changeCurrentDate,
      {super.key});

  @override
  _CalendarBodyState createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  String _currentEndAt = "...";
  final BasicService _basicService = BasicService();

  @override
  void initState() {
    super.initState();
    _basicService.selectBasicData().then((basic) {
      setState(() {
        _currentEndAt = basic.today_endAt;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      DailyCalendar(widget._date, widget.changeCurrentDate),
      endAtText(),
    ]);
  }

  Widget endAtText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text("하루 마감시간 $_currentEndAt시",
          style: TextStyle(
              fontFamily: "NotoSans",
              fontSize: 14,
              color: CommonService.hexToColor("#959da6"),
              fontWeight: FontWeight.w700)),
    );
  }
}
