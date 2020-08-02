import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_page.dart';
import 'package:flutterapp/controller/diary_tab_controller.dart';

class SplashPage extends StatefulWidget {
  bool initScreen;

  SplashPage(this.initScreen);

  @override
  Splash createState() => Splash(this.initScreen);
}

class Splash extends State<SplashPage> {
  bool initScreen;

  Splash(this.initScreen);

  @override
  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
            initScreen ? DiaryTabController() : OnBoardPage())));
  }

  @override
  Widget build(BuildContext context) {
    AssetImage assetsImage = AssetImage('lib/src/image/splash/splash@3x.png');
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: assetsImage, fit: BoxFit.cover)),
    ));
  }
}
