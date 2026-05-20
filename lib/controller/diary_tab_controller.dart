import 'package:Dive/components/bottom_bar.dart';
import 'package:Dive/pages/daily_page.dart';
import 'package:Dive/pages/statistics_page.dart';
import 'package:flutter/material.dart';

class DiaryTabController extends StatefulWidget {
  const DiaryTabController({super.key});

  @override
  _DiaryTabControllerState createState() => _DiaryTabControllerState();
}

class _DiaryTabControllerState extends State<DiaryTabController>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
              TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const DailyPage(),
                    const StatisticsPage(),
                  ]),
              const BottomBar()
            ],
          ),
        ));
  }
}
