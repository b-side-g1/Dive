import 'package:Dive/services/common/share/share_service.dart';
import 'package:Dive/services/common/share/templates/ShareKakao.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:Dive/models/basic_model.dart';
import 'package:Dive/models/onboard/picker_time_model.dart';
import 'package:Dive/onboard/animate/picker/picker_data.dart';
import 'package:Dive/services/basic/basic_service.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:convert';
import 'dart:io' show Platform;

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final BasicService _basicService = BasicService();
  bool _isPush = true;
  String _appVersion = "0.0.0";
  String _currentEndAt = "오전 12시";

  @override
  void initState() {
    super.initState();
    _basicService.selectBasicData().then((basic) {
      setState(() {
        _isPush = basic.is_push != 0;
        _currentEndAt = basic.today_endAt;
      });
    });
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        _appVersion = value.version;
      });
    });
  }

  void _setPush(bool isPush) {
    _basicService.updatePush(isPush ? 1 : 0).then((res) {
      if (res != 0) {
        setState(() {
          _isPush = isPush;
        });
      }
    });
  }

  Widget pushOnOffWidget() {
    return CupertinoSwitch(
      activeColor: Colors.blue,
      value: _isPush,
      onChanged: _setPush,
    );
  }

  Future<void> _showEndAtAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  "수정하신 마감 시간은\n다음 날부터 적용됩니다.",
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Divider(
                  color: Colors.black87,
                  height: 10.0,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '확인',
                    style: TextStyle(color: CommonService.hexToColor("#63c7ff")),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showPickerModal(BuildContext context) {
    final pickerData = const JsonDecoder().convert(PickerData);

    Picker(
        adapter:
            PickerDataAdapter<String>(pickerData: pickerData, isArray: true),
        changeToFirst: true,
        hideHeader: false,
        selectedTextStyle: const TextStyle(color: Colors.blue),
        onConfirm: (Picker picker, List value) async {
          await updateEndAt(
              PickerTime(hour: (pickerData as List)[0][value[0]] as String));
          if (!context.mounted) return;
          _showEndAtAlert(context);
        }).showModal(context);
  }

  Future<void> updateEndAt(PickerTime pickerTime) async {
    if (pickerTime.hour == null) return;
    await _basicService.updateTodayAt(pickerTime.hour!);
    Basic resultBasic = await _basicService.selectBasicData();
    setState(() {
      _currentEndAt = resultBasic.today_endAt;
    });
  }

  Widget currentVersionWidget() {
    return Text(
      _appVersion,
      style: const TextStyle(fontSize: 15, color: Color(0xff00a3ff)),
    );
  }

  Widget doShareWidget(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: CommonService.hexToColor("#00a3ff"),
      ),
      onPressed: () async {
        ShareService shareService = ShareService.template(ShareKakao());

        try {
          await shareService.doShare();
        } catch (error) {
          debugPrint(
              "[setting_page.dart] #doShareWidget onPressed() error -> $error");
          CommonService.showToast(error.toString());
        }
      },
      child: const Text(
        "공유하기",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _bgContainer() {
    return FittedBox(
      fit: BoxFit.fill,
      child: Image.asset(
        'lib/src/image/setting/bg.png',
        height: 120,
      ),
    );
  }

  Widget settingWidget(String title, Widget widget) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.25))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Text(
              title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
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
          title: const Text(
            "설정",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: ListView(
                children: <Widget>[
                  settingWidget('푸시 설정', pushOnOffWidget()),
                  InkWell(
                    onTap: () {
                      showPickerModal(context);
                    },
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey, width: 0.25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(left: 13),
                            child: Text(
                              '하루 마감시간 설정',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Row(children: <Widget>[
                              Text(
                                _currentEndAt,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6),
                                child: Image.asset(
                                  'lib/src/image/setting/icon_arrow.png',
                                  width: 15,
                                  height: 14,
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  settingWidget('현재 버전', currentVersionWidget()),
                  Platform.isIOS
                      ? Container()
                      : settingWidget('앱 공유하기', doShareWidget(context)),
                ],
              ),
            ),
            _bgContainer(),
          ],
        ));
  }
}
