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
        "SELECT t.id, t.name, t.createdAt, t.deletedAt FROM $recordHasTagTableName rht inner join $tagTableName t on rht.tagId = t.id where rht.recordId='$recordId'");

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

  Future<List<Tag>> selectStatisticsOfTags() async {
    final db = await DBHelper().database;

    var res = await db.rawQuery(
        "SELECT tagId as id,tag.name,COUNT(tagId) as count "
            "FROM ${Tag.tableName} "
        "INNER JOIN tag"
        "ON tag.id = recordHasTag.tagId"
        "WHERE tag.deletedAt is NULL"
        "GROUP BY tagId "
        "ORDER BY count DESC");

    List<Tag> tags =
    res.isNotEmpty ? res.map((c) => Tag.fromJson(c)).toList() : [];

    return tags;
  }



  Future<Tag> insertTag(Tag tag) async {
    final db = await DBHelper().database;

    await db.insert(Tag.tableName, tag.toJson());

    return tag;
  }

   Future<RecordHasTag>insertRecordHasTag(RecordHasTag recordHasTag) async {
    final db = await DBHelper().database;

    await db.insert(RecordHasTag.tableName, recordHasTag.toJson());

    return recordHasTag;
  }

  Future<Tag> deleteTag(Tag tag) async {
    final db = await DBHelper().database;
    final nowDate = DateTime.now().toString();
    await db.rawUpdate("UPDATE ${Tag.tableName} SET deletedAt = ? WHERE id = ?",[nowDate,tag.id]);

    return tag;
  }

  deleteRecordHasTagByRecordId(String recordId) async {
    final db = await DBHelper().database;
    await db.delete(RecordHasTag.tableName, where: 'recordId = ?', whereArgs: [recordId]);
  }
}
