import 'package:Dive/migrations/migration.dart';
import 'package:Dive/migrations/v1_initialization.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

import '../config_test.dart';

Future<void> main() async {
  test('DB initialization test', () async {
    var db = await databaseFactoryFfi.openDatabase(TEST_DATABASE_PATH);
    Migration v1 = new V1Initialization();

    await db.transaction((txn) async {
      await v1.down(txn);
      await v1.down(txn);
      await v1.down(txn);
      await v1.down(txn);
    }).then((value) {
      print('--------------------');
      print('Success v1 down!');
      print('--------------------');
    });

    await db.transaction((txn) async {
      await v1.up(txn);
      await v1.up(txn);
    }).then((value) {
      print('--------------------');
      print('Fail v1 up... Must be fail');
      print('--------------------');
      expect(true, false);
    }).catchError((onError) {
      print('--------------------');
      print('Success v1 up failed!');
      print(onError);
      print('--------------------');
      expect(false, false);
    });

    await db.transaction((txn) async {
      await v1.up(txn);
    }).then((value) {
      print('--------------------');
      print('Success v1 up!');
      print('--------------------');
      expect(true, true);
    });

    await db.transaction((txn) async {
      return Future.wait([
        v1.down(txn),
        v1.up(txn),
      ]);
    }).then((results) {
      expect(results.length, 2);
      print('--------------------');
      print('DB initialized!');
      print(results);
      print('--------------------');
    }).catchError((onError) {
      print(onError);
      expect(false, true);
    });

    db.close();
    expect(true, true);
  });
//  test('DB migration v1 down test', () async {
//    sqfliteFfiInit();
//    var db = await
//  });
}
