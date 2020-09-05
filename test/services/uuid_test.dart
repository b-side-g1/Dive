import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/services/common/common_service.dart';

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
