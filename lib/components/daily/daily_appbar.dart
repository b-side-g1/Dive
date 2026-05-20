import 'package:Dive/pages/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Dive/config/size_config.dart';

class DailyAppbar extends StatelessWidget {
  const DailyAppbar({super.key});

  Widget _topNav(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Image.asset(
          'assets/images/topnav_logo.png',
          fit: BoxFit.fill,
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: IconButton(
            icon: Image.asset('assets/images/topnav_icon_setting.png'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingPage()));
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      expandedHeight: SizeConfig.blockSizeVertical * 5,
      flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          titlePadding: const EdgeInsets.fromLTRB(15, 0, 0, 5),
          title: _topNav(context)),
    );
  }
}
