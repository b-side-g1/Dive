import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutterapp/models/basic_model.dart';
import 'package:flutterapp/services/basic/basic_service.dart';

class PushNotificationService {
  final BasicService _basicService = BasicService();

  Future initialize() async {
    Basic basic = await _basicService.selectBasicData();
    if (basic.is_push == 0) {
      print('reject push');
      return;
    }

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    if (Platform.isIOS) iOS_Permission(_firebaseMessaging);

    _firebaseMessaging.getToken().then((token) {
      print('token:' + token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }


  void iOS_Permission(FirebaseMessaging _firebaseMessaging) {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
