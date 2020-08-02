import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/inherited/state_container.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/pages/input_page_step1.dart';
import 'package:flutterapp/pages/input_page_step2.dart';
import 'package:flutterapp/pages/input_page_step3.dart';
import 'package:flutterapp/provider/input/tag_provider.dart';
import 'package:provider/provider.dart';

import 'daily_page.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  List emotions = [];

  Color get backgroundColor {
    switch (step) {
      case 2:
        return Color.fromRGBO(19, 62, 133, 1.0);
      case 3:
        return Color.fromRGBO(7, 26, 58, 1.0);
      default:
        return Color.fromRGBO(43, 99, 194, 1.0);
    }
  }

  PageController _controller = PageController(
    initialPage: 0,
  );
  int step = 0;
  int testScore;

  void handlerPageView(int index) {
    step = index;
    _controller.animateToPage(index,
        curve: Curves.easeIn, duration: Duration(microseconds: 2000000));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  renderBackground() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset('lib/src/image/daily/bg_white_gradient.png'),
    );
  }

  renderStepButton() {
    return Expanded(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'up',
                mini: true,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                child: Image.asset(
                  'lib/src/image/daily/icon_up.png',
                  height: 16,
                  width: 16,
                ),
                onPressed: () {
                  handlerPageView(step - 1);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                heroTag: 'down',
                mini: true,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                child: Image.asset(
                  'lib/src/image/daily/icon_down.png',
                  height: 16,
                  width: 16,
                ),
                tooltip: 'next step',
                onPressed: () {
                  handlerPageView(step + 1);
                },
              ),
            ],
          ),
        ],
      )),
    );
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
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => DailyPage()));
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
                InputPageStep1(
                  backgroundColor: backgroundColor,
                ),
                InputPageStep2(
                  emotions: emotions,
                  backgroundColor: backgroundColor,
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
                    child: InputPageStep3(
                      backgroundColor: backgroundColor,
                    ))
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
            renderBackground(),
            renderStepButton(),
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
