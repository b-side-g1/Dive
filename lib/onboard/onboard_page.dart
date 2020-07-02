import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter/animation.dart';

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
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
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

class WelcomeAnimateState extends State<WelcomeAnimate>
    with TickerProviderStateMixin {
  double title_opacity = 0.0;
  double message_opacity = 0.0;

  Widget title_widget;
  Widget message_widget;

  bool isEnd = false;

  List<Welcome> welcomes = [
    Welcome(message: "안녕하세요!", isLast: false),
    Welcome(message: "당신은 당신이 무엇을할때", isLast: false),
    Welcome(message: "당신을 알아가보세요.", isLast: false),
    Welcome(message: "시간정하기?", isLast: true),
  ];

  Welcome welcome;
  int _messageIndex = 0;

  AnimationController titleController;
  AnimationController messageController;
  Animation<double> titleAnimation;
  Animation<double> messageAnimation;

  void initState() {
    super.initState();

    titleController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    messageController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    titleAnimation = CurvedAnimation(parent: titleController, curve: Curves.fastOutSlowIn);
    messageAnimation = CurvedAnimation(parent: messageController, curve: Curves.fastOutSlowIn);

    titleAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {

        titleController.reverse();
        messageController.reverse();
      }
    });

    messageAnimation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        titleController.forward();
      }
    });

//    runAnimation();
  }

  void runAnimation() {
    step1(runNextStep: () {
      step2(runNextStep: () {
        debugPrint("Step3들어갈차례");
      });
    });
  }

  void step1({Function runNextStep}) {
    title_widget = Text(
      "Hello",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    );

    message_widget = Text(
      "안녕하세요",
      style: TextStyle(
        fontSize: 20,
        color: hexToColor("#e4faff"),
        fontWeight: FontWeight.bold,
      ),
    );

    changeMessageOpacity(nextJob: () {
      changeTitleOpacity(nextJob: () {
        Future.delayed(Duration(milliseconds: 3500), () {
          setState(() {
            title_opacity = 0.0;
            message_opacity = 0.0;

            runNextStep();
          });
        });
      });
    });
  }

  void step2({Function runNextStep}) {
    title_widget = Text(
      "아이콘",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    );

    message_widget = Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Text(
        "당신은 당신이 무엇을 할때 기쁨을 느끼고, 슬픔을 느끼는지 잘 알고 있나요?",
        style: TextStyle(
          fontSize: 20,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    changeMessageOpacity(nextJob: () {
      changeTitleOpacity(nextJob: () {
        Future.delayed(Duration(milliseconds: 3500), () {
          setState(() {
            title_opacity = 0.0;
            message_opacity = 0.0;
            runNextStep();
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

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    title_widget = Text(
      "Hello",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    );

    message_widget = Text(
      "안녕하세요",
      style: TextStyle(
        fontSize: 20,
        color: hexToColor("#e4faff"),
        fontWeight: FontWeight.bold,
      ),
    );


    messageController.forward();
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 77),
            child: FadeTransition(
              opacity: titleAnimation,
              child: title_widget,
            ),
          ),
          SizedBox(
            height: 77,
          ),
          FadeTransition(
            opacity: messageAnimation,
            child: message_widget,
          )
        ],
      ),
    );
  }
}
