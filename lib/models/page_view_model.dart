import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:signature/signature.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:provider/provider.dart';

final f = new DateFormat('yyyy-MM-dd');

class PageViewModel {
  PageViewModel({
    this.itemId,
    this.head,
  });

  int? itemId;
  List<Head>? head;

  factory PageViewModel.fromRawJson(String str) =>
      PageViewModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PageViewModel.fromJson(Map<String, dynamic> json) {
    var headJson = json["head"] == null ? [] : json["head"] as List;
    List<Head> _head = headJson.map((x) => Head.fromJson(x)).toList();

    // _head.sort((a, b) {
    //   return b.docDate2!.compareTo(a.docDate2!);
    // });

    return PageViewModel(
      itemId: json["item_id"] == null ? null : json["item_id"],
      // head: json["head"] == null
      //     ? null
      //     : List<Head>.from(json["head"].map((x) => Head.fromJson(x))),
      head: _head,
    );
  }

  Map<String, dynamic> toJson() => {
        "item_id": itemId == null ? null : itemId,
        "head": head == null
            ? []
            : List<dynamic>.from(head!.map((x) => x.toJson())),
      };
}

class Head {
  Head(
      {this.ty,
      this.docDate,
      this.docDate2,
      this.docNo,
      this.refCode,
      this.transFlag,
      this.custCode,
      this.arName,
      this.userName,
      this.saleName,
      this.localMobile,
      this.sendType,
      this.receiveDate,
      this.sendDate,
      this.tmsQueShipmentCode,
      this.carCode,
      this.sumQty,
      this.sumPayQty,
      this.detail,
      this.createDateTime,
      this.isselected = false,
      this.statusButtonInDocument = false, // เดิม false
      this.imagepath,
      this.signture,
      this.signatureController,
      this.image,
      this.controllerSearchDocument,
      this.formKeyContainerScoll,
      this.focusNode,
      this.statusButtonClick = true});

  String? ty;
  DateTime? docDate;
  String? docDate2;
  String? docNo;
  int? transFlag;
  String? refCode;
  String? custCode;
  String? arName;
  String? userName;
  String? saleName;
  String? localMobile;
  String? sendType;
  DateTime? receiveDate;
  DateTime? sendDate;
  String? tmsQueShipmentCode;
  String? carCode;
  double? sumQty;
  double? sumPayQty;
  List<Detail>? detail;
  String? createDateTime;
  bool isselected;
  List<String>? imagepath;
  String? signture;
  bool statusButtonInDocument;
  List<String>? image;
  SignatureController? signatureController;
  TextEditingController? controllerSearchDocument;
  GlobalKey? formKeyContainerScoll = GlobalKey();
  FocusNode? focusNode;
  bool statusButtonClick;

  factory Head.fromRawJson(String str) => Head.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Head.fromJson(Map<String, dynamic> json) {
    var detailJson = json["detail"] as List;
    List<Detail> detail = detailJson.map((x) => Detail.fromJson(x)).toList();
    detail.sort((a, b) {
      return a.lineNumber!.compareTo(b.lineNumber!);
    });

    return Head(
      ty: json["ty"] == null ? null : json["ty"],
      docDate:
          json["doc_date"] == null ? null : DateTime.parse(json["doc_date"]),
      docNo: json["doc_no"] == null ? null : json["doc_no"],
      docDate2: json["doc_date2"] == null ? null : json["doc_date2"],
      refCode: json["ref_code"] == null ? null : json["ref_code"],
      transFlag: json["trans_flag"] == null ? null : json["trans_flag"],
      custCode: json["cust_code"] == null ? null : json["cust_code"],
      arName: json["ar_name"] == null ? null : json["ar_name"],
      userName: json["user_name"] == null ? null : json["user_name"],
      saleName: json["sale_name"] == null ? null : json["sale_name"],
      localMobile: json["local_mobile"] == null ? null : json["local_mobile"],
      sendType: json["send_type"] == null ? null : json["send_type"],
      createDateTime: json["create_date_time"] ?? null,
      receiveDate: json["receive_date"] == null
          ? null
          : DateTime.parse(json["receive_date"]),
      sendDate:
          json["send_date"] == null ? null : DateTime.parse(json["send_date"]),
      tmsQueShipmentCode: json["tms_que_shipment_code"] == null
          ? null
          : json["tms_que_shipment_code"],
      carCode: json["car_code"] == null ? null : json["car_code"],
      sumQty: json["sum_qty"] == null
          ? null
          : double.parse(json["sum_qty"].toString()),
      sumPayQty: json["sum_pay_qty"] == null
          ? null
          : double.parse(json["sum_pay_qty"].toString()),
      detail: json["detail"] == null ? null : detail,
      // detail: json["detail"] == null
      //     ? null
      //     : List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
      image: json["images"] == null ? [] : json["images"].split(','),
      imagepath: [],
      signatureController: SignatureController(
        penStrokeWidth: 1,
        penColor: Colors.black,
        exportBackgroundColor: Colors.white,
        onDrawStart: () => print('onDrawStart called!'),
        onDrawEnd: () => print('onDrawEnd called!'),
      ),
      controllerSearchDocument: TextEditingController(text: ""),
    );
  }

  Map<String, dynamic> toJson() => {
        "ty": ty == null ? null : ty,
        "doc_date": docDate == null ? null : docDate,
        "doc_no": docNo == null ? null : docNo,
        "ref_code": refCode == null ? null : refCode,
        "trans_flag": transFlag == null ? null : transFlag,
        "cust_code": custCode == null ? null : custCode,
        "ar_name": arName == null ? null : arName,
        "send_type": sendType == null ? null : sendType,
        "receive_date":
            receiveDate == null ? null : receiveDate!.toIso8601String(),
        "send_date": sendDate == null ? null : sendDate!.toIso8601String(),
        "tms_que_shipment_code":
            tmsQueShipmentCode == null ? null : tmsQueShipmentCode,
        "car_code": carCode == null ? null : carCode,
        "sum_qty": sumQty == null ? null : sumQty,
        "detail": detail == null
            ? null
            : List<dynamic>.from(detail!.map((x) => x.toJson())),
      };
}

class Detail {
  Detail(
      {this.docNo,
      this.icCode,
      this.itemName,
      this.unitCode,
      this.unitName,
      this.lineNumber,
      this.qty,
      this.price,
      this.sumAmount,
      this.whCode,
      this.nameShlfCode,
      this.shelfCode,
      this.eventQty,
      this.diffQty,
      this.payQty,
      this.localPayQty = 0,
      this.diffPayQty,
      this.barcode,
      this.remark,
      this.refDocNo,
      this.season,
      this.reasonCode,
      this.statussuccess = false, // เดิม false
      this.statussearch = false,
      this.statussearchConfirm = false,
      this.controllerPayQty,
      this.focusNode});

  String? docNo;
  String? icCode;
  String? itemName;
  String? unitCode;
  String? unitName;
  int? lineNumber;
  double? qty;
  double? price;
  double? sumAmount;
  String? whCode;
  String? nameShlfCode;
  String? shelfCode;
  double? eventQty;
  double? diffQty;
  double? payQty;
  double? localPayQty;
  double? diffPayQty;
  List<String>? barcode;
  bool statussuccess;
  bool statussearch;
  bool statussearchConfirm;
  String? remark;
  String? refDocNo;
  String? season;
  String? reasonCode;
  TextEditingController? controllerPayQty;
  FocusNode? focusNode;

  factory Detail.fromRawJson(String str) => Detail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
        docNo: json["doc_no"] == null ? null : json["doc_no"],
        icCode: json["ic_code"] == null ? null : json["ic_code"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        unitName: json["unit_name"] == null ? null : json["unit_name"],
        lineNumber: json["line_number"] == null ? null : json["line_number"],
        qty: json["qty"] == null ? null : double.parse(json["qty"].toString()),
        price: json["price"] == null ? null : json["price"].toDouble(),
        sumAmount:
            json["sum_amount"] == null ? null : json["sum_amount"].toDouble(),
        whCode: json["wh_code"] == null ? null : json["wh_code"],
        nameShlfCode:
            json["name_shlf_code"] == null ? null : json["name_shlf_code"],
        shelfCode: json["shelf_code"] == null ? null : json["shelf_code"],
        remark: json["remark"] == null ? null : json["remark"],
        refDocNo: json["ref_doc_no"] == null ? null : json["ref_doc_no"],
        season: json["season"] == null ? null : json["season"],
        eventQty: json["event_qty"] == null
            ? null
            : double.parse(json["event_qty"].toString()),
        diffQty: json["diff_qty"] == null
            ? null
            : double.parse(json["diff_qty"].toString()),
        payQty: json["pay_qty"] == null
            ? null
            : double.parse(json["pay_qty"].toString()),
        diffPayQty: json["diff_pay_qty"] == null
            ? null
            : double.parse(json["diff_pay_qty"].toString()),
        barcode: json["barcode"] == null
            ? null
            : json["barcode"].toString().split(','),
        controllerPayQty: TextEditingController(
          text: json["event_qty"] == null
              ? "0"
              : (double.parse(json["event_qty"].toString()) -
                      double.parse(json["pay_qty"].toString()))
                  .toString(),
        ),
        focusNode: FocusNode());
  }
  Map<String, dynamic> toJson() => {
        "doc_no": docNo == null ? null : docNo,
        "ic_code": icCode == null ? null : icCode,
        "item_name": itemName == null ? null : itemName,
        "unit_code": unitCode == null ? null : unitCode,
        "unit_name": unitName == null ? null : unitName,
        "line_number": lineNumber == null ? null : lineNumber,
        "qty": qty == null ? null : qty,
        "price": price == null ? null : price,
        "sum_amount": sumAmount == null ? null : sumAmount,
        "wh_code": whCode == null ? null : whCode,
        "name_shlf_code": nameShlfCode == null ? null : nameShlfCode,
        "shelf_code": shelfCode == null ? null : shelfCode,
        "event_qty": eventQty == null ? null : eventQty,
        "diff_qty": diffQty == null ? null : diffQty,
        "remark": remark == null ? null : remark,
        "season": season == null ? null : season,
      };
}
