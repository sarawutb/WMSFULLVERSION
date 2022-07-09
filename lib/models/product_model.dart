import 'dart:convert';

class Product {
  Product({
    this.itemcode,
    this.itemname,
    this.itemType,
    this.unitcode,
    this.unitname,
    this.barcode,
    this.unitStandard,
    this.unitStandardName,
    this.isHoldPurchase,
    this.isHoldSale,
    this.gotoItem,
  });

  String? itemcode;
  String? itemname;
  int? itemType;
  String? unitcode;
  String? unitname;
  String? barcode;
  String? unitStandard;
  String? unitStandardName;
  int? isHoldPurchase;
  int? isHoldSale;
  dynamic gotoItem;

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        itemcode: json["itemcode"] == null ? null : json["itemcode"],
        itemname: json["itemname"] == null ? null : json["itemname"],
        itemType: json["item_type"] == null ? null : json["item_type"],
        unitcode: json["unitcode"] == null ? null : json["unitcode"],
        unitname: json["unitname"] == null ? null : json["unitname"],
        barcode: json["barcode"] == null ? null : json["barcode"],
        unitStandard:
            json["unit_standard"] == null ? null : json["unit_standard"],
        unitStandardName: json["unit_standard_name"] == null
            ? null
            : json["unit_standard_name"],
        isHoldPurchase:
            json["is_hold_purchase"] == null ? null : json["is_hold_purchase"],
        isHoldSale: json["is_hold_sale"] == null ? null : json["is_hold_sale"],
        gotoItem: json["goto_item"],
      );

  Map<String, dynamic> toJson() => {
        "itemcode": itemcode == null ? null : itemcode,
        "itemname": itemname == null ? null : itemname,
        "item_type": itemType == null ? null : itemType,
        "unitcode": unitcode == null ? null : unitcode,
        "unitname": unitname == null ? null : unitname,
        "barcode": barcode == null ? null : barcode,
        "unit_standard": unitStandard == null ? null : unitStandard,
        "unit_standard_name":
            unitStandardName == null ? null : unitStandardName,
        "is_hold_purchase": isHoldPurchase == null ? null : isHoldPurchase,
        "is_hold_sale": isHoldSale == null ? null : isHoldSale,
        "goto_item": gotoItem,
      };
}
