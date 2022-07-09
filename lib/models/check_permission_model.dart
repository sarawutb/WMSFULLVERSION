// To parse this JSON data, do
//
//     final checkPermissions = checkPermissionsFromJson(jsonString);

import 'dart:convert';

class CheckPermissions {
  CheckPermissions({
    this.roworder,
    this.userCode,
    this.whCode,
    this.shelfCode,
    this.branchCode,
  });

  String? roworder;
  String? userCode;
  String? whCode;
  String? shelfCode;
  String? branchCode;

  factory CheckPermissions.fromRawJson(String str) =>
      CheckPermissions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CheckPermissions.fromJson(Map<String, dynamic> json) =>
      CheckPermissions(
        roworder: json["roworder"] == null ? null : json["roworder"],
        userCode: json["user_code"] == null ? null : json["user_code"],
        whCode: json["wh_code"] == null ? null : json["wh_code"],
        shelfCode: json["shelf_code"] == null ? null : json["shelf_code"],
        branchCode: json["branch_code"] == null ? null : json["branch_code"],
      );

  Map<String, dynamic> toJson() => {
        "roworder": roworder == null ? null : roworder,
        "user_code": userCode == null ? null : userCode,
        "wh_code": whCode == null ? null : whCode,
        "shelf_code": shelfCode == null ? null : shelfCode,
        "branch_code": branchCode == null ? null : branchCode,
      };
}
