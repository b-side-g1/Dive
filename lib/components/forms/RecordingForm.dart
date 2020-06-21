import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/components/TagBox.dart';
import 'package:flutterapp/components/forms/InputComponent.dart';

class RecordingForm extends StatefulWidget {
  final int minScore = 1;
  final int maxScore = 10;
  int hour = new DateTime.now().hour;
  int minute = new DateTime.now().minute;
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

  @override
  _RecordingFormState createState() {
    return _RecordingFormState();
  }
}

class _RecordingFormState extends State<RecordingForm> {
  final reasonController = TextEditingController();
  final scoreController = TextEditingController();
  DateTime when;
  int score;
  final _formKey = GlobalKey<FormState>();

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
            child: CupertinoTimerPicker(
                alignment: Alignment.center,
                initialTimerDuration:
                    Duration(hours: widget.hour, minutes: widget.minute),
                minuteInterval: 1,
                mode: CupertinoTimerPickerMode.hm,
                onTimerDurationChanged: (value) {
                  widget.hour = value.inHours;
                  widget.minute = value.inMinutes % 60;
                }),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: InputComponent(
              title: '기분 숫자 점수',
              validator: (value) {
                var i = value == '' ? null : int.parse(value);
                if (i == null || i < widget.minScore || i > widget.maxScore) {
                  return '${widget.minScore} ~ ${widget.maxScore} 사이의 값을 입력해주세요';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2),
            child: Column(
              children: <Widget>[
                TagBox(
                  tags: widget.feelingTags,
                  title: '세부 기분 태그',
                  columnNumber: 5,
                ),
                TagBox(
                  tags: widget.reasonTags,
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
                  setState(() {
                    widget.feelingTags.add(reasonController.value.text);
                  });
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
