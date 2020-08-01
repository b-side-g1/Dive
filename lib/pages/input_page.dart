import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/pages/input_page_step1.dart';
import 'package:flutterapp/pages/input_page_step2.dart';
import 'package:flutterapp/pages/input_page_step3.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:provider/provider.dart';

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
  int step = 1;
  int testScore;

  void handlerPageView(int index) {
    _controller.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(microseconds: 400));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  renderClose() {
    void _showDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            content: new Text("저장되지 않은 데이터는 삭제됩니다.\n취소하시겠습니까?"),
            actions: <Widget>[
              new FlatButton(
                child: new Text("아니오"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("네"),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.0), shape: BoxShape.rectangle),
        child: IconButton(
          icon: Image.asset(
            'lib/src/image/daily/icon_x.png',
            height: 16,
            width: 16,
          ),
          tooltip: 'close',
          onPressed: () {
            _showDialog();
          },
        ),
      ),
    );
  }

  renderSteper(step) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height - 40,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.20000000298023224,
            child: new Container(
                width: 4,
                decoration: new BoxDecoration(
                    color: Color(0xff000000),
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(40.0),
                      topRight: const Radius.circular(40.0),
                    ))),
          ),
          Positioned(
              child: Container(
                  width: 4,
                  height:
                      ((MediaQuery.of(context).size.height - 40) / 3) * step,
                  decoration: new BoxDecoration(
                      color: Color(0xff33f7fe),
                      borderRadius: BorderRadius.circular(100)))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final container = StateContainer.of(context);
    testScore = container.score;

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: [
                InputPageStep1(handlerPageView: handlerPageView),
              InputPageStep2(
              // 테스트해보진 않았지만, 변경 내용을 특별한 함수나 rx방식 없이
              // InputPage에서 step2의 변경을 트래킹할 수 있을 겁니다.
              // 빈 리스트가 아닌 경우의 처리는 고려치 않았기에, 정상동작하지 않을 수 있습니다.
              emotions: emotions,
              ),
                MultiProvider(
                    providers: [
                      StreamProvider<List<Tag>>.value(
                        value: TagProvider().tags,
                      ),
                      Provider<TagProvider>(
                        create: (_) => TagProvider(),
                      )
                    ],
                    child: InputPageStep3()
                )
              ],
              onPageChanged: (page) {
                setState(() {
                  step = page.toInt() + 1;
                });
              },
            ),
            Positioned(
                right: 20.0,
                top: 40.0,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[renderClose(), renderSteper(step)],
                  ),
                )),
          ],
        ),
      ),
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
      duration: Duration(seconds: 1),
    );
  }
}
