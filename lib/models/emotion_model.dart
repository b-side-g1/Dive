import 'package:Dive/models/record_model.dart';

class Emotion {
  static final tableName = 'emotion';
  final String id;
  final String name;
  final String createdAt;
  final String deletedAt;

  // ignore: non_constant_identifier_names
  Emotion({this.id, this.name, this.createdAt, this.deletedAt});

  factory Emotion.fromJson(Map<String, dynamic> json) => new Emotion(
    id: json["id"],
    name: json["name"],
    createdAt: json["createdAt"],
    deletedAt: json["deletedAt"]
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "createdAt": createdAt ,"deletedAt": deletedAt};
}