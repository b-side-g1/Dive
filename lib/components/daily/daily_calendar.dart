import 'package:Dive/services/daily/daily_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:flutter_calendar_carousel/classes/event.dart';

class DailyCalendar extends StatefulWidget {
  DateTime _date;
  Function changeCurrentDate;

  DailyCalendar(this._date, this.changeCurrentDate);

  @override
  _DailyCalendarState createState() => _DailyCalendarState();
}

class _DailyCalendarState extends State<DailyCalendar> {
  DateTime _currentDate;
  DailyService _dailyService = DailyService();

  EventList<Event> _markedDateMap = EventList<Event>();

  @override
  void initState() {
    _currentDate = widget._date;

    /* 2021년에 record가 있는 날짜들을 검색 */
    _dailyService.selectRecordedDaily(2021).then((values) {
      debugPrint("$values");
      setState(() {
        values.forEach((element) {
          _markedDateMap.add(
              DateTime(element.year, element.month, element.day),
              createMarkedEvent(element.year, element.month, element.day));
        });
      });
    });
  }

  Event createMarkedEvent(year, month, day) {
    return Event(
        date: new DateTime(year, month, day),
        dot: Container(
          margin: EdgeInsets.symmetric(horizontal: 1.0),
          color: Colors.blue,
          height: 5.0,
          width: 5.0,
        ));
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
            onDayPressed: (DateTime date, List<Event> events) {
              setState(() {
                _currentDate = date;
                widget.changeCurrentDate(_currentDate);
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
            markedDatesMap: _markedDateMap,
            daysHaveCircularBorder: null));
  }
}
