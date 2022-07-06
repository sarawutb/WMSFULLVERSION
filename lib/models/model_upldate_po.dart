// To parse this JSON data, do
//
//     final modelUpdatePo = modelUpdatePoFromJson(jsonString);

import 'dart:convert';

class ModelUpdatePo {
  ModelUpdatePo({
    this.roworder,
    this.docNo,
    this.docDate,
    this.lasteditDatetime,
    this.createDateTimeNow,
    this.status,
    this.isPrint,
    this.ppDocNo,
    this.whCode,
    this.shelfCode,
    this.saleCode,
    this.lastStatus,
  });

  String? roworder;
  String? docNo;
  DateTime? docDate;
  DateTime? lasteditDatetime;
  DateTime? createDateTimeNow;
  int? status;
  int? isPrint;
  String? ppDocNo;
  String? whCode;
  String? shelfCode;
  String? saleCode;
  String? lastStatus;

  factory ModelUpdatePo.fromRawJson(String str) =>
      ModelUpdatePo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ModelUpdatePo.fromJson(Map<String, dynamic> json) => ModelUpdatePo(
        roworder: json["roworder"] == null ? null : json["roworder"],
        docNo: json["doc_no"] == null ? null : json["doc_no"],
        docDate:
            json["doc_date"] == null ? null : DateTime.parse(json["doc_date"]),
        lasteditDatetime: json["lastedit_datetime"] == null
            ? null
            : DateTime.parse(json["lastedit_datetime"]),
        createDateTimeNow: json["create_date_time_now"] == null
            ? null
            : DateTime.parse(json["create_date_time_now"]),
        status: json["status"] == null ? null : json["status"],
        isPrint: json["is_print"] == null ? null : json["is_print"],
        ppDocNo:
            json["pp_doc_no"] == null ? null : json["pp_doc_no"].toString(),
        whCode: json["wh_code"] == null ? null : json["wh_code"].toString(),
        shelfCode:
            json["shelf_code"] == null ? null : json["shelf_code"].toString(),
        saleCode:
            json["sale_code"] == null ? null : json["sale_code"].toString(),
        lastStatus:
            json["last_status"] == null ? null : json["last_status"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "roworder": roworder == null ? null : roworder,
        "doc_no": docNo == null ? null : docNo,
        "doc_date": docDate == null ? null : docDate!.toIso8601String(),
        "lastedit_datetime": lasteditDatetime == null
            ? null
            : lasteditDatetime!.toIso8601String(),
        "create_date_time_now": createDateTimeNow == null
            ? null
            : createDateTimeNow!.toIso8601String(),
        "status": status == null ? null : status,
        "is_print": isPrint == null ? null : isPrint,
        "pp_doc_no": ppDocNo,
        "wh_code": whCode,
        "shelf_code": shelfCode,
        "sale_code": saleCode,
        "last_status": lastStatus,
      };
}
