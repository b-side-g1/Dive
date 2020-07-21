
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/services/common/common_service.dart';
import 'package:uuid/uuid.dart';
import 'package:flutterapp/main.dart';

void main() {
  test('uuid should be 32byte.', () {
    String uuid = CommonService.generateUUID();
    expect(uuid.length, 32);
  });

  test('for test.', () {
    for(int i=0; i<10; i++) {

      if(i==5) {
        break;
      }
      print(i);
    }
});
}
