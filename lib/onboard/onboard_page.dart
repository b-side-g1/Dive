import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fadein/flutter_fadein.dart';

//class OnBoardPage extends StatelessWidget {
//class OnBoardPage extends StatefulWidget{
//
//  @override
//  OnBoardState createState() {
//      return OnBoardState();
//  }
//
//}
class OnBoardPage extends StatelessWidget {
  bool showMessage = false;

  @override
  Widget build(BuildContext context) {
//    return Scaffold(body: !_isClosed ? renderTextAnimate() : test());
    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(0),
      child: Scaffold(
          body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                Color.fromRGBO(61, 81, 152, 1),
                Color.fromRGBO(7, 36, 84, 1)
              ])),
          child: WelcomeAnimate(),
        ),
      )),
    );
  }
}

class WelcomeAnimate extends StatefulWidget {
  @override
  WelcomeAnimateState createState() => WelcomeAnimateState();
}

class Welcome {
  final String message;
  final bool isLast;

  Welcome({this.message, this.isLast});
}

class WelcomeAnimateState extends State<WelcomeAnimate> {
  double title_opacity = 0.0;
  double message_opacity = 0.0;
  bool isEnd = false;

  List<Welcome> welcomes = [
    Welcome(message: "안녕하세요!", isLast: false),
    Welcome(message: "당신은 당신이 무엇을할때", isLast: false),
    Welcome(message: "당신을 알아가보세요.", isLast: false),
    Welcome(message: "시간정하기?", isLast: true),
  ];

  Welcome welcome;
  int _messageIndex = 0;

  void initState() {
    super.initState();
//    welcome = welcomes[0];
//    changeMessageOpacity();
    debugPrint("2초 시작!");
    changeMessageOpacity(nextJob: () {
      changeTitleOpacity(nextJob: () {
        Future.delayed(Duration(milliseconds: 3500), () {
          setState(() {
            title_opacity = 0.0;
            message_opacity = 0.0;
          });
        });
      });
    });
  }

  changeTitleOpacity({Function nextJob}) {
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        title_opacity = title_opacity == 0.0 ? 1.0 : 0.0;
        nextJob();
      });
    });
  }

  changeMessageOpacity({Function nextJob}) {
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        message_opacity = message_opacity == 0.0 ? 1.0 : 0.0;
        nextJob();
      });
    });
  }

  changeWelcomeMessage() {
    int i = _messageIndex++ % welcomes.length;
    welcome = welcomes[i];
  }

  Widget stackWidgets() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
              child: AnimatedOpacity(
                  duration: Duration(seconds: 1),
                  opacity: isEnd ? 1.0 : 0.0,
                  child: Text("Hello"))),
        ),
        AnimatedPositioned(
            duration: Duration(seconds: 1),
            top: 0,
            bottom: isEnd ? 300 : 0,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: title_opacity,
              duration: Duration(seconds: 1),
              child: Center(
                  child: Text(
                welcome.message,
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              )),
            )),
      ],
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  final controller = FadeInController();

  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      "Hello",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    );
    Widget message = Text(
      "안녕하세요",
      style: TextStyle(
        fontSize: 20,
        color: hexToColor("#e4faff"),
        fontWeight: FontWeight.bold,
      ),
    );
//    return stackWidgets();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 77),
            child: AnimatedOpacity(
              opacity: title_opacity,
              duration: Duration(milliseconds: 1000),
              child: title,
            ),
          ),
          SizedBox(
            height: 77,
          ),
          AnimatedOpacity(
            opacity: message_opacity,
            duration: Duration(milliseconds: 1000),
            child: message,
          )
        ],
      ),
    );
  }
}
