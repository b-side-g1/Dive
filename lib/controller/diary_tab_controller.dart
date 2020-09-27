import 'package:flutter/material.dart';
import 'package:Dive/components/bottom_bar.dart';
import 'package:Dive/pages/daily_page.dart';
import 'package:Dive/pages/list_page.dart';

class DiaryTabController extends StatefulWidget {
  @override
  _DiaryTabControllerState createState() => _DiaryTabControllerState();
}

class _DiaryTabControllerState extends State<DiaryTabController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DailyPage(),
    );
    /* TODO: 통계 페이지 나오기 전까지 보류
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(), // 스크롤해서 탭 넘어가는거 막는 설정, 일단 추가해봤어욤
              children: [
            DailyPage(),
            ListPage(title: "리스트 페이지"),
          ]),
          bottomNavigationBar: BottomBar(),
        ));
     */
  }
}
