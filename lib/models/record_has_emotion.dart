class RecordHasEmotion {
  static final tableName = 'recordHasEmotion';
  final int idx;
  final String recordId;
  final String emotionId;
  final String createdAt;

  RecordHasEmotion({this.idx, this.recordId, this.emotionId, this.createdAt});

  factory RecordHasEmotion.fromJson(Map<String, dynamic> json) =>
      new RecordHasEmotion(
        idx: json["idx"],
        recordId: json["recordId"],
        emotionId: json["emotionId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() =>
      {"idx": idx, "recordId": recordId, "emotionId": emotionId,
        "createdAt": createdAt};
}