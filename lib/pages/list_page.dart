import 'package:flutter/material.dart';
import 'package:Dive/pages/tag_setting_page.dart';

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
      body: BodyLayout(),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  List<dynamic> todayData = [
    {"date": "2020-01-01", "score": "30"},
    {"date": "2020-01-01", "score": "50"},
    {"date": "2020-01-01", "score": "90"}
  ];
  final TextStyle _biggerFont =
      const TextStyle(fontSize: 18.0, color: Colors.blueGrey);
  double height = 40;
  double width = 200;

  String handleTodayScore(todayData) {
    double score = 0;
    todayData.forEach((element) {
      score += double.parse(element['score']);
    });

    return ((score / todayData.length).round()).toString();
  }

  return Center(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("오늘나의점수", style: _biggerFont),
              ),
              Container(
                child: Center(child: Text(handleTodayScore(todayData))),
                color: Colors.red[100],
                width: width,
                height: height,
              )
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("나의 무드 캘린더", style: _biggerFont),
              ),
              Container(
                child: Center(child: Text("캘린더렌더링")),
                color: Colors.blue[100],
                width: width,
                height: height,
              )
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("나의 무드 그래프", style: _biggerFont),
              ),
              Container(
                child: Center(child: Text("그래프 렌더링")),
                color: Colors.yellow[100],
                width: width,
                height: height,
              )
            ]),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: btn_statistic(context, width, height),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: btn_lamp(width, height),
        ),
      ],
    ),
  );
}

Widget btn_statistic(context, width, height) {
  return ButtonTheme(
      minWidth: width,
      height: height,
      child: RaisedButton(
        child: Text(
          "통계페이지로 이동",
          style: TextStyle(color: Colors.black),
        ),
        color: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TagSettingPage()),
          );
        },
      ));
}

/* button - lamp */
Widget btn_lamp(width, height) {
  return Lamp(width: width, height: height);
}

class Lamp extends StatefulWidget {
  Lamp({Key key, this.width, this.height}) : super(key: key);
  final double width;
  final double height;

  @override
  LampState createState() => LampState();
}

class LampState extends State<Lamp> {
  bool lampOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ButtonTheme(
              minWidth: widget.width,
              height: widget.height,
              child: RaisedButton(
                child: Text(
                  lampOn ? "무드등끄기" : "무드등켜기",
                  style: TextStyle(color: lampOn ? Colors.black : Colors.white),
                ),
                color: lampOn ? Colors.yellow : Colors.black,
                onPressed: () {
                  setState(() {
                    lampOn = !lampOn;
                  });
                },
              )),
          lampOn
              ? Padding(
                  padding: EdgeInsets.all(15),
                  child: Image(image: AssetImage('lib/src/image/idea.png')),
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                  child: Image(image: AssetImage('lib/src/image/idea(1).png')),
                )
        ],
      ),
    );
  }
}
