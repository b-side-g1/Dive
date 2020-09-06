import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/emotion_tag_box.dart';
import 'package:flutterapp/services/common/common_service.dart';

class InputPageStep2 extends StatefulWidget {
  List emotions;

  InputPageStep2({Key key, List emotions})
      : emotions = emotions ?? [],
        super(key: key);

  @override
  _InputPageStep2State createState() => _InputPageStep2State();
}

class _InputPageStep2State extends State<InputPageStep2> {

  Widget slidHintText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerRight,
        child: Opacity(
          opacity: 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("가로로 넘겨보세요",style: TextStyle(
                fontSize: 13,
                color: CommonService.hexToColor("#ffffffff")
              ),),
              Icon(
                Icons.navigate_next,
                color: CommonService.hexToColor("#ffffffff"),
              )
            ],
          ),
        ));
  }



  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
            padding: EdgeInsets.only(top: height * 0.04, bottom: 20.1),
            child: EmotionTagBox(
              emotions: widget.emotions,
            ),
          ),
          slidHintText()
        ],
      ),
    );
  }
}
