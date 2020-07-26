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

  void handlerPageView(int index) {
    print("handlerPageView ${index}");
    //TODO : page change error
    // // use this to animate to the page
    // _controller.animateToPage(index);
    // // // or this to jump to it without animating
    // _controller.jumpToPage(index);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  renderClose() {
    return Container(
      alignment: Alignment.centerRight,
      width: MediaQuery.of(context).size.width * 0.8,
      margin: const EdgeInsets.only(top: 35),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.3), shape: BoxShape.circle),
        child: IconButton(
          icon: Image.asset(
            'lib/src/image/daily/icon_x.png',
            height: 15,
            width: 15,
          ),
          tooltip: 'close',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  // _selectedIndex = page;
                });
              },
            ),
            renderClose(),
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
