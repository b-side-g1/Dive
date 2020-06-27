import 'package:flutter/material.dart';

class TagSettingPage extends StatefulWidget {
  @override
  _TagSettingPageState createState() => _TagSettingPageState();
}

class _TagSettingPageState extends State<TagSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("태그 설정")),
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
