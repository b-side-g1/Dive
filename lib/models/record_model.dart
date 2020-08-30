import 'package:flutterapp/models/emotion_model.dart';
import 'package:flutterapp/models/tag_model.dart';
import 'package:flutterapp/models/daily_model.dart';

class Record {
  static final tableName = 'record';

  final String id;
  final int score;
  final String description;
  final String dailyId;
  final String updatedAt;
  final String createdAt;
  final int createdTimestamp;
  Daily daily;
  List<Tag> tags;
  List<Emotion> emotions;

  Record(
      {this.id,
      this.score,
      this.description,
      this.dailyId,
      this.updatedAt,
      this.createdAt,
      this.createdTimestamp,
      this.daily,
      this.tags,
      this.emotions});

  factory Record.fromJson(Map<String, dynamic> json) => new Record(
        id: json["id"],
        score: json["score"],
        description: json["description"],
        dailyId: json["dailyId"],
        updatedAt: json["updatedAt"],
        createdAt: json["createdAt"],
        createdTimestamp: json["createdTimestamp"],
        daily: json["daily"],
        tags: json["tags"],
        emotions: json["emotions"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "score": score,
        "description": description,
        "dailyId": dailyId ,
        "updatedAt": updatedAt ,
        "createdAt": createdAt ,
        "createdTimestamp": createdTimestamp,
        "daily": daily,
        "tags": tags,
        "emotions": emotions,
      };

  Map<String, dynamic> toTableJson() => {
    "id": id,
    "score": score,
    "description": description,
    "dailyId": dailyId ,
    "updatedAt": updatedAt ,
    "createdAt": createdAt ,
    "createdTimestamp": createdTimestamp ,
//    "daily": daily,
//    "tags": tags,
//    "emotions": emotions,
  };
}
