import 'package:flutterapp/models/record_model.dart';

class Tag {
  static final tableName = 'tag';
  final String id;
  final String name;

  // ignore: non_constant_identifier_names
  Tag({this.id, this.name});

  factory Tag.fromJson(Map<String, dynamic> json) => new Tag(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name,};
}
