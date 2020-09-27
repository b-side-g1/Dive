import 'package:sqflite/sqflite.dart';

abstract class Migration {
  int migrationVersion;

  Future<void> up(Transaction txn) async {
    throw UnimplementedError();
  }

  Future<void> down(Transaction txn) async {
    throw UnimplementedError();
  }
}
