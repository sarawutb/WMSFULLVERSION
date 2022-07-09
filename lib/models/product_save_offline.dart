// To parse this JSON data, do
//
//     final ProductsSaveOffline = ProductsSaveOfflineFromJson(jsonString);

import 'dart:convert';

class ProductsSaveOffline {
  ProductsSaveOffline({
    this.itemCode,
    this.itemName,
    this.unitStandard,
    this.unitStandardName,
    this.currentCountStep,
    this.currentCountStepDesc,
    this.matchQty,
    this.recountRoworder,
    this.stock,
    this.location,
  });

  String? itemCode;
  String? itemName;
  String? unitStandard;
  String? unitStandardName;
  String? currentCountStep;
  String? currentCountStepDesc;
  String? matchQty;
  String? recountRoworder;
  List<Stock>? stock;
  List<String>? location;

  factory ProductsSaveOffline.fromRawJson(String str) =>
      ProductsSaveOffline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductsSaveOffline.fromJson(Map<String, dynamic> json) =>
      ProductsSaveOffline(
        itemCode: json["itemCode"] == null ? null : json["itemCode"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        unitStandard:
            json["unitStandard"] == null ? null : json["unitStandard"],
        unitStandardName:
            json["unitStandardName"] == null ? null : json["unitStandardName"],
        currentCountStep:
            json["currentCountStep"] == null ? null : json["currentCountStep"],
        currentCountStepDesc: json["currentCountStepDesc"] == null
            ? null
            : json["currentCountStepDesc"],
        matchQty: json["matchQty"] == null ? null : json["matchQty"],
        recountRoworder:
            json["recountRoworder"] == null ? null : json["recountRoworder"],
        stock: json["stock"] == null
            ? null
            : List<Stock>.from(json["stock"].map((x) => Stock.fromJson(x))),
        location: json["location"] == null
            ? null
            : List<String>.from(json["location"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "itemCode": itemCode == null ? null : itemCode,
        "itemName": itemName == null ? null : itemName,
        "unitStandard": unitStandard == null ? null : unitStandard,
        "unitStandardName": unitStandardName == null ? null : unitStandardName,
        "currentCountStep": currentCountStep == null ? null : currentCountStep,
        "currentCountStepDesc":
            currentCountStepDesc == null ? null : currentCountStepDesc,
        "matchQty": matchQty == null ? null : matchQty,
        "recountRoworder": recountRoworder == null ? null : recountRoworder,
        "stock": stock == null
            ? null
            : List<dynamic>.from(stock!.map((x) => x.toJson())),
        "location": location == null
            ? null
            : List<dynamic>.from(location!.map((x) => x)),
      };
}

class Stock {
  Stock({
    this.branchCode,
    this.locationIndex,
    this.locationCode,
    this.balanceQty,
    this.cost,
  });

  String? branchCode;
  String? locationIndex;
  String? locationCode;
  String? balanceQty;
  String? cost;

  factory Stock.fromRawJson(String str) => Stock.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        branchCode: json["branchCode"] == null ? null : json["branchCode"],
        locationIndex:
            json["locationIndex"] == null ? null : json["locationIndex"],
        locationCode:
            json["locationCode"] == null ? null : json["locationCode"],
        balanceQty: json["balanceQty"] == null ? null : json["balanceQty"],
        cost: json["cost"] == null ? null : json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "branchCode": branchCode == null ? null : branchCode,
        "locationIndex": locationIndex == null ? null : locationIndex,
        "locationCode": locationCode == null ? null : locationCode,
        "balanceQty": balanceQty == null ? null : balanceQty,
        "cost": cost == null ? null : cost,
      };
}
