import 'package:flutterapp/models/record_model.dart';

class Emotion {
  static final tableName = 'emotion';
  final String id;
  final String name;

  // ignore: non_constant_identifier_names
  Emotion({this.id, this.name,});

  factory Emotion.fromJson(Map<String, dynamic> json) => new Emotion(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name,};
}
