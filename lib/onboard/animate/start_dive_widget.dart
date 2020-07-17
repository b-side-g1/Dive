import 'package:flutter/material.dart';
import 'package:flutterapp/controller/diary_tab_controller.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:provider/provider.dart';

class StartDiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ButtonTheme(
        minWidth: 316,
        height: 60,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          color: CommonService.hexToColor("#63c7ff"),
          textColor: Colors.white,
          padding: EdgeInsets.all(8.0),
          onPressed: () {

//            Navigator.of(context).pushReplacement(MaterialPageRoute(
//                builder: (BuildContext context) => DiaryTabController()));
          },
          child: Text(
            "시작하기",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ));
  }
}
