import 'package:flutter/material.dart';
import 'package:Dive/services/basic/basic_service.dart';
import 'package:Dive/services/common/push_notification_service.dart';
import 'package:Dive/splash/splash_page.dart';

bool initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BasicService basicService = BasicService();
  initScreen = await basicService.isSetTodayEndAt();

  PushNotificationService pushNotificationService = PushNotificationService();
  await pushNotificationService.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Diary App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(initScreen));
    // home: InputPage());
  }
}
