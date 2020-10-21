import 'package:Dive/components/bottom_bar.dart';
import 'package:Dive/pages/daily_page.dart';
import 'package:Dive/pages/statistics_page.dart';
import 'package:flutter/material.dart';

class DiaryTabController extends StatefulWidget {
  @override
  _DiaryTabControllerState createState() => _DiaryTabControllerState();
}

class _DiaryTabControllerState extends State<DiaryTabController> with SingleTickerProviderStateMixin {
  TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Stack(
            children: [
            TabBarView(physics: NeverScrollableScrollPhysics(),
                // 스크롤해서 탭 넘어가는거 막는 설정, 일단 추가해봤어욤
                children: [
                  DailyPage(),
                  StatisticsPage(),
                ]),
              BottomBar()
            ],
          )
//          bottomNavigationBar: BottomBar(),
        ));
  }
}
