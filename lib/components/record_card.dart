import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/pie_chart.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  RecordCard({this.record});

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getColorByScore(record.score),
      child: Row(
        children: <Widget>[
          CustomPaint(
              size: Size(50, 50),
              painter: PieChart(
                  percentage: record.score,
                  textScaleFactor: 0.5,
                  textColor: Colors.white,
                  unFilledChartColor: getColorByScore(record.score),
                  filledChartColor: Colors.white)),
          Column(
            children: <Widget>[
              emotionList(record.emotions),
              tagList(record.tags),
              Text(record.createdAt, //DateFormat('kk:mm').format(record.createdAt),
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right)
            ],
          )
        ],
      ),
    );
  }
}

Color getColorByScore(int score) {
  if (score <= 20) {
    return Colors.grey;
  }
  if (score <= 50) {
    return Colors.blue;
  }
  if (score < 80) {
    return Colors.blueAccent;
  }
  return Colors.indigoAccent;
}

Widget emotionList(List<Emotion> emotionList) {
  if (emotionList == null) {
    return Text("");
  }
  return Text(emotionList.map((e) => e.name).join('·'));
}

Widget tagList(List<Tag> tagList) {
  if (tagList == null) {
    return Text("");
  }
  return Text(tagList.map((e) => "#" + e.name).join(' '));
}
