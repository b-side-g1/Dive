class RecordHasTag {
  static final tableName = 'recordHasTag';
  final int idx;
  final String recordId;
  final String tagId;
  final String createdAt;

  RecordHasTag({this.idx, this.recordId, this.tagId, this.createdAt});

  factory RecordHasTag.fromJson(Map<String, dynamic> json) => new RecordHasTag(
        idx: json["idx"],
        recordId: json["recordId"],
        tagId: json["tagId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "recordId": recordId,
        "tagId": tagId,
        "createdAt": createdAt
      };
}
