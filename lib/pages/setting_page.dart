import 'package:flutter/material.dart';
import 'package:flutterapp/pages/backup_setting_page.dart';
import 'package:flutterapp/pages/push_setting_page.dart';
import 'package:flutterapp/pages/tag_setting_page.dart';
import 'package:flutterapp/pages/version_setting_page.dart';

class SettingPage extends StatelessWidget {
  SettingPage({this.title});
  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(this.title)),
        body: ListView(
          children: <Widget>[
            RaisedButton(
                child: Text('알림 설정'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PushSettingPage()),
                  );
                }),
            RaisedButton(
                child: Text('태그 설정'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TagSettingPage()),
                  );
                }),
            RaisedButton(
                child: Text('백업'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BackupSettingPage()),
                  );
                }),
            RaisedButton(
                child: Text('버전'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VersionSettingPage()),
                  );
                }),
          ],
        ));
  }
}
