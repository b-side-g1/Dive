import 'dart:ui';

import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0), // TODO: bottom bar 블러 처리 중...
        child: Container(
            decoration: new BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.55),
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Container(
                height: 50,
                child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    indicatorColor: Colors.transparent,
                    tabs: <Widget>[
                      Tab(
                          icon: Icon(Icons.supervised_user_circle, size: 18),
                          child: Text(
                            '데일리',
                            style: TextStyle(fontSize: 12),
                          )),
                      Tab(
                          icon: Icon(Icons.show_chart, size: 18),
                          child: Text(
                            '통계',
                            style: TextStyle(fontSize: 12),
                          ))
                    ]))));
  }
}
