import 'dart:ui';

import 'package:uuid/uuid.dart';

class CommonService {

  static Color hexToColor(String code) => Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  static String generateUUID() => Uuid().v4().replaceAll('-', '');

}