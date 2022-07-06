// To parse this JSON data, do
//
//     final detailProduct = detailProductFromJson(jsonString);

import 'dart:convert';

class DetailProduct {
  DetailProduct({
    this.itemCode,
    this.itemName,
    this.itemType,
    this.unitCode,
    this.unitName,
    this.dim8,
    this.dim12,
    this.colorStatus,
    this.isHoldSale,
    this.isHoldPurchase,
    this.minStk,
    this.maxStk,
    this.barcodes,
    this.price,
    this.stock,
    this.location,
  });

  String? itemCode;
  String? itemName;
  String? itemType;
  String? unitCode;
  String? unitName;
  String? dim8;
  dynamic dim12;
  String? colorStatus;
  String? isHoldSale;
  String? isHoldPurchase;
  String? minStk;
  String? maxStk;
  List<Barcode>? barcodes;
  List<Price>? price;
  List<Stock>? stock;
  List<String>? location;

  factory DetailProduct.fromRawJson(String str) =>
      DetailProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DetailProduct.fromJson(Map<String, dynamic> json) => DetailProduct(
        itemCode: json["itemCode"] == null ? null : json["itemCode"],
        itemName: json["itemName"] == null ? null : json["itemName"],
        itemType: json["itemType"] == null ? null : json["itemType"],
        unitCode: json["unitCode"] == null ? null : json["unitCode"],
        unitName: json["unitName"] == null ? null : json["unitName"],
        dim8: json["dim8"] == null ? null : json["dim8"],
        dim12: json["dim12"],
        colorStatus: json["colorStatus"] == null ? null : json["colorStatus"],
        isHoldSale: json["isHoldSale"] == null ? null : json["isHoldSale"],
        isHoldPurchase:
            json["isHoldPurchase"] == null ? null : json["isHoldPurchase"],
        minStk: json["minStk"] == null ? null : json["minStk"],
        maxStk: json["maxStk"] == null ? null : json["maxStk"],
        barcodes: json["barcodes"] == null
            ? null
            : List<Barcode>.from(
                json["barcodes"].map((x) => Barcode.fromJson(x))),
        price: json["price"] == null
            ? null
            : List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
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
        "itemType": itemType == null ? null : itemType,
        "unitCode": unitCode == null ? null : unitCode,
        "unitName": unitName == null ? null : unitName,
        "dim8": dim8 == null ? null : dim8,
        "dim12": dim12,
        "colorStatus": colorStatus == null ? null : colorStatus,
        "isHoldSale": isHoldSale == null ? null : isHoldSale,
        "isHoldPurchase": isHoldPurchase == null ? null : isHoldPurchase,
        "minStk": minStk == null ? null : minStk,
        "maxStk": maxStk == null ? null : maxStk,
        "barcodes": barcodes == null
            ? null
            : List<dynamic>.from(barcodes!.map((x) => x.toJson())),
        "price": price == null
            ? null
            : List<dynamic>.from(price!.map((x) => x.toJson())),
        "stock": stock == null
            ? null
            : List<dynamic>.from(stock!.map((x) => x.toJson())),
        "location": location == null
            ? null
            : List<dynamic>.from(location!.map((x) => x)),
      };
}

class Barcode {
  Barcode({
    this.barcode,
    this.unitCode,
    this.unitName,
    this.ratio,
  });

  String? barcode;
  String? unitCode;
  String? unitName;
  String? ratio;

  factory Barcode.fromRawJson(String str) => Barcode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        barcode: json["barcode"] == null ? null : json["barcode"],
        unitCode: json["unitCode"] == null ? null : json["unitCode"],
        unitName: json["unitName"] == null ? null : json["unitName"],
        ratio: json["ratio"] == null ? null : json["ratio"],
      );

  Map<String, dynamic> toJson() => {
        "barcode": barcode == null ? null : barcode,
        "unitCode": unitCode == null ? null : unitCode,
        "unitName": unitName == null ? null : unitName,
        "ratio": ratio == null ? null : ratio,
      };
}

class Price {
  Price({
    this.unitCode,
    this.price,
    this.isPromotion,
    this.updateDate,
    this.dateBegin,
    this.dateEnd,
    this.secDiff,
    this.endSecDiff,
    this.labelPrice,
    this.labelUnit,
    this.priceMatch,
    this.unitMatch,
  });

  String? unitCode;
  String? price;
  String? isPromotion;
  String? updateDate;
  String? dateBegin;
  String? dateEnd;
  String? secDiff;
  String? endSecDiff;
  dynamic labelPrice;
  dynamic labelUnit;
  bool? priceMatch;
  bool? unitMatch;

  factory Price.fromRawJson(String str) => Price.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        unitCode: json["unitCode"] == null ? null : json["unitCode"],
        price: json["price"] == null ? null : json["price"],
        isPromotion: json["isPromotion"] == null ? null : json["isPromotion"],
        updateDate: json["updateDate"] == null ? null : json["updateDate"],
        dateBegin: json["dateBegin"] == null ? null : json["dateBegin"],
        dateEnd: json["dateEnd"] == null ? null : json["dateEnd"],
        secDiff: json["secDiff"] == null ? null : json["secDiff"],
        endSecDiff: json["endSecDiff"] == null ? null : json["endSecDiff"],
        labelPrice: json["labelPrice"],
        labelUnit: json["labelUnit"],
        priceMatch: json["priceMatch"] == null ? null : json["priceMatch"],
        unitMatch: json["unitMatch"] == null ? null : json["unitMatch"],
      );

  Map<String, dynamic> toJson() => {
        "unitCode": unitCode == null ? null : unitCode,
        "price": price == null ? null : price,
        "isPromotion": isPromotion == null ? null : isPromotion,
        "updateDate": updateDate == null ? null : updateDate,
        "dateBegin": dateBegin == null ? null : dateBegin,
        "dateEnd": dateEnd == null ? null : dateEnd,
        "secDiff": secDiff == null ? null : secDiff,
        "endSecDiff": endSecDiff == null ? null : endSecDiff,
        "labelPrice": labelPrice,
        "labelUnit": labelUnit,
        "priceMatch": priceMatch == null ? null : priceMatch,
        "unitMatch": unitMatch == null ? null : unitMatch,
      };
}

class Stock {
  Stock({
    this.branchCode,
    this.locationIndex,
    this.locationCode,
    this.balanceQty,
    this.cost,
    this.reservedQty,
    this.availableQty,
  });

  String? branchCode;
  dynamic locationIndex;
  String? locationCode;
  String? balanceQty;
  dynamic cost;
  String? reservedQty;
  String? availableQty;

  factory Stock.fromRawJson(String str) => Stock.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        branchCode: json["branchCode"] == null ? null : json["branchCode"],
        locationIndex: json["locationIndex"],
        locationCode:
            json["locationCode"] == null ? null : json["locationCode"],
        balanceQty: json["balanceQty"] == null ? null : json["balanceQty"],
        cost: json["cost"],
        reservedQty: json["reservedQty"] == null ? null : json["reservedQty"],
        availableQty:
            json["availableQty"] == null ? null : json["availableQty"],
      );

  Map<String, dynamic> toJson() => {
        "branchCode": branchCode == null ? null : branchCode,
        "locationIndex": locationIndex,
        "locationCode": locationCode == null ? null : locationCode,
        "balanceQty": balanceQty == null ? null : balanceQty,
        "cost": cost,
        "reservedQty": reservedQty == null ? null : reservedQty,
        "availableQty": availableQty == null ? null : availableQty,
      };
}
