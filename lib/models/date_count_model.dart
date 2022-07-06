// To parse this JSON data, do
//
//     final dateCount = dateCountFromJson(jsonString);

import 'dart:convert';

class DateCount {
  DateCount({
    this.success,
    this.massage,
    this.data,
  });

  bool? success;
  String? massage;
  List<Datum>? data;

  factory DateCount.fromRawJson(String str) =>
      DateCount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DateCount.fromJson(Map<String, dynamic> json) => DateCount(
        success: json["success"] == null ? null : json["success"],
        massage: json["massage"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "massage": massage,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.startdate,
    this.enddate,
  });

  DateTime? startdate;
  DateTime? enddate;

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        startdate: json["startdate"] == null
            ? null
            : DateTime.parse(json["startdate"]),
        enddate:
            json["enddate"] == null ? null : DateTime.parse(json["enddate"]),
      );

  Map<String, dynamic> toJson() => {
        "startdate": startdate == null ? null : startdate!.toIso8601String(),
        "enddate": enddate == null ? null : enddate!.toIso8601String(),
      };
}
