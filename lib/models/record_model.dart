import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/models/today_model.dart';

class Record {
  static final tableName = 'record';

  final String id;
  final int score;
  final String description;
  final Today today;
  final List<Tag> tags;
  final List<Emotion> emotions;

  Record(
      {this.id,
      this.score,
      this.description,
      this.today,
      this.tags,
      this.emotions});

  factory Record.fromJson(Map<String, dynamic> json) => new Record(
        id: json["id"],
        score: json["score"],
        description: json["description"],
        today: json["today"],
        tags: json["tags"],
        emotions: json["emotions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "score": score,
        "description": description,
        "today": today,
        "tags": tags,
        "emotions": emotions,
      };
}
