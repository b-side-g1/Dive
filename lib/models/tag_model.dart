import 'package:flutterapp/models/record_model.dart';

class Tag {
  static final tableName = 'tag';
  final String id;
  final String name;
  final Record record;

  // ignore: non_constant_identifier_names
  Tag({this.id, this.name,this.record});

  factory Tag.fromJson(Map<String, dynamic> json) => new Tag(
    id: json["id"],
    name: json["name"],
    record: json["record"],
  );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "record": record};
}
