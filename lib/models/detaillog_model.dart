// To parse this JSON data, do
//
//     final detailLog = detailLogFromJson(jsonString);

import 'dart:convert';

class DetailLog {
  DetailLog({
    this.roworder,
    this.no,
    this.countDate,
    this.countQty,
    this.userName,
    this.remark,
    this.location,
  });

  int? roworder;
  int? no;
  String? countDate;
  double? countQty;
  String? userName;
  String? remark;
  String? location;

  factory DetailLog.fromRawJson(String str) =>
      DetailLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailLog.fromJson(Map<String, dynamic> json) => DetailLog(
        roworder: json["roworder"] == null ? null : json["roworder"],
        no: json["no"] == null ? null : json["no"],
        countDate: json["count_date"] == null ? null : json["count_date"],
        countQty: json["count_qty"] == null ? null : json["count_qty"],
        userName: json["user_name"] == null ? null : json["user_name"],
        remark: json["remark"] == null ? null : json["remark"],
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "roworder": roworder == null ? null : roworder,
        "no": no == null ? null : no,
        "count_date": countDate == null ? null : countDate,
        "count_qty": countQty == null ? null : countQty,
        "user_name": userName == null ? null : userName,
        "remark": remark == null ? null : remark,
        "location": location == null ? null : location,
      };
}
