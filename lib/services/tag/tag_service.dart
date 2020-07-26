import 'package:flutterapp/models/record_has_tag.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class TagService {
  final String recordHasTagTableName = RecordHasTag.tableName;
  final String tagTableName = Tag.tableName;

  Future<List<Tag>> selectTagAllByRecordId(String recordId) async {
    final db = await DBHelper().database;
//    var res = await db.query(RecordHasTag.tableName,
//        where: 'recordId = ?', whereArgs: [recordId]);

    var res = await db.rawQuery(
        "SELECT t.id, t.name, t.createdAt, t.deletedAt FROM $recordHasTagTableName rht inner join $tagTableName t on rht.tagId = t.id where rht.recordId=$recordId");

    List<Tag> tags =
        res.isNotEmpty ? res.map((c) => Tag.fromJson(c)).toList() : [];
    return tags;
  }

  Future<List<Tag>> selectAllTags() async {
    final db = await DBHelper().database;

    var res = await db.rawQuery("SELECT * FROM ${Tag.tableName} WHERE deletedAt is NULL");

    List<Tag> tags =
        res.isNotEmpty ? res.map((c) => Tag.fromJson(c)).toList() : [];

    return tags;
  }

  Future<Tag> insertTag(Tag tag) async {
    final db = await DBHelper().database;

    await db.insert(Tag.tableName, tag.toJson());

    return tag;
  }

  Future<Tag> deleteTag(Tag tag) async {
    final db = await DBHelper().database;
    final nowDate = DateTime.now().toString();
    await db.rawUpdate("UPDATE ${Tag.tableName} SET deletedAt = ? WHERE id = ?",[nowDate,tag.id]);

    return tag;
  }
}
