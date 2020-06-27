import 'package:flutter/material.dart';

class BackupSettingPage extends StatefulWidget {
  @override
  _BackupSettingPageState createState() => _BackupSettingPageState();
}

class _BackupSettingPageState extends State<BackupSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("백업 설정")),
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
