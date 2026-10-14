import 'package:Dive/components/daily/calendar_body.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyPicker extends StatefulWidget {
  final DateTime _date;
  final ValueChanged<DateTime> changeDate;

  const DailyPicker(this._date, this.changeDate, {super.key});

  @override
  _DailyPickerState createState() => _DailyPickerState();
}

class _DailyPickerState extends State<DailyPicker> {
  late DateTime _currentDate = widget._date;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(Icons.calendar_today),
            ),
            Text(
              DateFormat("M.d").format(widget._date),
              style: const TextStyle(fontSize: 19),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Image.asset("assets/images/icon_date_arrow.png"),
            )
          ],
        ));
  }

  void changeCurrentDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarBody(widget._date, _currentDate, changeCurrentDate),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text(
                          "취소",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          widget.changeDate(_currentDate);
                          Navigator.of(dialogContext).pop();
                        },
                        child: const Text(
                          "확인",
                          style: TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
