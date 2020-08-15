import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/emotion_tag_box.dart';

class InputPageStep2 extends StatefulWidget {
  List emotions;

  InputPageStep2({Key key, List emotions})
      : emotions = emotions ?? [],
        super(key: key);

  @override
  _InputPageStep2State createState() => _InputPageStep2State();
}

class _InputPageStep2State extends State<InputPageStep2> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: height * 0.2),
            child: Text(
              '지금 떠오르는 감정들',
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 1),
                fontSize: width * 0.08,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 20.1, top: height * 0.04, bottom: 20.1),
            child: EmotionTagBox(
              emotions: widget.emotions,
            ),
          ),
        ],
      ),
    );
  }
}
