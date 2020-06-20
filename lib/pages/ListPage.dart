import 'package:flutter/material.dart';
import 'package:flutterapp/pages/TagSettingPage.dart';

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

  final TextStyle menuFont = const TextStyle(fontSize: 18.0);
  final button1 =
      new RaisedButton(child: new Text("Button1"), onPressed: () {});

  // Widget _buildMenu() {
  //   return ListView.builder(
  //       padding: const EdgeInsets.all(16.0),
  //       itemBuilder: (BuildContext context, int index) {
  //         // if (index.isOdd) return Divider();
  //         // final index = index ~/ 2;

  //     // return Container(width: 200, height: 200, margin: EdgeInsets.only(bottom: 10), color: Colors.red);
  //       });
  // }

  // Widget _menuItem() {
  //   print(pair);
  //   return ListTile(
  //     title: Text(
  //       pair.asPascalCase,
  //       style: menuFont,
  //     ),
  //     trailing: Icon(isAlreadySaved ? Icons.favorite : Icons.favorite_border,
  //         color: isAlreadySaved ? Colors.red : null),
  //   );
  // }

}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {
  final todayData = [
    {"date": "2020-01-01", "score": "30"},
    {"date": "2020-01-01", "score": "50"},
    {"date": "2020-01-01", "score": "70"}
  ];
  void handleTodayScore(todayData) {
    print(todayData);
    //   (json['sets'] as List).map((i) {
    //   return Set.fromJson(i);
    // }).toList()
    // return
  }

  handleTodayScore(todayData);
  print("hi");
  // return ListView(
  //   children: ListTile.divideTiles(
  //     context: context,
  //     tiles: [
  //       ListTile(
  //         title: Text('오늘 나의 점수'),
  //       ),
  //       ListTile(
  //         title: Text('그래프'),
  //       ),
  //       ListTile(
  //         title: Text('캘린더'),
  //       ),
  //       btn_statistic(context),
  //       btn_lamp()
  //     ],
  //   ).toList(),
  // );

  return Center(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: btn_statistic(context),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: btn_lamp(),
        ),
      ],
    ),
  );
}

Widget btn_statistic(context) {
  return ButtonTheme(
      minWidth: 200.0,
      height: 50.0,
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
Widget btn_lamp() {
  return Lamp();
}

class Lamp extends StatefulWidget {
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
              minWidth: 200.0,
              height: 50.0,
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

// section - today score
// class ListPage extends StatefulWidget {
//   ListPage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _ListPageState createState() => _ListPageState();
// }
