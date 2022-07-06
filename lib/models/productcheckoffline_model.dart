// To parse this JSON data, do
//
//     final ProductCheckOffline = ProductCheckOfflineFromJson(jsonString);

import 'dart:convert';

class ProductCheckOffline {
  ProductCheckOffline({
    this.barcode,
    this.itemCode,
    this.itemName,
    this.unitCode,
    this.unitName,
    this.itemCategory,
    this.location,
  });

  String? barcode;
  String? itemCode;
  String? itemName;
  String? unitCode;
  String? unitName;
  String? itemCategory;
  String? location;

  factory ProductCheckOffline.fromRawJson(String str) =>
      ProductCheckOffline.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductCheckOffline.fromJson(Map<String, dynamic> json) =>
      ProductCheckOffline(
        barcode: json["barcode"] == null ? null : json["barcode"],
        itemCode: json["item_code"] == null ? null : json["item_code"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        unitName: json["unit_name"] == null ? null : json["unit_name"],
        itemCategory:
            json["item_category"] == null ? null : json["item_category"],
        location: json["location"] == null ? null : json["location"],
      );

  Map<String, dynamic> toJson() => {
        "barcode": barcode == null ? null : barcode,
        "item_code": itemCode == null ? null : itemCode,
        "item_name": itemName == null ? null : itemName,
        "unit_code": unitCode == null ? null : unitCode,
        "unit_name": unitName == null ? null : unitName,
        "item_category": itemCategory == null ? null : itemCategory,
        "location": location == null ? null : location,
      };
}
