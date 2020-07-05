import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutterapp/onboard/animate/picker/pricker_widget.dart';
import 'package:flutterapp/controller/diary_tab_controller.dart';

class OnboardAnimate extends StatefulWidget {
  @override
  OnboardAnimateState createState() => OnboardAnimateState();
}

class OnboardAnimateState extends State<OnboardAnimate>
    with TickerProviderStateMixin {
  Widget title_widget;
  Widget message_widget;

  AnimationController titleController;
  AnimationController messageController;
  AnimationController step4MessageController;
  AnimationController pickerController;
  AnimationController nextBtnController;
  AnimationController supportMessageController;
  AnimationController step5MessageController;
  AnimationController startBtnController;

  Animation<double> titleAnimation;
  Animation<double> messageAnimation;
  Animation<double> step4MessageAnimation;
  Animation<double> pickerAnimation;
  Animation<double> nextBtnAnimation;
  Animation<double> supportMessageAnimation;
  Animation<double> step5MessageAnimation;
  Animation<double> startBtnAnimation;

  int animateStep = 1;
  double contentMargin = 0;

  void initState() {
    super.initState();

    titleController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    messageController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);

    step4MessageController = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    pickerController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    nextBtnController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    supportMessageController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    step5MessageController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    startBtnController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    titleAnimation =
        CurvedAnimation(parent: titleController, curve: Curves.fastOutSlowIn);
    messageAnimation =
        CurvedAnimation(parent: messageController, curve: Curves.fastOutSlowIn);

    step4MessageAnimation = CurvedAnimation(
        parent: step4MessageController, curve: Curves.fastOutSlowIn);
    pickerAnimation =
        CurvedAnimation(parent: pickerController, curve: Curves.fastOutSlowIn);
    nextBtnAnimation =
        CurvedAnimation(parent: nextBtnController, curve: Curves.fastOutSlowIn);
    supportMessageAnimation = CurvedAnimation(
        parent: supportMessageController, curve: Curves.fastOutSlowIn);

    step5MessageAnimation = CurvedAnimation(
        parent: step5MessageController, curve: Curves.fastOutSlowIn);
    startBtnAnimation = CurvedAnimation(
        parent: startBtnController, curve: Curves.fastOutSlowIn);

    titleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          debugPrint("completed !! messageController.reverse");
          titleController.reverse();
          messageController.reverse();
        });
      }
    });

    messageAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        titleController.forward();
      }

      if (status == AnimationStatus.dismissed) {
        if (animateStep == 3) {
          debugPrint("messageAnimation dismissed step++!");
          Future.delayed(const Duration(milliseconds: 1000), () {
            debugPrint("step4MessageController forward!");
            step4MessageController.forward();
          });
        }
        setState(() {
          debugPrint("messageAnimation dismissed step++!");
          animateStep++;
        });
      }
    });

    step4MessageAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        pickerController.forward();
      }
      if (status == AnimationStatus.dismissed) {
        setState(() {
          animateStep++;
          Future.delayed(const Duration(milliseconds: 1000), () {
            step5MessageController.forward();
          });
        });
      }
    });

    pickerAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        nextBtnController.forward();
      }
      if (status == AnimationStatus.dismissed) {
        debugPrint("pickerAnimation.dismissed! ");
      }
    });

    nextBtnAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        supportMessageController.forward();
      }
      if (status == AnimationStatus.dismissed) {
        debugPrint("nextBtnAnimation.dismissed! ");
      }
    });

    step5MessageAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        startBtnController.forward();
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    step4MessageController.dispose();
    pickerController.dispose();
    nextBtnController.dispose();
    supportMessageController.dispose();
    step5MessageController.dispose();
    startBtnController.dispose();
    debugPrint("dispose!");
    super.dispose();
  }

  reverseStep4() {
    debugPrint("reverseStep4!");
    step4MessageController.duration = Duration(milliseconds: 1000);
    pickerController.duration = Duration(milliseconds: 1000);
    nextBtnController.duration = Duration(milliseconds: 1000);
    supportMessageController.duration = Duration(milliseconds: 1000);

    step4MessageController.reverse();
    pickerController.reverse();
    nextBtnController.reverse();
    supportMessageController.reverse();
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
    title_widget =
        Image.asset('lib/src/image/onboarding/2.0x/contents_img_02@2x.png');
    message_widget = Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Text(
        "당신은 당신이 무엇을 할때\n기쁨을 느끼고, 슬픔을 느끼는지\n잘 알고 있나요?",
        style: TextStyle(
          fontSize: 20,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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
    title_widget =
        Image.asset('lib/src/image/onboarding/2.0x/contents_img_03@2x.png');
    message_widget = Container(
      padding: EdgeInsets.only(left: 75, right: 75),
      child: Text(
        "다이브에서 매일매일,\n매 순간의 감정을 기록하며\n당신을 알아가보세요",
        style: TextStyle(
          fontSize: 20,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 165.0,
          ),
          FadeTransition(
            opacity: step4MessageAnimation,
            child: Container(
              padding: EdgeInsets.only(left: 60, right: 60),
              child: Text(
                "그 전에 한 가지 알려주세요.\n당신의 하루가 끝나는 시간을\n언제로 설정하면 좋을까요?",
                style: TextStyle(
                  fontSize: 20,
                  color: hexToColor("#e4faff"),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          FadeTransition(
            opacity: pickerAnimation,
            child: ButtonTheme(
                minWidth: 200,
                height: 56,
                child: Builder(builder: (context) {
                  return OutlineButton(
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
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      onPressed: () {
                        showPickerModal(context);
                      },
                      borderSide: BorderSide(
                          color: Colors.grey,
                          width: 5,
                          style: BorderStyle.solid),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)));
                })),
          ),
          SizedBox(
            height: 90.0,
          ),
          FadeTransition(
            opacity: nextBtnAnimation,
            child: ButtonTheme(
              minWidth: 280,
              height: 50,
              child: FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  reverseStep4();
                },
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
                    Icon(Icons.forward, color: hexToColor("#92d8ff")),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35.0,
          ),
          FadeTransition(
              opacity: supportMessageAnimation,
              child: Text(
                "* 추후에 설정탭에서 변경 가능합니다.",
                style: TextStyle(
                    fontSize: 13, color: Colors.white.withOpacity(0.5)),
              ))
        ],
      ),
    );
  }

  Widget buildStep5() {
    contentMargin = 20.0;
    title_widget = Image.asset('lib/src/image/onboarding/contents_img_03.png');
    return Center(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 166.0,
                ),
                FadeTransition(
                  opacity: step5MessageAnimation,
                  child: Container(
                    padding: EdgeInsets.only(left: 60, right: 60),
                    child: Text(
                      "좋았어요.\n그럼 이제부터 다이브와 함께\n당신의 감정에 집중해보세요.",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(
                  height: 194.0,
                ),
                FadeTransition(
                  opacity: startBtnAnimation,
                  child: ButtonTheme(
                    minWidth: 316,
                    height: 60,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      color: hexToColor("#63c7ff"),
                      textColor: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DiaryTabController()));
                      },
                      child: Text(
                        "시작하기",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
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
      case 5:
        debugPrint("buildStep5");
        return buildStep5();
        break;
      default:
        return buildStep5();
    }
  }

  @override
  Widget build(BuildContext context) {
    /* step을 setState. -> 애니메이션 실행 */
    if (animateStep < 4) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        messageController.forward();
      });
    }
    return buildAnimate(animateStep);
  }
}
