import 'package:Dive/components/date_recordList.dart';
import 'package:Dive/components/forms/pie_chart.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/record/record_service.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';

class TagEmotionDetail extends StatefulWidget {
  final String id;
  final String title;
  final String type;
  final int month;
  final int year;

  const TagEmotionDetail({
    super.key,
    this.title = '',
    required this.type,
    required this.id,
    required this.month,
    required this.year,
  });

  @override
  _TagEmotionDetailState createState() => _TagEmotionDetailState();
}

class _TagEmotionDetailState extends State<TagEmotionDetail> {
  final RecordService _recordService = RecordService();
  Map<int, List<Record>> recordMap = {};
  List<Record> recordList = [];
  int averageScore = 0;

  @override
  void initState() {
    super.initState();
    _setData();
  }

  Future<void> _setData() async {
    List<Record> res = [];
    if (widget.type == 'tag') {
      res = await _recordService.selectAllWithTagId(
          widget.id, widget.month, widget.year);
    } else if (widget.type == 'emotion') {
      res = await _recordService.selectAllWithEmotionId(
          widget.id, widget.month, widget.year);
    }

    final result =
        groupBy<Record, int>(res, (r) => DateTime.parse(r.createdAt!).day);
    setState(() {
      recordMap = result;
      averageScore = res.isEmpty
          ? 0
          : (res.map((c) => c.score ?? 0).reduce((a, b) => a + b) / res.length)
              .round();
      recordList = res;
    });
  }

  Widget _scoreWidget() {
    return Center(
      child: CustomPaint(
          size: const Size(56, 56),
          painter: PieChart(
              percentage: averageScore,
              textScaleFactor: 0.8,
              textColor: const Color(0xff63c7ff),
              unFilledChartColor: const Color(0xff63c7ff),
              filledChartColor: const Color(0xff63c7ff))),
    );
  }

  Widget dateRecordWidget() {
    if (recordList.isEmpty || recordMap.isEmpty) {
      return SliverFixedExtentList(
        itemExtent: 0,
        delegate: SliverChildListDelegate([Container()]),
      );
    }

    var keys = recordMap.keys.toList();
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
      var key = keys[index];
      return DateRecordList(
          dateStr: "${widget.month}/$key",
          recordList: recordMap[key] ?? const []);
    }, childCount: keys.length));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
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
