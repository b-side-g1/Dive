import 'package:flutterapp/models/record_has_tag.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class TagService {
  selectTagAllByRecordId(String recordId) async {
    final db = await DBHelper().database;
    var res = await db.query(RecordHasTag.tableName,
        where: 'recordId = ?', whereArgs: [recordId]);

    List<Tag> tags =
        res.isNotEmpty ? res.map((c) => Tag.fromJson(c)).toList() : [];
    return tags;
  }
}
