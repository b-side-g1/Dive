import 'package:flutter/material.dart';

class PushSettingPage extends StatefulWidget {
  @override
  _PushSettingPageState createState() => _PushSettingPageState();
}

class _PushSettingPageState extends State<PushSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("알림 설정")),
        body: Center(
          child: RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("뒤로 가기"),
          ),
        ));
  }
}
