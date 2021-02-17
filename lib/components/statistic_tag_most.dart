import 'package:Dive/pages/tag_emotion_detail_page.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:Dive/services/tag/tag_service.dart';
import 'package:flutter/material.dart';

class StatisticsTagMost extends StatefulWidget {
  int year;
  int month;

  StatisticsTagMost({Key key, int year, int month})
      : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month,
        super(key: key);

  @override
  _StatisticsTagMostState createState() => _StatisticsTagMostState();
}

class _StatisticsTagMostState extends State<StatisticsTagMost> {
  StatisticsService _statisticsService = StatisticsService();

  List<Map> mostTagList = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    _statisticsService
        .getMostFrequentTags(widget.month, widget.year)
        .then((value) => {
          setState((){
            mostTagList = value
                .map((e) => {
              'id': e['id'],
              'name': e['name'],
              'percent': e['percent'],
              'lastUpdatedAt': e['lastUpdatedAt']
            }).toList();
          })
    });
  }

  Widget _emptyTagWidget() {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(top: 30, bottom: 40),
            child: Column(
              children: [
                Image.asset("assets/images/icon_no_data_reason.png"),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text("감점 점수 기록과 함께 이유태그를 선택하면",
                      style: TextStyle(color: Color(0xff959da6))),
                ),
                Text("내가 왜 기분이 나쁜지 알 수 있어요.",
                    style: TextStyle(color: Color(0xff959da6))),
              ],
            )));
  }

  Widget _mostTagListWidget() {
    if (mostTagList.isEmpty) {
      return _emptyTagWidget();
    }
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Text("이달, 기분에 가장 영향을 미친 이유들이에요.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700))),
                Column(
                  children: List.generate(mostTagList.length, (index) {
                    return InkWell(
                        onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TagEmotionDetail(
                                            type: 'tag',
                                            title: mostTagList[index]['name'],
                                            id: mostTagList[index]['id'],
                                            month: widget.month,
                                            year: widget.year,
                                          )))
                            },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.5)),
                            color: index == 0
                                ? Color(0xff1fafff)
                                : index == 1
                                    ? Color(0xffAE87DA)
                                    : Color(0xff8394EE),
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "#${mostTagList[index]["name"]}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                        "${mostTagList[index]["percent"].floor().toString()}%",
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ))));
                  }),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return _mostTagListWidget();
  }
}
