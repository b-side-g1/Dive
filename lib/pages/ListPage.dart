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
  // final menus = ['오늘 나의 점수', '그래프'];
// return ListView.separated( itemCount: menus.length, itemBuilder: (context, index) { return ListTile( title: Text(menus[index]), ); }, separatorBuilder: (context, index) { return Divider(); }, );

  return ListView(
    children: ListTile.divideTiles(
      context: context,
      tiles: [
        ListTile(
          title: Text('오늘 나의 점수'),
        ),
        ListTile(
          title: Text('그래프'),
        ),
        ListTile(
          title: Text('캘린더'),
        ),
        ListTile(
          title: Text('통계페이지로 이동'),
        ),
        ListTile(
          title: Text('무드등 켜기'),
        ),
      ],
    ).toList(),
  );
}

// section - today score
// class ListPage extends StatefulWidget {
//   ListPage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _ListPageState createState() => _ListPageState();
// }
