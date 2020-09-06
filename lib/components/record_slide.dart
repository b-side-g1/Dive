import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Dive/components/record_card.dart';
import 'package:Dive/models/record_model.dart';

class RecordSlide extends StatelessWidget {
  RecordSlide({this.recordList});

  final List<Record> recordList;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: ListView(
                scrollDirection: Axis.vertical,
                // 위 아래로 스크롤 가능, default 값이라 없어도 돼요~
                children: makeRecordList(recordList),
              ),
            )
          ],
        ));
  }
}

List<Widget> makeRecordList(List<Record> recordList) {
  List<Widget> resultList = [];
  recordList.forEach((record) {
    resultList.add(InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          print(record.description); // TODO: go to 입력 페이지!
        },
        child: Container(
            padding: EdgeInsets.all(10),
            child: Align(
              child: RecordCard(record: record),
            ))));
  });
  return resultList;
}
//RecordCard(record: record)
