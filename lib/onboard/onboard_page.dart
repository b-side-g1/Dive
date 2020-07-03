import 'package:flutter/material.dart';
import 'package:flutterapp/onboard/onboard_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/animation.dart';

class OnBoardPage extends StatelessWidget {
  gradientBackground() {
    return LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color.fromRGBO(61, 81, 152, 1), Color.fromRGBO(7, 36, 84, 1)]);
  }

  buildBackground() {
    return BoxDecoration(
      gradient: gradientBackground(),
    );
  }

  _topLightImage() {
    return Container(
      alignment: Alignment.topCenter,
      child: Image.asset('lib/src/image/onboarding/2.0x/light@2x.png'),
    );
  }

  _bottomWaveImage() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset('lib/src/image/onboarding/2.0x/wave@2x.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Counter>(
      create: (_) => Counter(0),
      child: Scaffold(
          body: Center(
        child: Container(
            decoration: buildBackground(),
            child: Stack(
              children: <Widget>[
                _topLightImage(),
                WelcomeAnimate(),
                _bottomWaveImage()
              ],
            )),
      )),
    );
  }
}

class WelcomeAnimate extends StatefulWidget {
  @override
  WelcomeAnimateState createState() => WelcomeAnimateState();
}

class WelcomeAnimateState extends State<WelcomeAnimate>
    with TickerProviderStateMixin {
  Widget title_widget;
  Widget message_widget;

  AnimationController titleController;
  AnimationController messageController;
  Animation<double> titleAnimation;
  Animation<double> messageAnimation;

  int animateStep = 4;
  double contentMargin = 0;

  void initState() {
    super.initState();

    titleController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    messageController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    titleAnimation =
        CurvedAnimation(parent: titleController, curve: Curves.fastOutSlowIn);
    messageAnimation =
        CurvedAnimation(parent: messageController, curve: Curves.fastOutSlowIn);

    titleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint("titleAnimation !");
        Future.delayed(const Duration(milliseconds: 1000), () {
          titleController.reverse();
          messageController.reverse();
        });
      }
    });

    messageAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        debugPrint("messag 끝");
        titleController.forward();
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          animateStep++;
        });
      }
    });
  }

  @override
  void dispose() {
    debugPrint("dispose!");
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget buildStep1() {
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

  Widget buildStep2() {
    title_widget = Image.asset('lib/src/image/onboarding/contents_img_02.png');
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
            height: 20.0,
          ),
          FadeTransition(
            opacity: messageAnimation,
            child: message_widget,
          )
        ],
      ),
    );
  }

  Widget buildStep3() {
    title_widget = Image.asset('lib/src/image/onboarding/contents_img_03.png');
    message_widget = Container(
      padding: EdgeInsets.only(left: 75, right: 75),
      child: Text(
        "다이브에서 매일매일, 매 순간의 감정을 기록하며 당신을 알아가보세요",
        style: TextStyle(
          fontSize: 20,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
        ),
      ),
    );

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
            height: 20.0,
          ),
          FadeTransition(
            opacity: messageAnimation,
            child: message_widget,
          )
        ],
      ),
    );
  }

  Widget buildStep4() {
    contentMargin = 20.0;
    title_widget = Image.asset('lib/src/image/onboarding/contents_img_03.png');
    message_widget = Container(
      padding: EdgeInsets.only(left: 75, right: 75),
      child: Text(
        "그 전에 한 가지 알려주세요. 당신의 하루가 끝나는 시간을 언제로 설정하면 좋을까요?",
        style: TextStyle(
          fontSize: 20,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 60, right: 60),
            child: Text(
              "그 전에 한 가지 알려주세요. 당신의 하루가 끝나는 시간을 언제로 설정하면 좋을까요?",
              style: TextStyle(
                fontSize: 20,
                color: hexToColor("#e4faff"),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          ButtonTheme(
              minWidth: 200,
              height: 56,
              child: OutlineButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "오전 12시",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                  onPressed: () {},
                  borderSide: BorderSide(
                      color: Colors.grey, width: 5, style: BorderStyle.solid),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)))),
          SizedBox(
            height: 135.0,
          ),
          ButtonTheme(
            minWidth: 280,
            height: 50,
            child: FlatButton(
              color: Colors.transparent,
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "다음으로",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: hexToColor("#92d8ff")),
                  ),
                  Icon(Icons.forward,color: hexToColor("#92d8ff")),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 27.0,
          ),
          Text("* 추후에 설정탭에서 변경 가능합니다.",style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.5)
          ),)
//          FadeTransition(
//            opacity: titleAnimation,
//            child: title_widget,
//          ),
//          SizedBox(
//            height: 20.0,
//          ),
//          FadeTransition(
//            opacity: messageAnimation,
//            child: message_widget,
//          )
        ],
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget buildAnimate(step) {
    switch (step) {
      case 1:
        return buildStep1();
      case 2:
        return buildStep2();
      case 3:
        return buildStep3();
      case 4:
        return buildStep4();
        break;
      default:
        return buildStep4();
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () {
      messageController.forward();
    });
    return buildAnimate(animateStep);
  }
}
