// // To parse this JSON data, do
// //
// //     final goodsReceiving = goodsReceivingFromJson(jsonString);

// import 'dart:convert';

// import 'package:flutter/cupertino.dart';

// GoodsReceiving goodsReceivingFromJson(String str) =>
//     GoodsReceiving.fromJson(json.decode(str));

// String goodsReceivingToJson(GoodsReceiving data) => json.encode(data.toJson());

// class GoodsReceiving {
//   GoodsReceiving({
//     this.supplier,
//   });

//   Supplier? supplier;

//   factory GoodsReceiving.fromJson(Map<String, dynamic> json) => GoodsReceiving(
//         supplier: json["supplier"] == null
//             ? null
//             : Supplier.fromJson(json["supplier"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "supplier": supplier == null ? null : supplier!.toJson(),
//       };
// }

// class Supplier {
//   Supplier({
//     this.code,
//     this.name,
//     this.remark,
//     this.remarkHead,
//     this.controllerCode,
//     this.poDocNo,
//     this.deliveryDate,
//     this.docRef,
//     this.deliveryDateToShop,
//     this.vatType,
//   });

//   String? code;
//   String? name;
//   String? remark;
//   TextEditingController? remarkHead;
//   TextEditingController? controllerCode;
//   List<PoDocNo>? poDocNo;
//   String? deliveryDate;
//   String? docRef;
//   String? deliveryDateToShop;
//   int? vatType;

//   factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
//         code: json["code"] == null ? null : json["code"],
//         name: json["name"] == null ? null : json["name"],
//         remark: json["remark"] == null ? null : json["remark"],
//         deliveryDateToShop: json["delivery_date_to_shop"] == null
//             ? null
//             : json["delivery_date_to_shop"],
//         deliveryDate:
//             json["delivery_date"] == null ? null : json["delivery_date"],
//         docRef: json["doc_ref"] == null ? null : json["doc_ref"],
//         vatType: json["vatType"] == null ? null : json["vatType"],
//         remarkHead: TextEditingController(
//             text: json["remark"] == null ? "" : json["remark"]),
//         controllerCode: TextEditingController(),
//         poDocNo: json["poDocNo"] == null
//             ? null
//             : List<PoDocNo>.from(
//                 json["poDocNo"].map((x) => PoDocNo.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "code": code == null ? null : code,
//         "name": name == null ? null : name,
//         "remark": remark == null ? null : remark,
//         "delivery_date": deliveryDate == null ? null : deliveryDate,
//         "doc_ref": docRef == null ? null : docRef,
//         "delivery_date_to_shop":
//             deliveryDateToShop == null ? null : deliveryDateToShop,
//         "poDocNo": poDocNo == null
//             ? null
//             : List<dynamic>.from(poDocNo!.map((x) => x.toJson())),
//       };
// }

// class PoDocNo {
//   PoDocNo({
//     this.head,
//     this.statusSearching = false,
//   });

//   Head? head;
//   bool statusSearching;

//   factory PoDocNo.fromJson(Map<String, dynamic> json) => PoDocNo(
//         head: json["head"] == null ? null : Head.fromJson(json["head"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "head": head == null ? null : head!.toJson(),
//       };
// }

// class Head {
//   Head({
//     this.docNo,
//     this.transFlag,
//     this.docDate,
//     this.deliveryDate,
//     this.docFormat,
//     this.inquiryType,
//     this.vatType,
//     this.custCode,
//     this.branchCode,
//     this.departCode,
//     this.creatorCode,
//     this.creditDay,
//     this.vatRate,
//     this.totalValue,
//     this.discountWord,
//     this.totalDiscount,
//     this.totalVatValue,
//     this.totalAmount,
//     this.remark,
//     this.totalBeforeVat,
//     this.totalAfterVat,
//     this.taxDocNo,
//     this.taxDocDate,
//     this.isTest,
//     this.detail,
//     this.imagePath,
//     this.isShow = false,
//     this.departMentName,
//     this.departMentCode,
//   });

//   String? docNo;
//   int? transFlag;
//   String? docDate;
//   String? deliveryDate;
//   String? docFormat;
//   int? inquiryType;
//   int? vatType;
//   String? custCode;
//   String? branchCode;
//   String? departCode;
//   String? creatorCode;
//   int? creditDay;
//   double? vatRate;
//   double? totalValue;
//   String? discountWord;
//   double? totalDiscount;
//   double? totalVatValue;
//   double? totalAmount;
//   String? remark;
//   double? totalBeforeVat;
//   double? totalAfterVat;
//   String? taxDocNo;
//   String? taxDocDate;
//   int? isTest;
//   List<Detail>? detail;
//   List<String>? imagePath;
//   bool isShow;
//   String? departMentName;
//   String? departMentCode;

//   factory Head.fromJson(Map<String, dynamic> json) => Head(
//         docNo: json["doc_no"] == null ? null : json["doc_no"],
//         departMentName:
//             json["departMentName"] == null ? null : json["departMentName"],
//         departMentCode:
//             json["departMentCode"] == null ? null : json["departMentCode"],
//         transFlag: json["transFlag"] == null ? null : json["transFlag"],
//         docDate: json["docDate"] == null ? null : json["docDate"],
//         deliveryDate:
//             json["DeliveryDate"] == null ? null : json["DeliveryDate"],
//         docFormat: json["docFormat"] == null ? null : json["docFormat"],
//         inquiryType: json["InquiryType"] == null ? null : json["InquiryType"],
//         vatType: json["VatType"] == null ? null : json["VatType"],
//         custCode: json["CustCode"] == null ? null : json["CustCode"],
//         branchCode: json["branchCode"] == null ? null : json["branchCode"],
//         departCode: json["departCode"] == null ? null : json["departCode"],
//         creatorCode: json["creatorCode"] == null ? null : json["creatorCode"],
//         creditDay: json["CreditDay"] == null ? null : json["CreditDay"],
//         vatRate: json["VatRate"] == null ? null : json["VatRate"].toDouble(),
//         totalValue:
//             json["TotalValue"] == null ? null : json["TotalValue"].toDouble(),
//         discountWord:
//             json["discountWord"] == null ? null : json["discountWord"],
//         totalDiscount: json["TotalDiscount"] == null
//             ? null
//             : json["TotalDiscount"].toDouble(),
//         totalVatValue: json["TotalVatValue"] == null
//             ? null
//             : json["TotalVatValue"].toDouble(),
//         totalAmount:
//             json["TotalAmount"] == null ? null : json["TotalAmount"].toDouble(),
//         remark: json["Remark"] == null ? null : json["Remark"],
//         totalBeforeVat: json["TotalBeforeVat"] == null
//             ? null
//             : json["TotalBeforeVat"].toDouble(),
//         totalAfterVat: json["totalAfterVat"] == null
//             ? null
//             : json["totalAfterVat"].toDouble(),
//         taxDocNo: json["taxDocNo"] == null ? null : json["taxDocNo"],
//         taxDocDate: json["taxDocDate"] == null ? null : json["taxDocDate"],
//         isTest: json["isTest"] == null ? null : json["isTest"],
//         detail: json["detail"] == null
//             ? null
//             : List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
//         imagePath: json["imagePath"] == null
//             ? []
//             : List<String>.from(json["imagePath"].map((x) => x)),
//       );

//   Map<String, dynamic> toJson() => {
//         "doc_no": docNo == null ? null : docNo,
//         "transFlag": transFlag == null ? null : transFlag,
//         "docDate": docDate == null ? null : docDate,
//         "DeliveryDate": deliveryDate == null ? null : deliveryDate,
//         "docFormat": docFormat == null ? null : docFormat,
//         "InquiryType": inquiryType == null ? null : inquiryType,
//         "VatType": vatType == null ? null : vatType,
//         "CustCode": custCode == null ? null : custCode,
//         "branchCode": branchCode == null ? null : branchCode,
//         "departCode": departCode == null ? null : departCode,
//         "creatorCode": creatorCode == null ? null : creatorCode,
//         "CreditDay": creditDay == null ? null : creditDay,
//         "VatRate": vatRate == null ? null : vatRate,
//         "TotalValue": totalValue == null ? null : totalValue,
//         "discountWord": discountWord == null ? null : discountWord,
//         "TotalDiscount": totalDiscount == null ? null : totalDiscount,
//         "TotalVatValue": totalVatValue == null ? null : totalVatValue,
//         "TotalAmount": totalAmount == null ? null : totalAmount,
//         "Remark": remark == null ? null : remark,
//         "TotalBeforeVat": totalBeforeVat == null ? null : totalBeforeVat,
//         "totalAfterVat": totalAfterVat == null ? null : totalAfterVat,
//         "taxDocNo": taxDocNo == null ? null : taxDocNo,
//         "taxDocDate": taxDocDate == null ? null : taxDocDate,
//         "isTest": isTest == null ? null : isTest,
//         "imagePath": imagePath == null
//             ? null
//             : List<dynamic>.from(imagePath!.map((e) => e)),
//         "detail": detail == null
//             ? null
//             : List<dynamic>.from(detail!.map((x) {
//                 if (x.statusSuccess == true) {
//                   return x.toJson();
//                 } else {
//                   return null;
//                 }
//               })),
//       };
// }

// class Detail {
//   Detail({
//     this.itemCode,
//     this.itemName,
//     this.unitCode,
//     this.qty,
//     this.price,
//     this.discountWord,
//     this.discountAmount,
//     this.sumAmount,
//     this.lineNumber,
//     this.whCode,
//     this.shelfCode,
//     this.priceGuid,
//     this.priceExcludeVat,
//     this.totalVatValue,
//     this.sumAmountExcludeVat,
//     this.refDocNo,
//     this.refRow,
//     this.receivingQty,
//     this.statusSuccess,
//     this.barcode,
//     this.statusSearch = false,
//     this.imagePath,
//     this.remark,
//     this.whName,
//     this.unitName,
//     this.diffreceivingQty,
//     this.controllerdiffreceivingQty,
//     this.controllerdiffreceivingRemark,
//   });

//   String? itemCode;
//   String? itemName;
//   String? unitCode;
//   double? qty;
//   double? price;
//   String? discountWord;
//   double? discountAmount;
//   double? sumAmount;
//   int? lineNumber;
//   String? whCode;
//   String? shelfCode;
//   String? priceGuid;
//   double? priceExcludeVat;
//   double? totalVatValue;
//   double? sumAmountExcludeVat;
//   String? refDocNo;
//   int? refRow;
//   double? receivingQty;
//   double? diffreceivingQty;
//   TextEditingController? controllerdiffreceivingQty;
//   TextEditingController? controllerdiffreceivingRemark;
//   bool? statusSuccess;
//   List<String>? barcode;
//   bool statusSearch;
//   List<String>? imagePath;
//   String? remark;
//   String? unitName;
//   String? whName;

//   factory Detail.fromJson(Map<String, dynamic> json) => Detail(
//       itemCode: json["itemCode"] == null ? null : json["itemCode"],
//       unitName: json["unit_name"] == null ? null : json["unit_name"],
//       whName: json["wh_name"] == null ? null : json["wh_name"],
//       itemName: json["itemName"] == null ? null : json["itemName"],
//       unitCode: json["unitCode"] == null ? null : json["unitCode"],
//       qty: json["qty"] == null ? null : json["qty"].toDouble(),
//       price: json["price"] == null ? null : json["price"].toDouble(),
//       discountWord: json["discountWord"],
//       discountAmount: json["discountAmount"] == null
//           ? null
//           : json["discountAmount"].toDouble(),
//       sumAmount:
//           json["SumAmount"] == null ? null : json["SumAmount"].toDouble(),
//       lineNumber: json["lineNumber"] == null ? null : json["lineNumber"],
//       whCode: json["whCode"] == null ? null : json["whCode"],
//       shelfCode: json["shelfCode"] == null ? null : json["shelfCode"],
//       priceGuid: json["priceGuid"].toString(),
//       priceExcludeVat: json["priceExcludeVat"] == null
//           ? null
//           : json["priceExcludeVat"].toDouble(),
//       totalVatValue: json["totalVatValue"] == null
//           ? null
//           : json["totalVatValue"].toDouble(),
//       sumAmountExcludeVat: json["sumAmountExcludeVat"] == null
//           ? null
//           : json["sumAmountExcludeVat"].toDouble(),
//       refDocNo: json["RefDocNo"] == null ? null : json["RefDocNo"],
//       refRow: json["RefRow"] == null ? null : json["RefRow"],
//       receivingQty:
//           json["receiving_qty"] == null ? 0 : json["receiving_qty"].toDouble(),
//       diffreceivingQty: (json["receiving_qty"] != null && json["qty"] != null)
//           ? (json["qty"].toDouble() - json["receiving_qty"].toDouble())
//           : 0,
//       statusSuccess:
//           json["status_success"] == null ? null : json["status_success"],
//       barcode: json["barcode"] == null
//           ? null
//           : List<String>.from(json["barcode"].map((x) => x)),
//       imagePath: json["image_path"] == null
//           ? []
//           : List<String>.from(json["image_path"].map((x) => x)),
//       controllerdiffreceivingQty: TextEditingController(
//           text: ((json["receiving_qty"] != null && json["qty"] != null)
//                   ? (json["qty"].toDouble() - json["receiving_qty"].toDouble())
//                   : 0)
//               .toString()),
//       controllerdiffreceivingRemark: TextEditingController());

//   Map<String, dynamic> toJson() => {
//         "itemCode": itemCode == null ? null : itemCode,
//         "itemName": itemName == null ? null : itemName,
//         "unitCode": unitCode == null ? null : unitCode,
//         "qty": qty == null ? null : qty,
//         "price": price == null ? null : price,
//         "discountWord": discountWord,
//         "discountAmount": discountAmount == null ? null : discountAmount,
//         "SumAmount": sumAmount == null ? null : sumAmount,
//         "lineNumber": lineNumber == null ? null : lineNumber,
//         "whCode": whCode == null ? null : whCode,
//         "shelfCode": shelfCode == null ? null : shelfCode,
//         "priceGuid": priceGuid,
//         "priceExcludeVat": priceExcludeVat == null ? null : priceExcludeVat,
//         "totalVatValue": totalVatValue == null ? null : totalVatValue,
//         "sumAmountExcludeVat":
//             sumAmountExcludeVat == null ? null : sumAmountExcludeVat,
//         "RefDocNo": refDocNo == null ? null : refDocNo,
//         "RefRow": refRow == null ? null : refRow,
//         "receiving_qty": receivingQty == null ? null : receivingQty,
//         "status_success": statusSuccess == null ? null : statusSuccess,
//         "barcode":
//             barcode == null ? null : List<String>.from(barcode!.map((x) => x)),
//         "image_path": imagePath == null
//             ? []
//             : List<String>.from(imagePath!.map((x) => x)),
//         "remark": remark == null ? null : remark,
//         "diffreceivingQty": controllerdiffreceivingQty == null
//             ? null
//             : controllerdiffreceivingQty!.text
//       };
// }

// To parse this JSON data, do
//
//     final goodsReceiving = goodsReceivingFromMap(jsonString);
// To parse this JSON data, do
//
//     final goodsReceiving = goodsReceivingFromMap(jsonString);
// To parse this JSON data, do
//
//     final goodsReceiving = goodsReceivingFromMap(jsonString);
// To parse this JSON data, do
//
//     final goodsReceiving = goodsReceivingFromMap(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

class GoodsReceiving {
  GoodsReceiving(
      {this.supCode,
      this.apName,
      this.deliveryDateToShop,
      this.head,
      this.controllerCode});

  String? supCode;
  String? apName;
  DateTime? deliveryDateToShop;
  List<Head>? head;
  TextEditingController? controllerCode;

  factory GoodsReceiving.fromJson(String str) =>
      GoodsReceiving.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory GoodsReceiving.fromMap(Map<String, dynamic> json) => GoodsReceiving(
        supCode: json["sup_code"],
        apName: json["ap_name"],
        deliveryDateToShop: DateTime.parse(json["delivery_date_to_shop"]),
        head: List<Head>.from(json["head"].map((x) => Head.fromMap(x))),
        controllerCode: TextEditingController(text: ""),
      );

  Map<String, dynamic> toMap() => {
        "sup_code": supCode,
        "ap_name": apName,
        "delivery_date_to_shop": deliveryDateToShop,
        "head": List<dynamic>.from(head!.map((x) => x.toMap())),
      };
}

class Head {
  Head({
    this.docNo,
    this.supCode,
    this.remark,
    this.refDocNo,
    this.docDate,
    this.docFormatCode,
    this.lastStatus,
    this.approveStatus,
    this.mydescription,
    this.vatType,
    this.vatName,
    this.departmentCode,
    this.depName,
    this.taxDocNo,
    this.taxDocDate,
    this.transportCostDocNo,
    this.detail,
    this.statusSuccess = false,
    this.statusSearch = false,
    required this.imagePath,
    this.isShow = false,
    this.remarkHead,
  });

  String? docNo;
  String? supCode;
  String? remark;
  String? refDocNo;
  DateTime? docDate;
  String? docFormatCode;
  int? lastStatus;
  int? approveStatus;
  String? mydescription;
  int? vatType;
  String? vatName;
  String? departmentCode;
  String? depName;
  String? taxDocNo;
  String? taxDocDate;
  String? transportCostDocNo;
  List<Detail>? detail;
  bool statusSuccess;
  bool statusSearch;
  bool isShow;
  List<String> imagePath;
  TextEditingController? remarkHead;

  factory Head.fromJson(String str) => Head.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory Head.fromMap(Map<String, dynamic> json) => Head(
        docNo: json["doc_no"],
        supCode: json["sup_code"],
        remark: json["remark"],
        refDocNo: json["ref_doc_no"],
        docDate: DateTime.parse(json["doc_date"]),
        docFormatCode: json["doc_format_code"],
        lastStatus: json["last_status"],
        approveStatus: json["approve_status"],
        mydescription: json["mydescription"],
        vatType: json["vat_type"],
        vatName: json["vat_name"],
        departmentCode: json["department_code"],
        depName: json["dep_name"],
        taxDocNo: json["tax_doc_no"],
        taxDocDate: json["tax_doc_date"],
        transportCostDocNo: json["transport_cost_doc_no"],
        detail: List<Detail>.from(json["detail"].map((x) => Detail.fromMap(x))),
        imagePath: [],
        remarkHead: TextEditingController(
            text: json["remark"] == null ? '' : json["remark"]),
      );

  Map<String, dynamic> toMap() => {
        "doc_no": docNo,
        "sup_code": supCode,
        "remark": remark,
        "ref_doc_no": refDocNo,
        "doc_date": docDate,
        "doc_format_code": docFormatCode,
        "last_status": lastStatus,
        "approve_status": approveStatus,
        "mydescription": mydescription,
        "vat_type": vatType,
        "vat_name": vatName,
        "department_code": departmentCode,
        "dep_name": depName,
        "tax_doc_no": taxDocNo,
        "tax_doc_date": taxDocDate,
        "transport_cost_doc_no": transportCostDocNo,
        "detail": List<dynamic>.from(detail!.map((x) => x.toMap())),
      };
}

class Detail {
  Detail({
    this.roworder,
    this.docNo,
    this.docDate,
    this.sendDate,
    this.itemCode,
    this.itemName,
    this.qty,
    this.price,
    this.discount,
    this.sumAmount,
    this.whCode,
    this.shelfCode,
    this.vatType,
    this.inquiryType,
    this.lineNumber,
    this.remark,
    this.refLineNumber,
    this.refDocNo,
    this.status,
    this.unitCode,
    this.eventQty,
    this.isScanBar,
    this.qtyBalance,
    this.unitName,
    this.barcode,
    this.statusSearch = false,
    this.statusSuccess = false,
    required this.imagePathDetail,
    required this.controllerdiffreceivingRemark,
  });

  int? roworder;
  String? docNo;
  DateTime? docDate;
  DateTime? sendDate;
  String? itemCode;
  String? itemName;
  int? qty;
  int? price;
  int? discount;
  int? sumAmount;
  String? whCode;
  String? shelfCode;
  int? vatType;
  int? inquiryType;
  int? lineNumber;
  String? remark;
  int? refLineNumber;

  String? refDocNo;
  int? status;
  String? unitCode;
  TextEditingController? eventQty;
  TextEditingController? controllerdiffreceivingRemark;
  int? isScanBar;
  int? qtyBalance;
  String? unitName;
  String? barcode;
  bool statusSearch;
  bool statusSuccess;
  List<String> imagePathDetail;

  factory Detail.fromJson(String str) => Detail.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());
  factory Detail.fromMap(Map<String, dynamic> json) => Detail(
      roworder: json["roworder"],
      docNo: json["doc_no"],
      docDate: DateTime.parse(json["doc_date"]),
      sendDate: DateTime.parse(json["send_date"]),
      itemCode: json["item_code"],
      itemName: json["item_name"],
      qty: json["qty"],
      price: json["price"],
      discount: json["discount"],
      sumAmount: json["sum_amount"],
      whCode: json["wh_code"],
      shelfCode: json["shelf_code"],
      vatType: json["vat_type"],
      inquiryType: json["inquiry_type"],
      lineNumber: json["line_number"],
      remark: json["remark"],
      refLineNumber: json["ref_line_number"],
      refDocNo: json["ref_doc_no"],
      status: json["status"],
      unitCode: json["unit_code"],
      eventQty: TextEditingController(
          text: json["qty"] == null ? '0' : json["qty"].toString()),
      isScanBar: json["is_scan_bar"],
      qtyBalance: json["qty_balance"],
      unitName: json["unit_name"],
      barcode: json["barcode"],
      imagePathDetail: [],
      controllerdiffreceivingRemark: TextEditingController(text: ""));

  Map<String, dynamic> toMap() => {
        "roworder": roworder,
        "doc_no": docNo,
        "doc_date": docDate,
        "send_date": sendDate,
        "item_code": itemCode,
        "item_name": itemName,
        "qty": qty,
        "price": price,
        "discount": discount,
        "sum_amount": sumAmount,
        "wh_code": whCode,
        "shelf_code": shelfCode,
        "vat_type": vatType,
        "inquiry_type": inquiryType,
        "line_number": lineNumber,
        "remark": remark,
        "ref_line_number": refLineNumber,
        "ref_doc_no": refDocNo,
        "status": status,
        "unit_code": unitCode,
        "event_qty": eventQty,
        "is_scan_bar": isScanBar,
        "qty_balance": qtyBalance,
        "unit_name": unitName,
        "barcode": barcode,
      };
}
