import 'package:flutter/material.dart';

class CurrentStatus extends StatelessWidget {

  bool isToday;
  bool isEmpty;
  int _dailyScore;

  CurrentStatus(this.isToday, this.isEmpty, this._dailyScore);

  @override
  Widget build(BuildContext context) {
    /*
    * 1. 오늘 O, 기록 X -> Text(지금 이 순간\n나의 기분을 남겨주세요)
    * 2. 오늘 O, 기록 O -> Text(점수)\n Text(오늘 하루의 점수)
    * 3. 오늘 X, 기록 X -> Text(이날은 기록했던\n기분이 없네요) + 중간 이미지 변경
    * 4. 오늘 X, 기록 O -> Text(점수)\n Text(이날 하루의 점수)
    * */
    if (isToday && isEmpty) {
      return Text(
        "지금 이 순간 \n나의 기분을 남겨보세요.",
        style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
        textAlign: TextAlign.center,
      );
    }
    if (isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(
                fontSize: 34,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Text(
            "오늘 하루의 점수",
            style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
            textAlign: TextAlign.center,
          )
        ],
      );
    }
    if (!isToday && isEmpty) {
      return Text(
        "이날은 기록했던\n기분이 없네요.",
        style: TextStyle(fontSize: 17, fontFamily: "NotoSans"),
        textAlign: TextAlign.center,
      );
    }
    if (!isToday && !isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dailyScore.toString(),
            style: TextStyle(
                fontSize: 34,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Text(
            "이날 하루의 점수",
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          )
        ],
      );
    }

    return Container();
  }
}
