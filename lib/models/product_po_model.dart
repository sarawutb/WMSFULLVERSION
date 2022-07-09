import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wms/models/podetail.dart';

class ProductPo {
  ProductPo({
    this.custCode,
    this.arName,
    this.itemDetail,
    this.boolcheckBox = false,
    this.date,
    this.invoiceNumber,
    this.description,
    this.dateReceive,
    this.index,
    this.listdetail,
  });

  String? custCode;
  String? arName;
  bool boolcheckBox;
  List<ItemDetail>? itemDetail;
  DateTime? date;
  String? invoiceNumber;
  String? description;
  DateTime? dateReceive;
  int? index;
  List<PoDetail>? listdetail;
  factory ProductPo.fromRawJson(String str) =>
      ProductPo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductPo.fromJson(Map<String, dynamic> json) => ProductPo(
        custCode: json["cust_code"] == null ? null : json["cust_code"],
        arName: json["ar_name"] == null ? null : json["ar_name"],
        dateReceive: json["date_receive"] == null
            ? null
            : DateTime.parse(json["date_receive"]),
        itemDetail: json["item_detail"] == null
            ? null
            : List<ItemDetail>.from(
                json["item_detail"].map((x) => ItemDetail.fromJson(x))),
        date: DateTime.now(),
        invoiceNumber: '',
        // listdetail: List<PoDetail>.from(
        //         json["item_detail"].map((x) => PoDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cust_code": custCode == null ? null : custCode,
        "ar_name": arName == null ? null : arName,
        "item_detail": itemDetail == null
            ? null
            : List<dynamic>.from(itemDetail!.map((x) => x.toJson())),
        "list_detail": listdetail == null
            ? null
            : List<dynamic>.from(listdetail!.map((x) => x.toJson())),
      };
}

class ItemDetail {
  ItemDetail({
    this.vatCode,
    this.vatType,
    this.docNo,
    this.lastStatus,
    this.detail,
    this.status = 0,
    this.departmentName,
    this.departmentCode,
    this.hideList = true,
    this.remark,
    this.index,
  });

  int? vatCode;
  String? vatType;
  String? docNo;
  int? lastStatus;
  List<Detail>? detail;
  int status;
  String? departmentName;
  String? departmentCode;
  bool hideList;
  TextEditingController? remark;
  int? index;
  factory ItemDetail.fromRawJson(String str) =>
      ItemDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
      vatCode: json["vat_code"] == null ? null : json["vat_code"],
      vatType: json["vat_type"] == null ? null : json["vat_type"],
      docNo: json["doc_no"] == null ? null : json["doc_no"],
      departmentName:
          json["department_name"] == null ? null : json["department_name"],
      departmentCode:
          json["department_code"] == null ? null : json["department_code"],
      lastStatus: json["last_status"] == null ? null : json["last_status"],
      detail: json["detail"] == null
          ? null
          : List<Detail>.from(
              json["detail"].map((x) {
                return Detail.fromJson(x);
              }),
            ),
      remark: json["remark"] == null
          ? TextEditingController()
          : TextEditingController(text: json["remark"].toString()));

  Map<String, dynamic> toJson() => {
        "vat_type": vatType == null ? null : vatType,
        "vat_code": vatCode == null ? null : vatCode,
        "doc_no": docNo == null ? null : docNo,
        "last_status": lastStatus == null ? null : lastStatus,
        "remark": remark == null ? null : remark,
        "index": index == null ? null : index,
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class Detail {
  Detail(
      {this.docNo,
      this.lastStatus,
      this.lineNumber,
      this.itemCode,
      this.itemName,
      this.unitCode,
      this.unitName,
      this.whCode,
      this.shelfCode,
      this.shelfName,
      this.qty,
      this.price,
      this.discount,
      this.sumAmount,
      this.barcode,
      this.colorStatusVat = Colors.green,
      this.qtyCheck,
      this.statusSuccess = false,
      this.found = false,
      this.index,
      this.remarkDetail});

  String? docNo;
  int? lastStatus;
  int? lineNumber;
  String? itemCode;
  String? itemName;
  String? unitCode;
  String? unitName;
  String? whCode;
  String? shelfCode;
  String? shelfName;
  int? qty;
  int? qtyCheck;
  double? price;
  String? discount;
  double? sumAmount;
  List<Barcode>? barcode;
  Color colorStatusVat;
  bool statusSuccess;
  bool found;
  int? index;
  String? remarkDetail;
  factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        docNo: json["doc_no"] == null ? null : json["doc_no"],
        lastStatus: json["last_status"] == null ? null : json["last_status"],
        lineNumber: json["line_number"] == null ? null : json["line_number"],
        itemCode: json["item_code"] == null ? null : json["item_code"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        unitName: json["unit_name"] == null ? null : json["unit_name"],
        whCode: json["wh_code"] == null ? null : json["wh_code"],
        shelfCode: json["shelf_code"] == null ? null : json["shelf_code"],
        shelfName: json["shelf_name"] == null ? null : json["shelf_name"],
        qty: json["qty"] == null ? null : json["qty"],
        price: json["price"] == null ? null : json["price"].toDouble(),
        discount: json["discount"] == null ? null : json["discount"],
        sumAmount:
            json["sum_amount"] == null ? null : json["sum_amount"].toDouble(),
        barcode: json["bar_code"] == null
            ? null
            : List<Barcode>.from(
                json["bar_code"].map((x) => Barcode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doc_no": docNo == null ? null : docNo,
        "last_status": lastStatus == null ? null : lastStatus,
        "line_number": lineNumber == null ? null : lineNumber,
        "item_code": itemCode == null ? null : itemCode,
        "item_name": itemName == null ? null : itemName,
        "unit_code": unitCode == null ? null : unitCode,
        "unit_name": unitName == null ? null : unitName,
        "wh_code": whCode == null ? null : whCode,
        "shelf_code": shelfCode == null ? null : shelfCode,
        "shelf_name": shelfName == null ? null : shelfName,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "discount": discount == null ? null : discount,
        "sum_amount": sumAmount == null ? null : sumAmount,
        "bar_code": barcode == null
            ? null
            : List<dynamic>.from(barcode!.map((x) => x.toJson())),
        "color_statusVat": colorStatusVat,
        "status_success": statusSuccess,
        "found": found,
        "index": index == null ? null : index,
        "remark_detail": remarkDetail == null ? null : remarkDetail,
      };
}

class Barcode {
  Barcode({
    this.barcode,
    this.unitCode,
    this.icCode,
  });
  String? barcode;
  String? unitCode;
  String? icCode;

  factory Barcode.fromRawJson(String str) => Barcode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Barcode.fromJson(Map<String, dynamic> json) => Barcode(
        barcode: json["barcode"] == null ? null : json["barcode"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        icCode: json["ic_code"] == null ? null : json["ic_code"],
      );

  Map<String, dynamic> toJson() => {
        "barcode": barcode == null ? null : barcode,
        "unit_code": unitCode == null ? null : unitCode,
        "ic_code": icCode == null ? null : icCode,
      };
}
