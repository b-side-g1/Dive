import 'package:flutterapp/models/today_model.dart';

class Record {
  static final tableName = 'record';

  final String id;
  final int score;
  final String description;
  final Today today;

  Record({this.id, this.score, this.description, this.today});

  factory Record.fromJson(Map<String, dynamic> json) => new Record(
        id: json["id"],
        score: json["score"],
        description: json["description"],
        today: json["today"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "score": score,
        "description": description,
        "today": today,
      };
}
