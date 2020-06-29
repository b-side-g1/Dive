import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_service.dart';
import 'package:provider/provider.dart';

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
          body: Container(
        child: Center(
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
  double opacity = 0.0;
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
    welcome = welcomes[0];
    changeOpacity();
  }

  changeOpacity() {
    Future.delayed(Duration(milliseconds: 1500), () {
      setState(() {
        /* 글자가 사라질때 */
        if (opacity == 0.0) {
          changeWelcomeMessage();
        } else {
          if (welcome.isLast) {
            isEnd = true;
            return debugPrint("끝!");
          }
        }
        opacity = opacity == 0.0 ? 1.0 : 0.0;
        changeOpacity();
      });
    });
  }

  changeWelcomeMessage() {
    int i = _messageIndex++ % welcomes.length;
    welcome = welcomes[i];
  }

  @override
  Widget build(BuildContext context) {
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
              opacity: opacity,
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
}
