import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/emotion_tag_box.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/inherited/state_container.dart';

class InputPageStep2 extends StatefulWidget {
  Color background;
  List emotions;

  InputPageStep2({Key key, this.background, List emotions})
      : emotions = emotions,
        super(key: key);

  @override
  _InputPageStep2State createState() => _InputPageStep2State();
}

class _InputPageStep2State extends State<InputPageStep2> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
//      For Debug or develop
      backgroundColor: Color.fromRGBO(19, 62, 133, 1.0),
//    backgroundColor: widget.background,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                '지금 떠오르는 감정들',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.1, top: 20.1, bottom: 20.1),
              child: EmotionTagBox(
                emotions: widget.emotions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
