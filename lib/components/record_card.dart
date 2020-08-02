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
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Color(0xff2a67d0),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: CustomPaint(
                      size: Size(56, 56),
                      painter: PieChart(
                          percentage: record.score,
                          textScaleFactor: 0.8,
                          textColor: Color(0xff33f7fe),
                          unFilledChartColor: Color(0xff63c7ff),
                          filledChartColor: Color(0xff33f7fe))),
                ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 10),
                        child: Column(
                          children: <Widget>[
                            Container( // TODO: ...
                              height: this.record.emotions == null || this.record.emotions.isEmpty ? 0 : 130,
                              child: GridView.count(
                                crossAxisCount: 3,
                                shrinkWrap: true,
                                crossAxisSpacing: 25,
                                mainAxisSpacing: 12,
                                childAspectRatio: MediaQuery
                                    .of(context)
                                    .size
                                    .width /
                                    (MediaQuery
                                        .of(context)
                                        .size
                                        .height / 3),
                                children: List.generate(
                                    this.record.emotions.length, (index) {
                                  return _textInsideCircleWidget(
                                      this.record.emotions[index].name);
                                }),
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: this.record.emotions.isNotEmpty
                                        ? 13
                                        : 0),
                                child:
                                Container( // TODO: ...
                                  height: this.record.tags.isNotEmpty
                                      ? 130
                                      : 0,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    shrinkWrap: true,
                                    crossAxisSpacing: 25,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: MediaQuery
                                        .of(context)
                                        .size
                                        .width /
                                        (MediaQuery
                                            .of(context)
                                            .size
                                            .height / 3),
                                    children: List.generate(
                                        this.record.tags.length, (index) {
                                      return _textWithHashTagWidget(
                                          this.record.tags[index].name);
                                    }),
                                  ),
                                ),
                            ),
                            Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: this.record.emotions.isNotEmpty ||
                                          this.record.tags.isNotEmpty
                                          ? 13
                                          : 0),
                                  child: Text(
                                    record.description,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: "NotoSansKR"),
                                  ),
                                )),
                            Padding(
                                padding: EdgeInsets.only(top: 25, right: 10),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      record.createdAt == null
                                          ? ''
                                          : record.createdAt,
                                      //DateFormat('kk:mm').format(record.createdAt),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontFamily: "NotoSans"),
                                    ))),
                          ],
                        ))),
              ],
            ),
          ),
        ));
  }
}

Widget _textInsideCircleWidget(String text) {
  return ClipRect(
      child: Container(
          height: 27,
          width: text.length * 13.0 + 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1.5),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0)),
          ),
          // this line makes the coffee.
          child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "NotoSans",
                    fontWeight: FontWeight.w700),
              ))));
}

_textWithHashTagWidget(String text) {
  return Text("#" + text,
      style: TextStyle(
          color: Colors.white,
          fontFamily: "NotoSans",
          fontWeight: FontWeight.w700));
}
