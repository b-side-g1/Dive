class Daily {
  static final tableName = 'daily';
  final String id;
  final int startTimestamp;
  final int endTimestamp;
  final String startAt;
  final String endAt;
  final int weekday; // 1: 월요일 ~ 일요일
  final int day;
  final int week;
  final int month;
  final int year;

  // ignore: non_constant_identifier_names
  Daily({this.id, this.startTimestamp, this.endTimestamp, this.startAt, this.endAt, this.weekday, this.day, this.week, this.month,
      this.year});

  factory Daily.fromJson(Map<String, dynamic> json) => new Daily(
      id: json["id"],
      startTimestamp: json["startTimestamp"],
      endTimestamp: json["endTimestamp"],
      startAt: json["startAt"],
      endAt: json["endAt"],
      weekday: json["weekday"],
      day: json["day"],
      week: json["week"],
      month: json["month"],
      year: json["year"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTimestamp": startTimestamp,
        "endTimestamp": endTimestamp,
        "startAt": startAt,
        "endAt": endAt,
        "weekday": weekday,
        "day": day,
        "week": week,
        "month": month,
        "year": year
      };
}
