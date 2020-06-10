import 'package:flutter/material.dart';
import 'package:flutterapp/pages/SettingPage.dart';

import '../pages/InputPage.dart';


class DiaryTabController extends StatefulWidget {
  @override
  _DiaryTabControllerState createState() => _DiaryTabControllerState();
}

class _DiaryTabControllerState extends State<DiaryTabController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(
                icon: Icon(Icons.input),
              ),
              Tab(
                icon: Icon(Icons.view_list),
              ),
              Tab(
                icon: Icon(Icons.calendar_today),
              ),
              Tab(
                icon: Icon(Icons.settings),
              ),
            ]),
          ),
          body: TabBarView(children: [
            InputPage(title: "입력 페이지"),
            Text("리스트 페이지"),
            Text("통계 페이지"), 
            SettingPage(title: "설정 페이지")
          ]),
        ));
  }
}
