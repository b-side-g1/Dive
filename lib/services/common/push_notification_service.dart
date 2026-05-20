import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:Dive/models/basic_model.dart';
import 'package:Dive/services/basic/basic_service.dart';

class PushNotificationService {
  final BasicService _basicService = BasicService();

  Future<void> initialize() async {
    Basic basic = await _basicService.selectBasicData();
    if (basic.is_push == 0) {
      print('reject push');
      return;
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    String? token = await messaging.getToken();
    if (token != null) {
      print('token:$token');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('on message ${message.data}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('on resume/opened ${message.data}');
    });

    RemoteMessage? initial = await messaging.getInitialMessage();
    if (initial != null) {
      print('on launch ${initial.data}');
    }
  }
}
