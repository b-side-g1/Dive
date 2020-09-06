
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Dive/services/common/common_service.dart';
import 'package:uuid/uuid.dart';
import 'package:Dive/main.dart';

void main() {
  test('uuid should be 32byte.', () {
    String uuid = CommonService.generateUUID();
    expect(uuid.length, 32);
  });

  test('list.', () {
    List<bool> bools = List();
    bools.add(true);
    print(bools[0]);
});
}
