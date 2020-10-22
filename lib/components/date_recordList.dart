import 'package:Dive/components/record_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateRecordList extends StatefulWidget {
  final String dateStr;
  List<dynamic> recordList;

  DateRecordList({Key key, this.dateStr, this.recordList}) : super(key: key);

  _DateRecordList createState() => _DateRecordList();
}

class _DateRecordList extends State<DateRecordList> {
  Widget _dividerWidget(String dateStr) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 20.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
      Text(dateStr),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Divider(
              color: Colors.black,
              height: 36,
            )),
      ),
    ]);
  }

  Widget _recordList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.recordList.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: RecordCard(
            record: widget.recordList[index],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [_dividerWidget(widget.dateStr), _recordList()]);
  }
}
