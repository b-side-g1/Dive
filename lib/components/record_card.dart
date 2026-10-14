import 'package:flutter/material.dart';
import 'package:Dive/components/forms/pie_chart.dart';
import 'package:Dive/models/record_model.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  RecordCard({super.key, required this.record});

  final Record record;
  final DateFormat _dateFormat = DateFormat('h:mm');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            color: const Color(0xff2a67d0),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CustomPaint(
                      size: const Size(56, 56),
                      painter: PieChart(
                          percentage: record.score ?? 0,
                          textScaleFactor: 0.8,
                          textColor: const Color(0xff33f7fe),
                          unFilledChartColor: const Color(0xff63c7ff),
                          filledChartColor: const Color(0xff33f7fe))),
                  Expanded(
                    child: Container(
                        margin:
                            const EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            emotionWidget(),
                            tagWidget(),
                            descriptionWidget(),
                            dateWidget(),
                          ],
                        )),
                  ),
                ],
              ),
            )));
  }

  String dateFormat(String dateStr, bool isCreatedSameDay) {
    DateTime datetime = DateTime.parse(dateStr);
    return (!isCreatedSameDay ? "${datetime.month}/${datetime.day} " : "") +
        (datetime.hour >= 12 ? "오후 " : "오전 ") +
        _dateFormat.format(datetime);
  }

  Widget tagWidget() {
    final tags = record.tags ?? const [];
    if (tags.isEmpty) {
      return Container();
    }
    final emotions = record.emotions ?? const [];
    return Container(
      margin: EdgeInsets.only(top: emotions.isNotEmpty ? 10 : 0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(tags.length, (index) {
          return Text("#${tags[index].name} ",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "NotoSans",
                  fontWeight: FontWeight.w700));
        }),
      ),
    );
  }

  Widget emotionWidget() {
    final emotions = record.emotions ?? const [];
    if (emotions.isEmpty) {
      return Container();
    }

    return Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: List.generate(emotions.length, (index) {
          return _textInsideCircleWidget(emotions[index].name ?? '');
        }));
  }

  Widget _textInsideCircleWidget(String text) {
    return ClipRect(
        child: Container(
            height: 27,
            width: text.length * 14.0 + 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Center(
                child: Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "NotoSans",
                  fontWeight: FontWeight.w700),
            ))));
  }

  Widget descriptionWidget() {
    String? description = record.description;
    final emotions = record.emotions ?? const [];
    final tags = record.tags ?? const [];

    return (description == null || description.isEmpty)
        ? const Text("")
        : Container(
            margin: EdgeInsets.only(
                top: emotions.isNotEmpty || tags.isNotEmpty ? 13 : 0),
            child: Text(
              description,
              style: const TextStyle(
                  color: Colors.white, fontSize: 15, fontFamily: "NotoSansKR"),
            ),
          );
  }

  Widget dateWidget() {
    final emotions = record.emotions ?? const [];
    final tags = record.tags ?? const [];
    final desc = record.description ?? '';
    return Container(
        margin: EdgeInsets.only(
            top: (emotions.isNotEmpty || tags.isNotEmpty) && desc.isEmpty
                ? 0
                : 25,
            right: 10),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              record.createdAt == null
                  ? ''
                  : dateFormat(record.createdAt!, record.isCreatedSameDay()),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "NotoSans"),
            )));
  }
}
