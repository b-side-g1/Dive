import 'package:Dive/services/daily/daily_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel, EventList;
import 'package:flutter_calendar_carousel/classes/event.dart';

class DailyCalendar extends StatefulWidget {
  final DateTime _date;
  final ValueChanged<DateTime> changeCurrentDate;

  const DailyCalendar(this._date, this.changeCurrentDate, {super.key});

  @override
  _DailyCalendarState createState() => _DailyCalendarState();
}

class _DailyCalendarState extends State<DailyCalendar> {
  late DateTime _currentDate;
  final DailyService _dailyService = DailyService();

  final EventList<Event> _markedDateMap = EventList<Event>(events: {});

  @override
  void initState() {
    super.initState();
    _currentDate = widget._date;

    _dailyService.selectRecordedDaily(_currentDate.year).then((values) {
      setState(() {
        for (final element in values) {
          _markedDateMap.add(
              DateTime(element.year, element.month, element.day),
              createMarkedEvent(element.year, element.month, element.day));
        }
      });
    });
  }

  Event createMarkedEvent(int year, int month, int day) {
    return Event(
        date: DateTime(year, month, day),
        dot: Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.0),
          color: Colors.blue,
          height: 5.0,
          width: 5.0,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.topCenter,
        child: CalendarCarousel<Event>(
            onDayPressed: (DateTime date, List<Event> events) {
              setState(() {
                _currentDate = date;
                widget.changeCurrentDate(_currentDate);
              });
            },
            weekendTextStyle: const TextStyle(color: Colors.red),
            thisMonthDayBorderColor: Colors.grey,
            minSelectedDate: DateTime(2020),
            maxSelectedDate: DateTime.now(),
            weekFormat: false,
            height: 350.0,
            selectedDateTime: _currentDate,
            markedDatesMap: _markedDateMap,
            daysHaveCircularBorder: null));
  }
}
