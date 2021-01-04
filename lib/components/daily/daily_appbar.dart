import 'package:Dive/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:Dive/config/size_config.dart';

class DailyAppbar extends StatelessWidget {

  Widget _topNav(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'assets/images/topnav_logo.png',
            fit: BoxFit.fill,
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Image.asset(
                'assets/images/topnav_icon_setting.png',
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingPage()));
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      // 스크롤 내릴때 남아 있음
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      expandedHeight: SizeConfig.blockSizeVertical * 5,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: EdgeInsets.fromLTRB(15, 0, 0, 5),
          title: _topNav(context)),
    );
  }
}
