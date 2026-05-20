import 'package:Dive/components/custom_month_picker.dart';
import 'package:Dive/components/forms/pie_chart.dart';
import 'package:Dive/components/statistic_tag_most.dart';
import 'package:Dive/components/statistics/month_graph.dart';
import 'package:Dive/components/statistics_emotion.dart';
import 'package:Dive/components/statistics_tag.dart';
import 'package:Dive/inherited/state_container.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:flutter/material.dart';

import 'input_page.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticsPage> {
  final StatisticsService _statisticsService = StatisticsService();

  int _year = DateTime.now().year;
  int _month = DateTime.now().month;

  int _monthCnt = 0;
  double _averageScore = 0;
  bool isEmpty = false;
  int minStatisticCnt = 1;

  final List<List<String>> averageScoreFeedbackTextList = [
    ["기분이 좋지 않아도 괜찮아요. 이 또한 지나갈 것이고,", "돌이켜보면 결국 도움이 되는 시간들일거에요"],
    ["불안해 하지 말아요. 당신은 잘 하고 있고, 앞으로도 잘 해낼거에요."],
    ["기분이 생각이 되지 않도록, 내가 내 삶의 주인이 되는 것이 중요해요."],
    ["행복한 사람이 되려고 노력하지 않아도 돼요.", "그냥 지금 이순간 행복하면돼요."],
    [
      "보통의 날들을 편안히 보내는 것이",
      "행복한 날들을 위해 애쓰는 것보다 나을거에요.",
      "오늘 하루도 정말 잘 해냈어요."
    ],
    ["아무것도 변하지 않더라도", "일상을 잘 지내다 보면 더욱 좋은일이 일어날거에요."],
    ["기분을 좋게 하기 위해서 필요한 건 달달한 케익과 커피면 충분해요!"],
    ["기분 좋은 날들을 지속하기 위해선 무엇을 해야 할까요?"],
    [
      "즐거운 나날이 계속되고 있네요.",
      "무엇이 나를 즐겁게 만드는지 탐색해보고",
      "그러한 행동이 나를 발전시킬 수 있도록 탐구해봐요."
    ],
    ["하루하루가 만족스럽고 행복한 날들이에요!"],
  ];

  @override
  void initState() {
    super.initState();
    _setGraphData(_year, _month);
  }

  Future<void> _setGraphData(int year, int month) async {
    var graphResult = await _statisticsService.getGraphData(month, year);
    if (graphResult.isEmpty && !_isToday(year, month)) {
      CommonService.showToast("$year년 $month월엔 기록한 감정이 없습니다.");
      return;
    }
    var averageScore =
        await _statisticsService.getAverageScoreByMonth(month, year);
    setState(() {
      _year = year;
      _month = month;
      _monthCnt = graphResult.length;
      isEmpty = graphResult.isEmpty || _monthCnt < minStatisticCnt;
      _averageScore = averageScore;
    });
  }

  Future<Map?> _showCustomMonthPicker(BuildContext context) {
    return showDialog<Map>(
        context: context,
        builder: (context) {
          return CustomMonthPicker(year: _year, month: _month);
        });
  }

  Widget _monthContainer(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showCustomMonthPicker(context).then((value) {
          if (value != null) {
            _setGraphData(value["year"] ?? DateTime.now().year,
                value["month"] ?? DateTime.now().month);
          }
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "$_month월",
            style: const TextStyle(fontSize: 23, color: Colors.white),
          ),
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: Image.asset(
              "assets/images/icon_date_arrow.png",
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _createRecordContainer(BuildContext context) {
    if (!_isToday() || _monthCnt >= minStatisticCnt) {
      return Container();
    }
    String text = _monthCnt < 1
        ? "  오늘 하루 어땠나요?\n 감정을 기록하고 함께\n나 자신을 탐색해봐요."
        : "  하루만 더 입력하면\n 나만의 감정리포트를\n\t\t\t\t\t볼 수 있어요!";
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/bg_statistics.png'),
        )),
        child: Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset('assets/images/tooltip_box.png'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        text,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSans"),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                StateContainer(child: const InputPage())));
                  },
                  child: Image.asset(
                    'assets/images/btn_dive.png',
                    height: 140,
                  ),
                )
              ],
            )));
  }

  bool _isToday([int? year, int? month]) {
    DateTime today = DateTime.now();
    if (year == null || month == null) {
      return today.year == _year && today.month == _month;
    }
    return today.year == year && today.month == month;
  }

  Widget _statisticsMonth() {
    if (isEmpty) {
      return Container();
    }

    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: Column(
          children: [
            _graphMonth(),
            const Divider(color: Colors.grey),
            _summaryMonth()
          ],
        ));
  }

  Widget _graphMonth() {
    return Padding(
        padding: const EdgeInsets.only(right: 10, left: 10, top: 5),
        child: MonthGraph(_year, _month));
  }

  Widget _summaryMonth() {
    int feedbackTextIndex = (_averageScore.ceil() / 10).ceil();
    feedbackTextIndex =
        feedbackTextIndex == 0 ? feedbackTextIndex : feedbackTextIndex - 1;

    return Container(
        margin: const EdgeInsets.only(top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
                size: const Size(56, 56),
                painter: PieChart(
                    percentage: _averageScore.floor(),
                    textScaleFactor: 0.8,
                    textColor: const Color(0xff63c7ff),
                    unFilledChartColor: const Color(0xff63c7ff),
                    filledChartColor: const Color(0xff33f7fe))),
            Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("$_month월  나의  평균  감정  점수",
                    style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w700))),
            Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                child: Column(
                    children: List.generate(
                        averageScoreFeedbackTextList[feedbackTextIndex]
                            .length, (index) {
                  return Align(
                      alignment: Alignment.center,
                      child: Text(
                          averageScoreFeedbackTextList[feedbackTextIndex]
                              [index],
                          style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xff959da6),
                              fontWeight: FontWeight.w700)));
                }))),
          ],
        ));
  }

  Widget _statisticsTag() {
    if (isEmpty) {
      return Container();
    }
    return StatisticsTag(
      year: _year,
      month: _month,
    );
  }

  Widget _statisticsEmotion() {
    if (isEmpty) {
      return Container();
    }
    return StatisticsEmotion(
      year: _year,
      month: _month,
    );
  }

  Widget _statisticsTagMost() {
    if (isEmpty) {
      return Container();
    }
    return StatisticsTagMost(
      year: _year,
      month: _month,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xffAE87DA), Color(0xff8394EE)],
          begin: FractionalOffset.topRight,
          end: FractionalOffset.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            _monthContainer(context),
            _createRecordContainer(context),
            _statisticsMonth(),
            _statisticsTag(),
            _statisticsEmotion(),
            _statisticsTagMost()
          ],
        ),
      ),
    )));
  }
}
