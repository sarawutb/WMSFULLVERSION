import 'dart:convert';

class PoDetail {
  PoDetail({
    this.docNo,
    this.supCode,
    this.supName,
    this.lineNumber,
    this.itemCode,
    this.itemName,
    this.unitCode,
    this.unitName,
    this.price,
    this.sumAmount,
    this.discountAmount,
    this.poQty,
    this.recQty,
    this.newRecQty,
    this.qtyBalance,
    this.whCode,
    this.shelfCode,
    this.shelfName,
    this.statusSuccess = false,
    this.hide = false,
    this.checkBox = false,
    this.remark = '',
  });

  String? docNo;
  String? supCode;
  String? supName;
  int? lineNumber;
  String? itemCode;
  String? itemName;
  String? unitCode;
  String? unitName;
  String? price;
  String? sumAmount;
  String? discountAmount;
  String? poQty;
  String? recQty;
  String? newRecQty;
  String? qtyBalance;
  String? whCode;
  String? shelfCode;
  String? shelfName;
  bool statusSuccess;
  bool hide;
  bool checkBox;
  String remark;

  factory PoDetail.fromRawJson(String str) =>
      PoDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PoDetail.fromJson(Map<String, dynamic> json) => PoDetail(
        docNo: json["doc_no"] == null ? null : json["doc_no"],
        supCode: json["sup_code"] == null ? null : json["sup_code"],
        supName: json["sup_name"] == null ? null : json["sup_name"],
        lineNumber: json["line_number"] == null ? null : json["line_number"],
        itemCode: json["item_code"] == null ? null : json["item_code"],
        itemName: json["item_name"] == null ? null : json["item_name"],
        unitCode: json["unit_code"] == null ? null : json["unit_code"],
        unitName: json["unit_name"] == null ? null : json["unit_name"],
        price: json["price"] == null ? null : json["price"],
        sumAmount: json["sum_amount"] == null ? null : json["sum_amount"],
        discountAmount:
            json["discount_amount"] == null ? null : json["discount_amount"],
        poQty: json["po_qty"] == null ? null : json["po_qty"],
        recQty: json["rec_qty"] == null ? null : json["rec_qty"],
        qtyBalance: json["qty_balance"] == null ? null : json["qty_balance"],
        whCode: json["wh_code"] == null ? null : json["wh_code"],
        shelfCode: json["shelf_code"] == null ? null : json["shelf_code"],
        shelfName: json["shelf_name"] == null ? null : json["shelf_name"],
      );

  Map<String, dynamic> toJson() => {
        "doc_no": docNo == null ? null : docNo,
        "sup_code": supCode == null ? null : supCode,
        "sup_name": supName == null ? null : supName,
        "line_number": lineNumber == null ? null : lineNumber,
        "item_code": itemCode == null ? null : itemCode,
        "item_name": itemName == null ? null : itemName,
        "unit_code": unitCode == null ? null : unitCode,
        "unit_name": unitName == null ? null : unitName,
        "price": price == null ? null : price,
        "sum_amount": sumAmount == null ? null : sumAmount,
        "discount_amount": discountAmount == null ? null : discountAmount,
        "po_qty": poQty == null ? null : poQty,
        "rec_qty": recQty == null ? null : recQty,
        "qty_balance": qtyBalance == null ? null : qtyBalance,
        "wh_code": whCode == null ? null : whCode,
        "shelf_code": shelfCode == null ? null : shelfCode,
        "shelf_name": shelfName == null ? null : shelfName,
        "status_success": statusSuccess,
        "remark": remark,
      };
}
