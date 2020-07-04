import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/input_page_1.dart';

class InputPage extends StatefulWidget {
  InputPage() : super();

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  int step = 1;

  @override
  Widget build(BuildContext context) {
    _setBackGround() {
      switch (step) {
        case 1:
          return Color.fromRGBO(43, 99, 194, 1.0);
        case 2:
          return Color.fromRGBO(20, 69, 151, 1.0);
        case 3:
          return Color.fromRGBO(12, 48, 107, 1.0);
      }
    }

    _setPageByStep() {
      switch (step) {
        case 1:
          return InputPageStep1();
        case 2:
          return Text('Step2');
        case 3:
          return Text('Step3');
      }
    }

    return Container(
      decoration: BoxDecoration(color: _setBackGround()),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Opacity(
                      opacity: step == 1 ? 0 : 1.0,
                      child: FloatingActionButton(
                        mini: true,
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                        onPressed: () {
                          setState(() {
                            step > 1 ? step -= 1 : step = step;
                          });
                        },
                        backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                    ),
                    FloatingActionButton(
                      mini: true,
                      child: Icon(
                        Icons.close,
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      onPressed: () {},
                      backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                height: 100,
                child: _setPageByStep(),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  FloatingActionButton(
                    mini: true,
                    child: Icon(
                      step != 3
                          ? Icons.keyboard_arrow_down
                          : Icons.import_contacts,
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                    ),
                    onPressed: () {
                      setState(() {
                        step < 3 ? step += 1 : step = step;
                      });
                    },
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.2),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
