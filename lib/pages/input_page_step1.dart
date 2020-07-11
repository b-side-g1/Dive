import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep1 extends StatefulWidget {
  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  String date = "오전 1시 1분";
  String title = "당신의 기분을 알려주세요.";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      decoration: new BoxDecoration(
          color: Color.fromRGBO(43, 99, 194, 1.0),
          border: Border.all(
            width: 1,
            color: Colors.green, //
          )),
      // decoration: BoxDecoration(
      //   image: DecorationImage(image: AssetImage('lib/src/image/marble.png')),
      // ),
      child: Column(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 250),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(date,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      )),
                  IconButton(
                    icon: Image.asset(
                      'lib/src/image/daily/Topnav_icon_setting@3x.png',
                      height: 24,
                    ),
                    tooltip: 'change date',
                    onPressed: () {},
                  )
                ],
              )),
          Text(title,
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ))
        ],
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('lib/src/image/marble_shadow.png'),
        //       alignment: Alignment(0.0, 0.75)),
        // ),
      ),
    ));
  }
}
