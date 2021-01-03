import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';

class DailyCalendar extends StatefulWidget {

  DateTime _date;
  Function changeDate;


  DailyCalendar(this._date,this.changeDate);

  @override
  _DailyCalendarState createState() => _DailyCalendarState();
}

class _DailyCalendarState extends State<DailyCalendar> {

  DateTime _currentDate;

  @override
  void initState() {
    _currentDate = widget._date;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.all(16.0),
        alignment: Alignment.topCenter,
        child: CalendarCarousel(
            onDayPressed: (DateTime date,List<Event> events) {
              setState(() {
                widget.changeDate(date);
                _currentDate = date;
              });
            },
            weekendTextStyle: TextStyle(
              color: Colors.red,
            ),
            thisMonthDayBorderColor: Colors.grey,
            minSelectedDate: new DateTime(2020),
            maxSelectedDate: DateTime.now(),
            weekFormat: false,
            height: 420.0,
            selectedDateTime: _currentDate,
            daysHaveCircularBorder: null));
  }
}
