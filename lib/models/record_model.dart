class Record {
  static final tableName = 'Record';

  final String id;
  final int score;
  final String description;

  Record({this.id, this.score, this.description});

  factory Record.fromJson(Map<String,dynamic> json) => new Record(
    id: json["id"],
    score: json["score"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => { "id": id, "score": score, "description": description };
}