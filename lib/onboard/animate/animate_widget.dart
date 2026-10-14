import 'package:Dive/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/onboard/animate/picker/time_picker_widget.dart';
import 'package:Dive/onboard/animate/start_dive_widget.dart';
import 'package:Dive/provider/time_picker_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardAnimate extends StatefulWidget {
  const OnboardAnimate({super.key});

  @override
  OnboardAnimateState createState() => OnboardAnimateState();
}

class OnboardAnimateState extends State<OnboardAnimate>
    with TickerProviderStateMixin {
  Widget title_widget = const SizedBox.shrink();
  Widget message_widget = const SizedBox.shrink();

  late AnimationController titleController;
  late AnimationController messageController;
  late AnimationController step4MessageController;
  late AnimationController pickerController;
  late AnimationController nextBtnController;
  late AnimationController supportMessageController;
  late AnimationController step5MessageController;
  late AnimationController startBtnController;
  late AnimationController circleController;

  late Animation<double> titleAnimation;
  late Animation<double> messageAnimation;
  late Animation<double> step4MessageAnimation;
  late Animation<double> pickerAnimation;
  late Animation<double> nextBtnAnimation;
  late Animation<double> supportMessageAnimation;
  late Animation<double> step5MessageAnimation;
  late Animation<double> startBtnAnimation;
  late Animation<double> circleAnimation;

  int animateStep = 1;

  TimePickerProvider? _timePickerProvider;

  bool isFocusStep = false;

  @override
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

    circleController = AnimationController(
        duration: const Duration(milliseconds: 3500), vsync: this, value: 0.3);

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
    circleAnimation =
        CurvedAnimation(parent: circleController, curve: Curves.fastOutSlowIn);

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
          circleController.forward();
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
    });

    nextBtnAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        supportMessageController.forward();
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
    circleController.dispose();

    super.dispose();
  }

  void reverseStep4() {
    step4MessageController.duration = const Duration(milliseconds: 1000);
    pickerController.duration = const Duration(milliseconds: 1000);
    nextBtnController.duration = const Duration(milliseconds: 1000);
    supportMessageController.duration = const Duration(milliseconds: 1000);

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
        fontSize: SizeConfig.blockSizeHorizontal * 20,
        color: Colors.white,
        fontWeight: FontWeight.w100,
      ),
    );

    message_widget = Text(
      "안녕하세요",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 7,
          color: hexToColor("#e4faff"),
          fontFamily: "NotoSans"),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 77),
            child: isFocusStep
                ? title_widget
                : FadeTransition(
                    opacity: titleAnimation,
                    child: title_widget,
                  ),
          ),
          const SizedBox(height: 77),
          isFocusStep
              ? message_widget
              : FadeTransition(
                  opacity: messageAnimation,
                  child: message_widget,
                )
        ],
      ),
    );
  }

  Widget buildStep2() {
    title_widget = SvgPicture.asset('assets/images/svg/contents_img_02.svg');

    message_widget = Text(
      "당신은 당신이 무엇을 할때\n기쁨을 느끼고, 슬픔을 느끼는지\n잘 알고 있나요?",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 6.5,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
          fontFamily: "NotoSans"),
      textAlign: TextAlign.center,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.zero,
            child: isFocusStep
                ? title_widget
                : FadeTransition(
                    opacity: titleAnimation,
                    child: title_widget,
                  ),
          ),
          SizedBox(height: SizeConfig.blockSizeHorizontal * 10.0),
          isFocusStep
              ? message_widget
              : FadeTransition(
                  opacity: messageAnimation,
                  child: message_widget,
                )
        ],
      ),
    );
  }

  Widget buildStep3() {
    title_widget = SvgPicture.asset('assets/images/svg/contents_img_03.svg');

    message_widget = Text(
      "다이브에서 매일매일,\n매 순간의 감정을 기록하며\n당신을 알아가보세요",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 6.8,
          color: hexToColor("#e4faff"),
          fontWeight: FontWeight.bold,
          fontFamily: "NotoSans"),
      textAlign: TextAlign.center,
    );

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.blockSizeVertical * 30),
          isFocusStep
              ? title_widget
              : FadeTransition(
                  opacity: titleAnimation,
                  child: title_widget,
                ),
          SizedBox(height: SizeConfig.blockSizeVertical * 4),
          isFocusStep
              ? message_widget
              : FadeTransition(
                  opacity: messageAnimation,
                  child: message_widget,
                )
        ],
      ),
    );
  }

  Widget buildStep4() {
    Widget step4_text_endAt = Container(
      padding: EdgeInsets.only(
          left: SizeConfig.blockSizeHorizontal * 8,
          right: SizeConfig.blockSizeHorizontal * 8),
      child: Text(
        "그 전에 한 가지 알려주세요.\n당신의 하루가 끝나는 시간을\n언제로 설정하면 좋을까요?",
        style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal * 5.5,
            color: hexToColor("#e4faff"),
            fontWeight: FontWeight.bold,
            fontFamily: "NotoSans"),
        textAlign: TextAlign.center,
      ),
    );

    Widget step4_btn_picker = SizedBox(
        width: SizeConfig.blockSizeHorizontal * 50,
        height: SizeConfig.blockSizeVertical * 10,
        child: const TimePickerWidget());

    Widget step4_btn_next = SizedBox(
      width: SizeConfig.blockSizeHorizontal * 50,
      height: SizeConfig.blockSizeVertical * 7,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        onPressed: () {
          reverseStep4();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "다음으로",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                  fontWeight: FontWeight.bold,
                  color: hexToColor("#92d8ff"),
                  fontFamily: "NotoSans"),
            ),
            Icon(Icons.forward, color: hexToColor("#92d8ff")),
          ],
        ),
      ),
    );

    Widget step4_text_after_setting = Text(
      "* 추후에 설정탭에서 변경 가능합니다.",
      style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 5,
          color: Colors.white.withOpacity(0.5),
          fontFamily: "NotoSans"),
    );

    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(height: SizeConfig.blockSizeVertical * 20),
          isFocusStep
              ? step4_text_endAt
              : FadeTransition(
                  opacity: step4MessageAnimation, child: step4_text_endAt),
          SizedBox(height: SizeConfig.blockSizeVertical * 13),
          isFocusStep
              ? step4_btn_picker
              : FadeTransition(
                  opacity: pickerAnimation,
                  child: SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 50,
                      height: SizeConfig.blockSizeVertical * 10,
                      child: const TimePickerWidget()),
                ),
          SizedBox(height: SizeConfig.blockSizeVertical * 18),
          isFocusStep
              ? step4_btn_next
              : FadeTransition(
                  opacity: nextBtnAnimation, child: step4_btn_next),
          SizedBox(height: SizeConfig.blockSizeVertical * 4),
          isFocusStep
              ? Expanded(flex: 2, child: step4_text_after_setting)
              : FadeTransition(
                  opacity: supportMessageAnimation,
                  child: step4_text_after_setting),
        ],
      ),
    );
  }

  Widget buildStep5() {
    Widget step5_text1 = Text(
      "좋았어요.\n그럼 이제부터 다이브와 함께\n당신의 감정에 집중해보세요.",
      style: TextStyle(
        fontSize: SizeConfig.blockSizeHorizontal * 6,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: "NotoSans",
      ),
      textAlign: TextAlign.center,
    );

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            isFocusStep
                ? Container(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 15),
                    child: Image.asset(
                        'lib/src/image/onboarding/contents_img_04.png'))
                : Container(
                    padding: EdgeInsets.only(
                        top: SizeConfig.blockSizeVertical * 15),
                    child: ScaleTransition(
                      scale: circleAnimation,
                      alignment: Alignment.center,
                      child: Image.asset(
                          'lib/src/image/onboarding/contents_img_04.png'),
                    )),
            Padding(
              padding:
                  EdgeInsets.only(top: SizeConfig.blockSizeVertical * 35),
              child: Align(
                alignment: Alignment.center,
                child: isFocusStep
                    ? step5_text1
                    : FadeTransition(
                        opacity: step5MessageAnimation, child: step5_text1),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        isFocusStep
            ? const StartDiveWidget()
            : FadeTransition(
                opacity: startBtnAnimation, child: const StartDiveWidget())
      ],
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget buildAnimate(int step) {
    switch (step) {
      case 1:
        return buildStep1();
      case 2:
        return buildStep2();
      case 3:
        return buildStep3();
      case 4:
        return StreamProvider<PickerTime>.value(
          initialData: PickerTime(hour: '00'),
          value: _timePickerProvider!.pickerStream,
          child: buildStep4(),
        );
      case 5:
        return StreamProvider<PickerTime>.value(
          initialData: PickerTime(hour: '00'),
          value: _timePickerProvider!.pickerStream,
          child: buildStep5(),
        );
      default:
        return buildStep5();
    }
  }

  @override
  Widget build(BuildContext context) {
    _timePickerProvider = Provider.of<TimePickerProvider>(context);

    if (isFocusStep == false) {
      if (animateStep < 4) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          messageController.forward();
        });
      }
    }

    return buildAnimate(animateStep);
  }
}
