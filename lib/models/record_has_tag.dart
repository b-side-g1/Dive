class RecordHasTag {
  static final tableName = 'recordHasTag';
  final int idx;
  final String recordId;
  final String tagId;
  final String name;

  RecordHasTag({this.idx, this.recordId, this.tagId, this.name});

  factory RecordHasTag.fromJson(Map<String, dynamic> json) => new RecordHasTag(
        idx: json["idx"],
        recordId: json["recordId"],
        tagId: json["tagId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "idx": idx,
        "recordId": recordId,
        "tagId": tagId,
        "name": name,
      };
}
