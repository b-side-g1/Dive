import 'package:flutter/material.dart';
import 'package:flutterapp/splash/splash_page.dart';
import 'package:flutterapp/onboard/onboard_page.dart';
import 'package:flutterapp/pages/input_page.dart';
import 'package:flutterapp/services/basic/basic_service.dart';

bool initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BasicService basicService = BasicService();
  initScreen = await basicService.isSetTodayEndAt();

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
  }
}
