import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonService {

  static Color hexToColor(String code) => Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  static String generateUUID() => Uuid().v4().replaceAll('-', '');
  static void showToast(String meesage) {
    Fluttertoast.showToast(
        msg: meesage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

}