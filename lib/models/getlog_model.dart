// To parse this JSON data, do
//
//     final getLog = getLogFromJson(jsonString);

import 'dart:convert';

class GetLog {
  GetLog({
    this.itemCode,
    this.location,
    this.countStep,
  });

  String? itemCode;
  String? location;
  int? countStep;

  factory GetLog.fromRawJson(String str) => GetLog.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetLog.fromJson(Map<String, dynamic> json) => GetLog(
        itemCode: json["itemCode"] == null ? null : json["itemCode"],
        location: json["location"] == null ? null : json["location"],
        countStep: json["countStep"] == null ? null : json["countStep"],
      );

  Map<String, dynamic> toJson() => {
        "itemCode": itemCode == null ? null : itemCode,
        "location": location == null ? null : location,
        "countStep": countStep == null ? null : countStep,
      };
}
