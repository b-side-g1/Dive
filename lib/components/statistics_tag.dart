import 'package:Dive/pages/tag_emotion_detail_page.dart';
import 'package:Dive/services/statistics/statistics_service.dart';
import 'package:Dive/services/tag/tag_service.dart';
import 'package:flutter/material.dart';

class StatisticsTag extends StatefulWidget {
  int year;
  int month;

  StatisticsTag({Key key, int year, int month})
      : year = year ?? DateTime.now().year,
        month = month ?? DateTime.now().month,
        super(key: key);

  @override
  _StatisticsTagState createState() => _StatisticsTagState();
}

class _StatisticsTagState extends State<StatisticsTag> {
  TagService _tagService = TagService();
  StatisticsService _statisticsService = StatisticsService();
  List bestTagList = [];
  List worstTagList = [];
  List<Map> mostTagList = [];

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    _statisticsService
        .getHappyReasons(widget.month, widget.year)
        .then((res) => {
              bestTagList = res
                  .map((e) => {
                        'id': e['id'],
                        'name': e['name'],
                        'count': e['count'],
                        'lastUpdatedAt': e['lastUpdatedAt']
                      })
                  .toList()
            });

    _statisticsService
        .getUnHappyReasons(widget.month, widget.year)
        .then((res) => {
              worstTagList = res
                  .map((e) => {
                        'id': e['id'],
                        'name': e['name'],
                        'count': e['count'],
                        'lastUpdatedAt': e['lastUpdatedAt']
                      })
                  .toList()
            });

    _statisticsService
        .getMostFrequentTags(widget.month, widget.year)
        .then((value) => {
              mostTagList = value
                  .map((e) => {
                        'id': e['id'],
                        'name': e['name'],
                        'percent': e['percent'],
                        'lastUpdatedAt': e['lastUpdatedAt']
                      })
                  .toList()
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
                Image.asset("assets/images/icon_no_data_feeling.png"),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Text("점수 기입 시 감정태그를 기입해보세요.",
                      style: TextStyle(color: Color(0xff959da6))),
                ),
                Text("이번달에 어떤 감정을 많이 느꼈는지 알려줄게요.",
                    style: TextStyle(color: Color(0xff959da6))),
              ],
            )));
  }

  Widget _tagListWidget(bool isBest) {
    String description =
        isBest ? "이달, 기분이 좋았던 순간의\n이유들이에요." : "이달, 기분이 안 좋았던\n순간의 이유들이에요.";
    List tagList = isBest ? bestTagList : worstTagList;

    if (tagList.isEmpty) {
      return Container();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      description,
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Image.asset(isBest
                        ? "assets/images/badge_best.png"
                        : "assets/images/badge_worst.png")
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: List.generate(tagList.length, (index) {
                          return InkWell(
                              onTap: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TagEmotionDetail(
                                                  type: 'tag',
                                                  title: tagList[index]['name'],
                                                  id: tagList[index]['id'],
                                                  month: widget.month,
                                                  year: widget.year,
                                                )))
                                  },
                              child: RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black),
                                    children: [
                                      TextSpan(
                                          text: "#",
                                          style: TextStyle(color: Colors.blue)),
                                      TextSpan(
                                          text: "${tagList[index]['name']}")
                                    ]),
                              ));
                        }))),
              ],
            )));
  }

  Widget _mostTagListWidget() {
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
                            fontSize: 16, fontWeight: FontWeight.w700))),
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
    // TODO: 조건문 수정 필요
    if (bestTagList.length < 1) {
      return _emptyTagWidget();
    } else {
      return Column(
        children: [
          _tagListWidget(true),
          _tagListWidget(false),
          _mostTagListWidget()
        ],
      );
    }
  }
}
