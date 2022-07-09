// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class User {
  User({
    this.fullName,
    this.userId,
    this.password,
    this.userGroup,
    this.userGroupName,
    this.token,
    this.signature,
    this.isChangeBranch,
    this.branchList,
    this.shelf,
    this.sessionId,
    this.wmsWh,
    this.wmsBranch,
  });

  String? fullName;
  String? userId;
  dynamic password;
  String? userGroup;
  String? userGroupName;
  String? token;
  String? signature;
  bool? isChangeBranch;
  List<BranchList>? branchList;
  List<Shelf>? shelf;
  String? sessionId;
  String? wmsWh;
  String? wmsBranch;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        fullName: json["fullName"] ?? null,
        userId: json["userId"] ?? null,
        password: json["password"],
        userGroup: json["userGroup"] ?? null,
        userGroupName: json["userGroupName"] ?? null,
        token: json["token"] ?? null,
        signature: json["signature"] ?? null,
        isChangeBranch: json["isChangeBranch"] ?? null,
        branchList: json["branchList"] == null
            ? null
            : List<BranchList>.from(
                json["branchList"].map((x) => BranchList.fromJson(x))),
        shelf: json["shelf"] == null
            ? null
            : List<Shelf>.from(json["shelf"].map((x) => Shelf.fromJson(x))),
        sessionId: json["sessionId"] == null ? null : json["sessionId"],
        wmsWh: json["wmS_WH"] == null ? null : json["wmS_WH"],
        wmsBranch: json["wmS_Branch"] == null ? null : json["wmS_Branch"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName ?? null,
        "userId": userId ?? null,
        "password": password,
        "userGroup": userGroup ?? null,
        "userGroupName": userGroupName ?? null,
        "token": token ?? null,
        "signature": signature ?? null,
        "isChangeBranch": isChangeBranch ?? null,
        "branchList": branchList == null
            ? null
            : List<dynamic>.from(branchList!.map((x) => x.toJson())),
        "shelf": shelf == null
            ? null
            : List<dynamic>.from(shelf!.map((x) => x.toJson())),
        "sessionId": sessionId == null ? null : sessionId,
      };
}

class BranchList {
  BranchList({
    this.branchCode,
    this.branchname,
  });

  String? branchCode;
  String? branchname;

  factory BranchList.fromRawJson(String str) =>
      BranchList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BranchList.fromJson(Map<String, dynamic> json) => BranchList(
        branchCode: json["branchCode"] ?? null,
        branchname: json["branchname"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "branchCode": branchCode ?? null,
        "branchname": branchname ?? null,
      };
}

class Shelf {
  Shelf({
    this.shelf,
  });

  String? shelf;

  factory Shelf.fromRawJson(String str) => Shelf.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shelf.fromJson(Map<String, dynamic> json) => Shelf(
        shelf: json["shelf"] ?? null,
      );

  Map<String, dynamic> toJson() => {
        "shelf": shelf ?? null,
      };
}
