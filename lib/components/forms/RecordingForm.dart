import 'package:flutter/material.dart';
import 'package:flutterapp/components/forms/InputComponent.dart';

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
                  print(reasonHints);
                  setState(() {
                    reasonTags.add(reasonController.value.text);
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
