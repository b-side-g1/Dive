import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/input_page_step1.dart';
import 'package:flutterapp/pages/input_page_step2.dart';
import 'package:flutterapp/pages/input_page_step3.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int currentStep = 0;

  // step2 디버그용 리스트. rx를 이용할 게 아니라면 아래 주석을 살려서 탑다운으로 데이터를 처리하는 게 저장이나 불러오기에 깔끔하지 않은가 싶음.
  List emotions = [];

// Record를 통째로 받아서 사용할 경우 아래 주석 살려서 처리(Step2 기준)
//  Record _record;
//
//  get emotions => _record?.emotions;
//
//  set emotions(List<Emotion> values) => {_record.emotions = values};

  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // rx이용
    return PageView(
      controller: _controller,
      scrollDirection: Axis.vertical,
      children: [
        InputPageStep1(),
        InputPageStep2(
          emotions: emotions,
        ),
        InputPageStep3(),
      ],
    );
  }
}

// for common animation , updown btn
class InputPageAnimation extends StatefulWidget {
  @override
  _InputPageAnimationState createState() => _InputPageAnimationState();
}

class _InputPageAnimationState extends State<InputPageAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      child: InputPage(),
      opacity: 0.5,
      duration: const Duration(seconds: 1),
    );
  }
}
