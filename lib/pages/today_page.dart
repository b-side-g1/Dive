import 'package:flutter/cupertino.dart';
import 'package:flutterapp/components/record_slide.dart';
import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/models/today_model.dart';

class TodayPage extends StatefulWidget {
  _TodayPageState createState() => _TodayPageState();
}

class _TodayPageState extends State<TodayPage> {

  List<Record> recordList = [
    Record(id: '1',score: 80,description:'저녁 밤바람이 시원하고, 일도 다 끝내서 기분이 좋다.',
      today: Today(id: '1',date: DateTime(2020, 06, 27, 14, 28, 0)),
      emotions: [
        Emotion(id: '1',name: '신남'),
        Emotion(id: '2',name: '행복함'),
        Emotion(id: '3',name: '기분좋음'),
        Emotion(id: '4',name: '편안함'),
      ],tags: [
        Tag(id: '1',name: '운동'),
        Tag(id: '2',name: '취미'),
        Tag(id: '3',name: '친구'),
      ]),
    Record(id: '2',score: 20,description:'모든게 다 지루하다.',
        today: Today(id: '1',date: DateTime(2020, 06, 27, 13, 2, 0)),
        emotions: [
          Emotion(id: '5',name: '무미건조'),
          Emotion(id: '6',name: '지루함'),
        ]),
  ];

//  List<Record> recordList = [
//      Record.fromJson({
//        'id': '1',
//        'score' : 80,
//        'description': '저녁 밤바람이 시원하고, 일도 다 끝내서 기분이 좋다.',
//        'today': Today.fromJson({
//          'id': '1',
//          'date': DateTime(2020, 06, 27, 14, 28, 0)
//        }),
//        'tags': [
//          Tag.fromJson({
//            'id': '1',
//            'name': '운동',
//          }),
//          Tag.fromJson({
//            'id': '2',
//            'name': '취미',
//          }),
//          Tag.fromJson({
//            'id': '3',
//            'name': '친구',
//          })
//        ],
//        'emotions': [
//          Emotion.fromJson({
//            'id': '1',
//            'name': '신남',
//          }),
//          Emotion.fromJson({
//            'id': '2',
//            'name': '헹복함',
//          }),
//          Emotion.fromJson({
//            'id': '3',
//            'name': '기분좋음',
//          }),
//          Emotion.fromJson({
//            'id': '4',
//            'name': '편안함',
//          }),
//        ]
//      }),
//    Record.fromJson({
//      'id': '2',
//      'score' : 20,
//      'description': '모든게 다 지루하다',
//      'today': Today.fromJson({
//        'id': '1',
//        'date': DateTime(2020, 06, 27, 13, 2, 0)
//      }),
//      'emotions': [
//        Emotion.fromJson({
//          'id': '5',
//          'name': '무미건조',
//        }),
//        Emotion.fromJson({
//          'id': '6',
//          'name': '지루함',
//        }),
//      ]
//    })
//  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          RecordSlide(recordList: this.recordList,), // TODO: InputPage 아래로 가야 되는데 그러면 안 보여서 우선 위로 했어요~
//          InputPage(),
        ],
      ),
    );
  }


}