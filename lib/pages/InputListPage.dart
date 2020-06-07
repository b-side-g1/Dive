import 'package:flutter/material.dart';

class InputListPage extends StatefulWidget {
  InputListPage({Key key, this.title}) : super(key: key);
  String title;

  @override
  State<StatefulWidget> createState() => _InputListPageState();
}

class _InputListPageState extends State<InputListPage> {
  List<Row> rows = [
<<<<<<< HEAD
=======
    /* TODO: 만약 [기획](https://www.notion.so/1-59ce2cbc792445d08d2fe96c3e9b0d6e)의 입력 리스트가 확정되면 이 곳에 일일 데이터 연동
    아래는 개발용 데이터*/

>>>>>>> d8b11bd... Add todo comments
//    Row(children: <Widget>[Text('YYYY-MM-DD'), Text('점수: 1')]),
//    Row(children: <Widget>[Text('YYYY-MM-DD'), Text('점수: 2')]),
//    Row(children: <Widget>[Text('YYYY-MM-DD'), Text('점수: 3')]),
//    Row(children: <Widget>[Text('YYYY-MM-DD'), Text('점수: x')]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Container(padding: const EdgeInsets.all(8),
              //TODO: Canvas()
              height: 320,),
              Column(
                children: rows,
              )
            ],
          ),
        ),
    );
  }
}
