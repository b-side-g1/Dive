import 'package:Dive/models/basic_model.dart';
import 'package:Dive/services/database/database_helper.dart';

class BasicService {
  Future<Basic> selectBasicData() async {
    final db = await DBHelper().database;

    final List<Map<String, dynamic>> immutableMaps =
        await db.query(Basic.tableName);

    return immutableMaps.isNotEmpty
        ? Basic.fromJson(immutableMaps.first)
        : Basic();
  }

  Future<bool> isSetTodayEndAt() async {
    Basic basic = await selectBasicData();
    return basic.today_endAt.isNotEmpty;
  }

  Future<int> updateTodayAt(String hour) async {
    final db = await DBHelper().database;
    int updateCount = await db.rawUpdate('''
    UPDATE ${Basic.tableName}
    SET today_endAt = ?, today_startAt = ?
    WHERE id = ?
    ''', [hour, hour, '1']);
    return updateCount;
  }

  void printHello() {
    print("Hello");
  }

  Future<int> updatePush(int isPush) async {
    final db = await DBHelper().database;
    int updateCount = await db.rawUpdate('''
    UPDATE ${Basic.tableName}
    SET is_push = ?
    WHERE id = ?
    ''', [isPush, '1']);
    return updateCount;
  }
}
