import 'package:flutter/material.dart';
import 'package:Dive/components/tag_box.dart';
import 'package:random_string/random_string.dart';

import 'package:Dive/components/forms/InputComponent.dart';
import 'package:Dive/models/record_model.dart';
import 'package:Dive/services/record/record_service.dart';

import '../time_picker.dart';

class RecordingForm extends StatefulWidget {
  @override
  _RecordingFormState createState() {
    return _RecordingFormState();
  }
}

class _RecordingFormState extends State<RecordingForm> {
  final int minScore = 0;
  final int maxScore = 100;
  List<String> feelingTags = [
    '신남',
    '행복함',
    '기분좋음',
    '편안함',
    '사랑돋음',
    '설렘',
    '뿌듯함',
    '복잡함',
    '생각 많음',
    '쏘쏘',
    '무미건조',
    '지루함',
    '별로',
    '짜증남',
    '화남',
    '끔찍함',
    '무서움',
    '걱정됨',
    '답답함',
    '우울함',
    '속상함',
    '서운함',
    '당황스러움',
    '취함',
    '졸림',
    '피곤한',
    '아픔',
    '배고픔',
    '슬픔'
  ];
  List<String> reasonTags = [
    '일',
    '가족',
    '친구',
    '애인',
    '쉼',
    '운동',
    '모임',
    '취미',
    '쇼핑',
    '알콜',
  ];

  final reasonController = TextEditingController();
  final scoreController = TextEditingController();
  DateTime when;
  int score;
  final _formKey = GlobalKey<FormState>();

  RecordService _recordService = RecordService();

  @override
  void dispose() {
    scoreController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2),
            child: CustomTimePickerSpinner((time) {
              this.when = time;
            }),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: InputComponent(
              title: '기분 숫자 점수',
              validator: (value) {
                var i = value == '' ? null : int.parse(value);
                if (i == null || i < this.minScore || i > this.maxScore) {
                  return '${this.minScore} ~ ${this.maxScore} 사이의 값을 입력해주세요';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: scoreController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                TagBox(
                  tags: this.feelingTags,
                  title: '세부 기분 태그',
                  columnNumber: 5,
                ),
                TagBox(
                  tags: this.reasonTags,
                  title: '이유 활동 태그',
                  columnNumber: 5,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: InputComponent(
              title: '이유(자유 텍스트)',
              validator: (value) {
                if (value.contains(' ')) {
                  return '공백 입력 불가';
                }
                return null;
              },
              controller: reasonController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var score = int.parse(scoreController.value.text);
                  var reason = reasonController.value.text;
                  print('[recording_form.dart] score -> $score');
                  print('[recording_form.dart] reason -> $reason');
                  setState(() {
                    this.feelingTags.add(reasonController.value.text);
                    // reasonTags.add(reason);
                  });
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  Record record = Record(
                      id: randomString(20), score: score, description: "테스트");
                  _createRecord(record);
                  _getAllRecords();
                }
              },
              child: Text('태그 입력'),
            ),
          ),
        ],
      ),
    );
  }

  void _createRecord(Record record) async {
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    final result = await _recordService.insertRecord(record);
    print('[recording_form.dart] #_insertRecord Result -> $result');
  }

  void _getAllRecords() async {
    final records = await _recordService.selectAllRecord();
    for (final record in records) {
      final id = record.id;
      final score = record.score;
      print("[recording_form.dart] record -> $id , $score");
    }
  }
}
