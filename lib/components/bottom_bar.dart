import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Container(
        height: 50,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.supervised_user_circle,
                size: 18
              ),
              child: Text(
                '투데이',
                style: TextStyle(fontSize: 9),
              )
            ),
            Tab(
                icon: Icon(
                    Icons.show_chart,
                    size: 18
                ),
                child: Text(
                  '통계',
                  style: TextStyle(fontSize: 9),
                )
            ),
            Tab(
                icon: Icon(
                    Icons.settings,
                    size: 18
                ),
                child: Text(
                  '설정',
                  style: TextStyle(fontSize: 9),
                )
            )
          ]
        )
      )
    );
  }
}