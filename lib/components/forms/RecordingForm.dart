import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

import 'package:flutterapp/components/forms/InputComponent.dart';
import 'package:flutterapp/models/record_model.dart';
import 'package:flutterapp/services/record/record_service.dart';

class RecordingForm extends StatefulWidget {
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
  List<String> reasonTags = [];
  List<Padding> reasonHints;

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
    reasonHints = [];
    reasonTags.forEach((e) => reasonHints
        .add(new Padding(padding: EdgeInsets.all(2), child: Text(e))));
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: InputComponent(
              title: '점수 입력',
              validator: (value) {
                var i = value == '' ? null : int.parse(value);
                if (i == null || i <= 0 || i > 5) {
                  return '1 ~ 5 사이의 값을 입력해주세요';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              controller: scoreController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text('태그 선택'),
                Row(
                  children: this.reasonHints,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: InputComponent(
              title: '이유(태그 직접 입력)',
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
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  var score = int.parse(scoreController.value.text);
                  var reason = reasonController.value.text;
                  print('[RecordingForm.dart] score -> $score');
                  print('[RecordingForm.dart] reason -> $reason');
                  setState(() {
                    reasonTags.add(reason);
                  });
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
                  Record record = Record(id: randomString(20), score: score,description: "테스트" );
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
    final result = await _recordService.insertRecord(record);
    print('[RecordingForm.dart] #_insertRecord Result -> $result');
  }

  void _getAllRecords() async {
    final records = await _recordService.selectAllRecord();
    for (final record in records) {
      final id = record.id;
      final score = record.score;
      print("[RecordingForm.dart] record -> $id , $score");
    }
  }
}
