import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/pages/input_page_step1.dart';
import 'package:flutterapp/pages/input_page_step2.dart';
import 'package:flutterapp/pages/input_page_step3.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int step = 1;
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
            Navigator.pop(context);
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
    print('${MediaQuery.of(context).size.height / 3 * step} __ height');

    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _controller,
              scrollDirection: Axis.vertical,
              children: [
                InputPageStep1(handlerPageView: handlerPageView),
                InputPageStep2(),
                InputPageStep3(),
              ],
              onPageChanged: (page) {
                print("page 변경 ${page}");
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
class InputPagAnimation extends StatefulWidget {
  @override
  _InputPagAnimationState createState() => _InputPagAnimationState();
}

class _InputPagAnimationState extends State<InputPagAnimation> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      child: InputPage(),
      opacity: 0.5,
      duration: Duration(seconds: 1),
    );
  }
}
