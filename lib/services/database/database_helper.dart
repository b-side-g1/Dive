import 'package:flutterapp/migrations/migration.dart';
import 'package:flutterapp/migrations/v1_initialization.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper _db = DBHelper._();

  factory DBHelper() => _db;
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    return openDatabase(join(await getDatabasesPath(), 'diary_app_database.db'),
        version: 1, onCreate: (Database db, int version) async {
      Migration v1 = new V1Initialization();
      await db.transaction((txn) async {
        await v1.up(txn);
        // TOOD: 배포 이후에는 DB 스키마 변경 시, v1을 대체하는 게 아니라, v2를 만들어 줘야 함.
        // 그래야, v1 DB를 갖고 있는 사람과 v1을 받지 않은 사람 모두 동일한 스키마를 가질 수 있음.
      });
    });
  }
}
