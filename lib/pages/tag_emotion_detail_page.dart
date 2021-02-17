import 'package:Dive/components/date_recordList.dart';
import 'package:Dive/components/forms/pie_chart.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import "package:collection/collection.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagEmotionDetail extends StatefulWidget {
  final String id;
  final String title;
  final String type;
  final int month;
  final int year;

  TagEmotionDetail(
      {Key key,
      this.title,
      @required this.type,
      @required this.id,
      @required this.month,
      @required this.year})
      : super(key: key);

  _TagEmotionDetailState createState() => _TagEmotionDetailState();
}

class _TagEmotionDetailState extends State<TagEmotionDetail> {
  RecordService _recordService = RecordService();
  StatisticsService _statisticsService = StatisticsService();
  Map<int, List<dynamic>> recordMap;
  List<Record> recordList = [];
  int averageScore = 0;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  _setData() async {
    var res = [];
    if (widget.type == 'tag') {
      res = await _recordService.selectAllWithTagId(
          widget.id, widget.month, widget.year);
    } else if (widget.type == 'emotion') {
      res = await _recordService.selectAllWithEmotionId(
          widget.id, widget.month, widget.year);
    }

    var result = groupBy(res, (obj) => DateTime.parse(obj.createdAt).day);
    setState(() {
      recordMap = result;
      averageScore = res.isEmpty
          ? 0
          : (res.map((c) => c.score).reduce((a, b) => a + b) / res.length)
              .round();
      recordList = res;
    });
  }

  _scoreWidget() {
    return Center(
      child: CustomPaint(
          size: Size(56, 56),
          painter: PieChart(
              percentage: averageScore,
              textScaleFactor: 0.8,
              textColor: Color(0xff63c7ff),
              unFilledChartColor: Color(0xff63c7ff),
              filledChartColor: Color(0xff63c7ff))),
    );
  }

  dateRecordWidget() {
    if (recordList.isEmpty || recordMap.isEmpty) {
      return SliverFixedExtentList(
        itemExtent: 0,
        delegate: SliverChildListDelegate([Container()]),
      );
    }

    var keys = recordMap.keys.toList();
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      var key = keys[index];
      return DateRecordList(
          dateStr: widget.month.toString() + '/' + key.toString(),
          recordList: recordMap[key]);
    }, childCount: keys.length));
    /*
    * List.generate(keys.length, (index) {
      var key = keys[index];
      return DateRecordList(
        dateStr: widget.month.toString() + '/' + key.toString(),
        recordList: recordMap[key],
    * */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: CustomScrollView(slivers: <Widget>[
        SliverFixedExtentList(
          itemExtent: 121.0,
          delegate: SliverChildListDelegate([_scoreWidget()]),
        ),
        dateRecordWidget()
      ]),
    );
  }
}
