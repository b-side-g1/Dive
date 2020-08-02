import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/models/onboard/picker_time_model.dart';
import 'package:flutterapp/onboard/animate/picker/picker_data.dart';
import 'package:flutterapp/services/basic/basic_service.dart';
import 'package:package_info/package_info.dart';
import 'dart:convert';

class SettingPage extends StatefulWidget {
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  BasicService _basicService = BasicService();
  bool _isPush = true;
  String _appVersion = "0.0.0";
  String _currentEndAt = "오전 12시";

  @override
  void initState() {
    super.initState();
    _basicService.selectBasicData().then((basic) => {
          setState(() {
            _isPush = basic.is_push != 0;
            _currentEndAt = basic.today_endAt;
          })
        });
    PackageInfo.fromPlatform() // pubspec.yaml에 있는 config 값 갖고 올 수 있다!
        .then((value) => {
              setState(() {
                _appVersion = value.version;
              })
            });
  }

  _setPush(bool isPush) {
    _basicService.updatePush(isPush ? 1 : 0).then((res) => {
          if (res != 0)
            {
              setState(() {
                _isPush = isPush;
              })
            }
        });
  }

  Widget pushOnOffWidget() {
    //    print(Theme.of(context).platform == TargetPlatform.android); // 이런식으로 플랫폼 확인 가능
    return CupertinoSwitch(
      // ios 용 스위치 버튼임
      activeColor: Colors.blue,
      value: _isPush,
      onChanged: _setPush,
    );
  }

  showPickerModal(BuildContext context) {
    final pickerData = JsonDecoder().convert(PickerData);

    Picker(
        adapter:
            PickerDataAdapter<String>(pickerdata: pickerData, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) async {
          updateEndAt(PickerTime(hour: pickerData[0][value[0]]));
        }).showModal(context); //_scaffoldKey.currentState);
  }

  void updateEndAt(PickerTime pickerTime) async {
    await _basicService.updateTodayAt(pickerTime.hour);
    Basic resultBasic = await _basicService.selectBasicData();
    setState(() {
      _currentEndAt = resultBasic.today_endAt;
    });
  }

  Widget todayEndAtWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          _currentEndAt,
          style: TextStyle(fontSize: 15, color: Colors.black),
        ),
        InkWell(
          child: Padding(
            padding: EdgeInsets.only(left: 6),
            child: Image.asset(
              'lib/src/image/setting/icon_arrow.png',
              width: 15,
              height: 14,
            ),
          ),
          onTap: () {
            showPickerModal(context);
          },
        ),
      ],
    );
  }

  Widget currentVersionWidget() {
    return Text(
      _appVersion,
      style: TextStyle(fontSize: 15, color: Color(0xff00a3ff)),
    );
  }

  Widget _bgContainer() {
    return FittedBox(
      fit: BoxFit.fill, // width 100% 적용!
      child: Image.asset(
        'lib/src/image/setting/bg.png',
        height: 120,
      ),
    );
  }

  Widget settingWidget(String title, Widget widget) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.25))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 13),
            child: Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: widget,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "설정",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0.0, // appBar shadow 처리 없애는 설정
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ListView(
                children: <Widget>[
                  settingWidget('푸시 설정', pushOnOffWidget()),
                  settingWidget('하루 마감시간 설정', todayEndAtWidget(context)),
                  settingWidget('현재 버전', currentVersionWidget()),
                ],
              ),
            ),
            _bgContainer(),
          ],
        ));
  }
}
