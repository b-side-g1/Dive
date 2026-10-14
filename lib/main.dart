import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:Dive/services/basic/basic_service.dart';
import 'package:Dive/services/common/push_notification_service.dart';
import 'package:Dive/splash/splash_page.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

import 'commons/static.dart';

late bool initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  BasicService basicService = BasicService();
  initScreen = await basicService.isSetTodayEndAt();

  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  KakaoSdk.init(nativeAppKey: KakaNativeKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diary App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(initScreen));
  }
}
