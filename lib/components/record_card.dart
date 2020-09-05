import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/pie_chart.dart';
import 'package:flutterapp/models/record_model.dart';
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            emotionWidget(),
                            tagWidget(),
                            descriptionWidget(),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: (this.record.emotions.isNotEmpty ||
                                                this.record.tags.isNotEmpty) &&
                                            this.record.description.isEmpty
                                        ? 0
                                        : 25,
                                    right: 10),
                                child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      record.createdAt == null
                                          ? ''
                                          : dateFormat(record.createdAt),
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

  dateFormat(String dateStr) {
    DateFormat dateFormat = DateFormat('h:mm');
    DateTime datetime = DateTime.parse(dateStr);
    return (datetime.hour >= 12 ? "오후 " : "오전 ") + dateFormat.format(datetime);
  }

  tagWidget() {
    if (this.record.tags.isEmpty) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(top: this.record.emotions.isNotEmpty ? 18 : 0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(this.record.tags.length, (index) {
          return Text("#" + this.record.tags[index].name + " ",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "NotoSans",
                  fontWeight: FontWeight.w700));
        }),
      ),
    );
  }

  emotionWidget() {
    if (this.record.emotions.isEmpty) {
      return Container();
    }

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(this.record.emotions.length, (index) {
        return _textInsideCircleWidget(this.record.emotions[index].name);
      }),
    );
  }

  Widget _textInsideCircleWidget(String text) {
    return ClipRect(
        child: Container(
            height: 27,
            width: text.length * 14.0 + 30,
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

  descriptionWidget() {
    String description = this.record.description;
    return (description == null || description.isEmpty)
        ? Container()
        : Expanded(
            child: Padding(
            padding: EdgeInsets.only(
                top: this.record.emotions.isNotEmpty ||
                        this.record.tags.isNotEmpty
                    ? 13
                    : 0),
            child: Text(
              record.description,
              style: TextStyle(
                  color: Colors.white, fontSize: 9, fontFamily: "NotoSansKR"),
            ),
          ));
  }
}
