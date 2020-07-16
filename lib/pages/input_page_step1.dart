import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputPageStep1 extends StatefulWidget {
  @override
  _InputPageStep1State createState() => _InputPageStep1State();
}

class _InputPageStep1State extends State<InputPageStep1> {
  renderTimeSelect() {
    String date = "오전 1시 1분";
    String title = "당신의 기분을 알려주세요.";
    return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(date,
                  style: TextStyle(
                      fontSize: 21,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
              IconButton(
                icon: Image.asset(
                  'lib/src/image/daily/icon_arrow.png',
                  height: 24,
                ),
                tooltip: 'change date',
                onPressed: () {
                  print("클릭");
                },
              )
            ],
          ),
          Text(title,
              style: TextStyle(
                  fontSize: 21,
                  color: const Color(0xffffffff),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal))
        ]));
  }

  renderScoreSelect() {
    var score = new List<Widget>(10);
    for (var i = 0; i < score.length; i++) {
      var val = i * 10;

      score[i] = Text(
        val.toString(),
        style: TextStyle(
          fontFamily: 'Roboto',
          color: Color(0xffffffff),
          fontSize: 28,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.normal,
          letterSpacing: 0.28,
        ),
      );
    }

    return Padding(
        padding: const EdgeInsets.only(top: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('lib/src/image/daily/img_bubble.png'),
              fit: BoxFit.cover,
            )),
            child: Container(
              child: Center(
                  child: ListWheelScrollView(
                children: score,
                itemExtent: 60,
                diameterRatio: 1.5,
              )),
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      decoration: new BoxDecoration(
        color: Color.fromRGBO(43, 99, 194, 1.0),
      ),
      child: Column(
        children: <Widget>[renderTimeSelect(), renderScoreSelect()],
      ),
    ));
  }
}
