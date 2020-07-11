class RecordHasEmotion {
  static final tableName = 'recordHasEmotion';
  final int idx;
  final String recordId;
  final String emotionId;
  final String name;

  RecordHasEmotion({this.idx, this.recordId, this.emotionId, this.name});

  factory RecordHasEmotion.fromJson(Map<String, dynamic> json) =>
      new RecordHasEmotion(
        idx: json["idx"],
        recordId: json["recordId"],
        emotionId: json["emotionId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() =>
      {"idx": idx, "recordId": recordId, "emotionId": emotionId, "name": name,};
}