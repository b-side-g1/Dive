import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMonthPicker extends StatefulWidget {
  final int year;
  final int month;

  CustomMonthPicker({super.key, int? year, int? month})
      : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month;

  @override
  _CustomMonthPickerState createState() => _CustomMonthPickerState();
}

class _CustomMonthPickerState extends State<CustomMonthPicker> {
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.year;
  }

  Widget _monthRectWidget(int month) {
    bool isSelectedMonth =
        widget.year == _selectedYear && widget.month == month;

    bool isOverMonth =
        widget.year == _selectedYear && DateTime.now().month < month;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor:
            isSelectedMonth ? const Color(0xff63c7ff) : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(color: Colors.grey)),
      ),
      onPressed: () {
        if (!isOverMonth) {
          Navigator.of(context).pop({'year': _selectedYear, 'month': month});
        }
      },
      child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Center(
              child: Text(
            "${month}월",
            style: TextStyle(
              fontSize: 15,
              color: isSelectedMonth
                  ? Colors.white
                  : !isOverMonth
                      ? Colors.black
                      : Colors.grey,
            ),
          ))),
    );
  }

  Widget _yearPickerWidget() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _selectedYear = --_selectedYear;
                });
              },
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SvgPicture.asset('assets/images/svg/icon_prev.svg')),
            ),
            Text(_selectedYear.toString()),
            DateTime.now().year == _selectedYear
                ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SvgPicture.asset(
                        'assets/images/svg/icon_next_inactive.svg'))
                : InkWell(
                    onTap: () {
                      setState(() {
                        _selectedYear = ++_selectedYear;
                      });
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: SvgPicture.asset(
                            'assets/images/svg/icon_next.svg')),
                  ),
          ],
        ));
  }

  Widget _monthPickerWidget(double width, double height) {
    return SizedBox(
      width: width * 0.9,
      height: height * 0.33,
      child: Column(
        children: [
          _yearPickerWidget(),
          SizedBox(
              height: height * 0.25,
              child: GridView.count(
                  primary: false,
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 7,
                  childAspectRatio: 2.5,
                  children: List.generate(12, (index) {
                    return _monthRectWidget(index + 1);
                  }))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      title: SizedBox(
          height: 10,
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: SvgPicture.asset('assets/images/svg/btn_x.svg'),
              ))),
      content: _monthPickerWidget(width, height),
    );
  }
}
