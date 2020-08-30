import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_has_emotion.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class EmotionService {
  final String recordHasEmotionTableName = RecordHasEmotion.tableName;
  final String emotionTableName = Emotion.tableName;

  Future<List<Emotion>> selectEmotionAllByRecordId(String recordId) async {
    final db = await DBHelper().database;
//    var res = await db.query(RecordHasEmotion.tableName,
//        where: 'recordId = ?', whereArgs: [recordId]);

    var res = await db.rawQuery("SELECT e.id, e.name, e.createdAt, e.deletedAt FROM $recordHasEmotionTableName rhe inner join $emotionTableName e on rhe.emotionId = e.id where rhe.recordId='$recordId'");

    List<Emotion> emotions =
        res.isNotEmpty ? res.map((c) => Emotion.fromJson(c)).toList() : [];
    return emotions;
  }

  Future<RecordHasEmotion>insertRecordHasEmotion(RecordHasEmotion recordHasEmotion) async {
    final db = await DBHelper().database;

    await db.insert(RecordHasEmotion.tableName, recordHasEmotion.toJson());

    return recordHasEmotion;
  }


  deleteRecordHasEmotionByRecordId(String recordId) async {
    final db = await DBHelper().database;
    await db.delete(RecordHasEmotion.tableName, where: 'recordId = ?', whereArgs: [recordId]);
  }
}
