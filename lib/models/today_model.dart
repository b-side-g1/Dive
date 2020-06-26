class Today {
  static final tableName = 'today';
  final String id;
  final DateTime date;

  // ignore: non_constant_identifier_names
  Today({this.id, this.date});

  factory Today.fromJson(Map<String, dynamic> json) => new Today(
        id: json["id"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {"id": id, "date": date};
}
