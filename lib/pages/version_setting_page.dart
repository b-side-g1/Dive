import 'package:flutter/material.dart';

class VersionSettingPage extends StatefulWidget {
  @override
  _VersionSettingPageState createState() => _VersionSettingPageState();
}

class _VersionSettingPageState extends State<VersionSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("버전 정보")),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("뒤로 가기"),
          ),
        ));
  }
}
