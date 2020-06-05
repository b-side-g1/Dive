import 'package:flutter/material.dart';

class InputListPage extends StatefulWidget {
  InputListPage({Key key, this.title}) : super(key: key);
  String title;

  @override
  State<StatefulWidget> createState() => _InputListPageState();
}

class _InputListPageState extends State<InputListPage> {
  List<Row> rows = [
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
