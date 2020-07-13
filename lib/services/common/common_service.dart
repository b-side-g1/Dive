import 'dart:ui';

class CommonService {

  static Color hexToColor(String code) => Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

}