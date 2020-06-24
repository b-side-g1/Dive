class Basic {
  static final tableName = 'basic';
  final String id;
  final DateTime today_startAt;
  final DateTime today_endAt;
  final String status;
  final bool is_push;
  final String uuid;
  final DateTime createdAt;

  // ignore: non_constant_identifier_names
  Basic(
      {this.id,
      this.today_startAt,
      this.today_endAt,
      this.status,
      this.is_push,
      this.uuid,
      this.createdAt});

  factory Basic.fromJson(Map<String, dynamic> json) => new Basic(
        id: json["id"],
        today_startAt: json["today_startAt"],
        today_endAt: json["today_endAt"],
        status: json["status"],
        is_push: json["is_push"],
        uuid: json["uuid"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "today_startAt": today_startAt,
        "today_endAt": today_endAt,
        "status": status,
        "is_push": is_push,
        "uuid": uuid,
        "createdAt": createdAt
      };
}
