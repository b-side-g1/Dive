import 'package:Dive/pages/tag_emotion_detail_page.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:flutter/material.dart';

class StatisticsEmotion extends StatefulWidget {
  int year;
  int month;

  StatisticsEmotion({Key key, int year, int month})
      : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month,
        super(key: key);

  @override
  _StatisticsEmotionState createState() => _StatisticsEmotionState();
}

class _StatisticsEmotionState extends State<StatisticsEmotion> {
  StatisticsService _statisticsService = StatisticsService();
  List<Map> mostEmotionList = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    _statisticsService
        .getMostFrequentEmotions(widget.month, widget.year)
        .then((res) => {
              setState(() {
                mostEmotionList = res
                    .map((e) => {
                          'id': e['id'],
                          'name': e['name'],
                          'percent': e['percent'],
                          'lastUpdatedAt': e['lastUpdatedAt']
                        })
                    .toList();
              })
            });
  }

  Widget _emptyEmotionWidget() {
    return Padding(
        padding: EdgeInsets.only(top: 30, bottom: 40),
        child: Column(
          children: [
            Image.asset("assets/images/icon_no_data_feeling.png"),
            Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text("감정 점수 기록과 함꼐 이유태그를 선택하면.",
                    style: TextStyle(color: Color(0xff959da6)))),
            Text("내가 왜 기분이 나쁜지 알 수 있어요.",
                style: TextStyle(color: Color(0xff959da6))),
          ],
        ));
  }

  Widget _emotionListWidget() {
    String description = "이달 가장 많이 느낀 기분이에요.";

    double height = 90;
    double width = 90;
    return Padding(
        padding: EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            description,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    mostEmotionList.length,
                    (index) {
                      var emotion = mostEmotionList[index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TagEmotionDetail(
                                            type: 'emotion',
                                            title: emotion['name'],
                                            id: emotion['id'],
                                            month: widget.month,
                                            year: widget.year,
                                          )))
                            },
                            child: Container(
                              height: height,
                              width: width,
                              decoration: BoxDecoration(
                                  color: int.parse(emotion["id"]) <= 6
                                      ? Color(0xfffebeff)
                                      : int.parse(emotion["id"]) <= 10
                                          ? Color(0xff77cdfd)
                                          : Color(0xff7f92d6),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'lib/src/image/tags/icon_${emotion["id"].toString()}_on.png',
                                      height: 30 / height * (100 + 9),
                                      width: 30 / width * (100 + 9),
                                    ),
                                    Text(emotion["name"].toString(),
                                        style: TextStyle(color: Colors.white))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                "${emotion["percent"].floor().toString()}%",
                              ))
                        ],
                      );
                    },
                  )))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 조건문 수정 필요
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: mostEmotionList.length < 1
            ? _emptyEmotionWidget()
            : _emotionListWidget());
  }
}
