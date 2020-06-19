import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  ListPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment
              .spaceAround, // 주 방향(여기서는 Row니 가로입니다)으로 어떻게 위젯을 배열할지 정합니다. MainAxisAlignment.spaceAround는 위젯의 간격이 서로 일정하게 벌려주는 걸 말합니다.
          children: <Widget>[
            Text("나의 첫 플러터 앱"),
            Text("이제 앱 개발 해보자"),
            Icon(Icons.videocam, color: Colors.amber),
          ],
        ));
  }
}
