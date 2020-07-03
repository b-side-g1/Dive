import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/record_has_emotion.dart';
import 'package:flutterapp/services/database/database_helper.dart';

class EmotionService {
  selectEmotionAllByRecordId(String recordId) async {
    final db = await DBHelper().database;
    var res = await db.query(RecordHasEmotion.tableName,
        where: 'recordId = ?', whereArgs: [recordId]);

    List<Emotion> emotions =
        res.isNotEmpty ? res.map((c) => Emotion.fromJson(c)).toList() : [];
    return emotions;
  }
}
