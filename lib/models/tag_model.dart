class Tag {
  static final tableName = 'tag';
  final String id;
  final String name;
  final String createdAt;
  final String deletedAt;

  // ignore: non_constant_identifier_names
  Tag({this.id, this.name, this.createdAt, this.deletedAt});

  factory Tag.fromJson(Map<String, dynamic> json) => new Tag(
      id: json["id"],
      name: json["name"],
      createdAt: json["createdAt"],
      deletedAt: json["deletedAt"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "createdAt": createdAt ,"deletedAt": deletedAt};
}
