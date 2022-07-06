import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_get_po_screen.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/GoodsReceiving.dart';
import 'package:wms/models/product_po_model.dart';
import 'package:wms/screens/get_po_screen/begingetpo/begingetpo.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';

import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/loadingdialogbox.dart';
import 'package:wms/widgets/serchbar.dart';
import 'package:wms/widgets/simpleText.dart';
import 'package:wms/widgets/willPopScope.dart';

import '../main_screen/main_screen.dart';

class GetPoScreen extends StatefulWidget {
  const GetPoScreen({Key? key}) : super(key: key);

  @override
  _GetPoScreenState createState() => _GetPoScreenState();
}

class _GetPoScreenState extends State<GetPoScreen> {
  // Map<String, dynamic> listDemo = {
  //   "supplier": {
  //     "code": "100628",
  //     "name": "บจก.รถไฟฟ้าแห่งประเทศไทย",
  //     "remark": "ทดสอบระบบ",
  //     "delivery_date": "2022-03-02",
  //     "doc_ref": "IV0028702",
  //     "delivery_date_to_shop": "2022-03-02",
  //     "vatType": 1,
  //     "poDocNo": [
  //       {
  //         "head": {
  //           "doc_no": "X01-PON6502-00002",
  //           "transFlag": 310,
  //           "docDate": "2022-03-02",
  //           "DeliveryDate": "2021-03-1",
  //           "docFormat": "X01-RRV",
  //           "InquiryType": 1,
  //           "departMentName": "ขายปลีก",
  //           "departMentCode": "999",
  //           "VatType": 1,
  //           "CustCode": "144904",
  //           "branchCode": "X01",
  //           "departCode": "001",
  //           "creatorCode": "10862",
  //           "CreditDay": 45,
  //           "VatRate": 7.0,
  //           "TotalValue": 128112.25,
  //           "discountWord": "",
  //           "TotalDiscount": 0.0,
  //           "TotalVatValue": 8381.18,
  //           "TotalAmount": 128112.25,
  //           "Remark": "ทดอบ MIS",
  //           "TotalBeforeVat": 119731.07,
  //           "totalAfterVat": 128112.25,
  //           "taxDocNo": "X01-RRV6503-00007",
  //           "taxDocDate": "2022-03-02",
  //           "isTest": 1,
  //           "detail": [
  //             {
  //               "itemCode": "1025271",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 10.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 0,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["8850999322001", "8850999322002"]
  //             },
  //             {
  //               "itemCode": "1025272",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 175.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 1,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["8850999322003", "8850999322004"]
  //             },
  //             {
  //               "itemCode": "1025273",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 175.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 2,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["8850999322005", "8850999322006"]
  //             },
  //             {
  //               "itemCode": "1025274",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 175.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 3,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": true,
  //               "barcode": ["8850999322007", "8850999322008"]
  //             },
  //             {
  //               "itemCode": "1025275",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 175.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 4,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["8850999322009", "88509993220010"]
  //             }
  //           ]
  //         }
  //       },
  //       {
  //         "head": {
  //           "doc_no": "X01-PON6502-00001",
  //           "transFlag": 310,
  //           "docDate": "2022-03-02",
  //           "DeliveryDate": "2021-03-1",
  //           "docFormat": "X01-RRV",
  //           "InquiryType": 1,
  //           "departMentName": "ขายปลีก",
  //           "departMentCode": "999",
  //           "VatType": 1,
  //           "CustCode": "144904",
  //           "branchCode": "X01",
  //           "departCode": "001",
  //           "creatorCode": "10862",
  //           "CreditDay": 45,
  //           "VatRate": 7.0,
  //           "TotalValue": 128112.25,
  //           "discountWord": "",
  //           "TotalDiscount": 0.0,
  //           "TotalVatValue": 8381.18,
  //           "TotalAmount": 128112.25,
  //           "Remark": "ทดอบ MIS",
  //           "TotalBeforeVat": 119731.07,
  //           "totalAfterVat": 128112.25,
  //           "taxDocNo": "X01-RRV6503-00007",
  //           "taxDocDate": "2022-03-02",
  //           "isTest": 1,
  //           "detail": [
  //             {
  //               "itemCode": "1025271",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 175.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 0,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["1050999322001", "1050999322002"]
  //             },
  //             {
  //               "itemCode": "1025271",
  //               "itemName":
  //                   "รายการทดสอบ เหล็กข้ออ้อย SD40 25MMx10M โรงใหญ่ ตรง SKY นน.38.53กก",
  //               "unitCode": "LN",
  //               "unit_name": "หน่วยทดสอบ",
  //               "wh_name": "ที่เก็บทดสอบ",
  //               "qty": 0.00,
  //               "price": 732.070,
  //               "discountWord": null,
  //               "discountAmount": 0.0,
  //               "SumAmount": 128112.25,
  //               "lineNumber": 7,
  //               "whCode": "X01",
  //               "shelfCode": "W2-Z03-2",
  //               "priceGuid": null,
  //               "priceExcludeVat": 684.18,
  //               "totalVatValue": 8381.18,
  //               "sumAmountExcludeVat": 119731.07,
  //               "RefDocNo": "X01-POV6502-00006",
  //               "RefRow": 0,
  //               "receiving_qty": 0,
  //               "status_success": false,
  //               "barcode": ["1050999322001", "1050999322002"]
  //             }
  //           ]
  //         }
  //       }
  //     ]
  //   }
  // };

  final f = new DateFormat('dd-MM-yyyy');
  // var now = DateTime.now().toLocal();
  DateTime? dateTime;
  Duration? duration;
  TextEditingController _query = TextEditingController();
  FocusNode _node = FocusNode();
  // TextEditingController intialdateval = TextEditingController();

  @override
  void initState() {
    _node.requestFocus();
    Future.delayed(Duration(milliseconds: 400),
        () => SystemChannels.textInput.invokeMethod('TextInput.hide'));
    dateTime = DateTime.now();
    duration = Duration(minutes: 10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ControllerGetPoScreen controller = context.read<ControllerGetPoScreen>();
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14);

    // var dateInBuddhistCalendarFormat = f.formatInBuddhistCalendarThai(now);
    return willPopScope(
      press: () async {
        // await controller.clearItemInGoodsReceiving();
        context.read<ControllerGetPoScreen>().goodsReceiving = null;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 7,
                                color: Colors.grey.shade300,
                                offset: Offset(2, 2),
                                spreadRadius: 4,
                              ),
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      // color: Colors.indigo,
                                      border: Border.all(color: Colors.indigo),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Text(
                                      "ระบุวันที่สินค้าถึงร้าน",
                                      style: _styledefult.copyWith(
                                          // fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      DateTime? newDateTime =
                                          await showRoundedDatePicker(
                                        context: context,
                                        locale: Locale("th", "TH"),
                                        era: EraMode.BUDDHIST_YEAR,
                                        background: Colors.transparent,
                                        theme: ThemeData(
                                          primarySwatch: Colors.indigo,
                                        ),
                                        initialDate: dateTime,
                                        firstDate:
                                            DateTime(DateTime.now().year - 1),
                                        lastDate:
                                            DateTime(DateTime.now().year + 1),
                                        styleDatePicker:
                                            MaterialRoundedDatePickerStyle(
                                          paddingMonthHeader: EdgeInsets.all(8),
                                        ),
                                      );
                                      if (newDateTime != null) {
                                        setState(() => dateTime = newDateTime);
                                      }
                                      Future.delayed(
                                          Duration(milliseconds: 400),
                                          () => SystemChannels.textInput
                                              .invokeListMethod(
                                                  'TextInput.hide'));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo,
                                        border:
                                            Border.all(color: Colors.indigo),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                      ),
                                      child: Text(
                                        "${dateTime!.day}/${dateTime!.month}/" +
                                            (dateTime!.year + 543).toString(),
                                        style:
                                            _styledefult.copyWith(color: white
                                                // fontWeight: FontWeight.bold,
                                                ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SimpleTextField(
                              hintText: "สแกน/ค้นหา บาร์โค้ด...",
                              hintStyle: _styledefult,
                              focusNode: _node,
                              prefixIconData: Icons.search,
                              accentColor: Colors.indigo,
                              verticalPadding: 10,
                              textEditingController: _query,
                              fillColor: Colors.indigo.shade50,
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  getPolist(query: value);
                                  setState(() {
                                    _query.clear();
                                  });
                                  _node.requestFocus();
                                  Future.delayed(
                                      Duration(milliseconds: 600),
                                      () => SystemChannels.textInput
                                          .invokeListMethod('TextInput.hide'));
                                }
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (context
                              .read<ControllerGetPoScreen>()
                              .goodsReceiving !=
                          null) ...[
                        Consumer<ControllerGetPoScreen>(
                            builder: ((context, value, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${value.goodsReceiving!.apName} ",
                                style: _styledefult.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ...List.generate(
                                  value.goodsReceiving!.head!.length, (index) {
                                return value.goodsReceiving!.head![index]
                                        .statusSearch
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text(
                                                "${value.goodsReceiving!.head![index].docNo}",
                                                style: _styledefult.copyWith(
                                                    fontSize: 13),
                                              ),
                                            ),
                                            Spacer(),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: GestureDetector(
                                                onTap: () async {
                                                  String? _image =
                                                      await getCamera();
                                                  if (_image != null) {
                                                    value.addImageToHead(
                                                        path: _image,
                                                        index: index);
                                                    // context
                                                    //     .read<ControllerGetPoScreen>()
                                                    //     .addImagePathHeadInGoodsReceviceing(
                                                    //         index: index,
                                                    //         value: _image);
                                                  }
                                                },
                                                child: Container(
                                                    width: 60,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: Colors.indigo),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .camera_alt,
                                                                color: white,
                                                                size: 15,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 0,
                                                            right: 0,
                                                            child: Container(
                                                              height: 20,
                                                              width: 20,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              color: red,
                                                              child: Text(
                                                                "${value.goodsReceiving!.head![index].imagePath.length}",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: _styledefult
                                                                    .copyWith(
                                                                        color:
                                                                            white,
                                                                        fontSize:
                                                                            10),
                                                              ),
                                                            ))
                                                      ],
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (c) => AlertDialog(
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      // insetPadding:
                                                      //     EdgeInsets.zero,
                                                      buttonPadding:
                                                          EdgeInsets.zero,
                                                      content: Container(
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    5),
                                                            topRight:
                                                                Radius.circular(
                                                                    5),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "คุณต้องการลบ ${value.goodsReceiving!.head![index].docNo} หรือไม่?",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    _styledefult,
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      Future.delayed(
                                                                          Duration(
                                                                              milliseconds:
                                                                                  600),
                                                                          () => SystemChannels
                                                                              .textInput
                                                                              .invokeListMethod('TextInput.hide'));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      height:
                                                                          40,
                                                                      color:
                                                                          red,
                                                                      child:
                                                                          Text(
                                                                        "ไม่ใช่",
                                                                        style: _styledefult.copyWith(
                                                                            color:
                                                                                white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      value.removeHeadFromIndex(
                                                                          docNo: value
                                                                              .goodsReceiving!
                                                                              .head![index]
                                                                              .refDocNo!);
                                                                      // context
                                                                      //     .read<
                                                                      //         ControllerGetPoScreen>()
                                                                      //     .removeItemInGoodsReceiving(
                                                                      //         index:
                                                                      //             index);

                                                                      Navigator.pop(
                                                                          context);
                                                                      Future.delayed(
                                                                          Duration(
                                                                              milliseconds:
                                                                                  600),
                                                                          () => SystemChannels
                                                                              .textInput
                                                                              .invokeListMethod('TextInput.hide'));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          40,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      color: Colors
                                                                          .indigo,
                                                                      child:
                                                                          Text(
                                                                        "ใช่",
                                                                        style: _styledefult.copyWith(
                                                                            color:
                                                                                white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 60,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.red),
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox();
                              }),
                            ],
                          );
                        }))
                      ],
                      SizedBox(
                        height: 90,
                      ),

                      // if (context
                      //         .read<ControllerGetPoScreen>()
                      //         .goodsReceiving !=
                      //     null) ...[
                      //   Consumer<ControllerGetPoScreen>(
                      //       builder: ((context, value, child) {
                      //     return Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "${value.goodsReceiving!.supplier!.name} [ ${value.goodsReceiving!.supplier!.poDocNo!.length} ]",
                      //           style: _styledefult.copyWith(
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //         ...List.generate(
                      //             value.goodsReceiving!.supplier!.poDocNo!
                      //                 .length, (index) {
                      //           return Padding(
                      //             padding:
                      //                 const EdgeInsets.symmetric(vertical: 3),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 Padding(
                      //                   padding:
                      //                       const EdgeInsets.only(left: 20),
                      //                   child: Text(
                      //                     "${value.goodsReceiving!.supplier!.poDocNo![index].head!.docNo}",
                      //                     style: _styledefult.copyWith(
                      //                         fontSize: 13),
                      //                   ),
                      //                 ),
                      //                 Spacer(),
                      //                 Padding(
                      //                   padding:
                      //                       EdgeInsets.symmetric(horizontal: 5),
                      //                   child: GestureDetector(
                      //                     onTap: () async {
                      //                       String? _image = await getCamera();
                      //                       if (_image != null) {
                      //                         context
                      //                             .read<ControllerGetPoScreen>()
                      //                             .addImagePathHeadInGoodsReceviceing(
                      //                                 index: index,
                      //                                 value: _image);
                      //                       }
                      //                     },
                      //                     child: Container(
                      //                         width: 60,
                      //                         height: 30,
                      //                         decoration: BoxDecoration(
                      //                             borderRadius:
                      //                                 BorderRadius.circular(5),
                      //                             color: Colors.indigo),
                      //                         child: Stack(
                      //                           children: [
                      //                             Container(
                      //                               width: double.infinity,
                      //                               child: Column(
                      //                                 mainAxisAlignment:
                      //                                     MainAxisAlignment
                      //                                         .center,
                      //                                 crossAxisAlignment:
                      //                                     CrossAxisAlignment
                      //                                         .center,
                      //                                 children: [
                      //                                   Icon(
                      //                                     Icons.camera_alt,
                      //                                     color: white,
                      //                                     size: 15,
                      //                                   ),
                      //                                 ],
                      //                               ),
                      //                             ),
                      //                             Positioned(
                      //                                 top: 0,
                      //                                 right: 0,
                      //                                 child: Container(
                      //                                   height: 20,
                      //                                   width: 20,
                      //                                   alignment:
                      //                                       Alignment.center,
                      //                                   color: red,
                      //                                   child: Text(
                      //                                     "${value.goodsReceiving!.supplier!.poDocNo![index].head!.imagePath!.length}",
                      //                                     textAlign:
                      //                                         TextAlign.center,
                      //                                     style: _styledefult
                      //                                         .copyWith(
                      //                                             color: white,
                      //                                             fontSize: 10),
                      //                                   ),
                      //                                 ))
                      //                           ],
                      //                         )),
                      //                   ),
                      //                 ),
                      //                 Padding(
                      //                   padding:
                      //                       EdgeInsets.symmetric(horizontal: 5),
                      //                   child: GestureDetector(
                      //                     onTap: () {
                      //                       showDialog(
                      //                         context: context,
                      //                         builder: (c) => AlertDialog(
                      //                           contentPadding: EdgeInsets.zero,
                      //                           // insetPadding:
                      //                           //     EdgeInsets.zero,
                      //                           buttonPadding: EdgeInsets.zero,
                      //                           content: Container(
                      //                             height: 100,
                      //                             decoration: BoxDecoration(
                      //                               color: Colors.white,
                      //                               borderRadius:
                      //                                   BorderRadius.only(
                      //                                 topLeft:
                      //                                     Radius.circular(5),
                      //                                 topRight:
                      //                                     Radius.circular(5),
                      //                               ),
                      //                             ),
                      //                             child: Column(
                      //                               children: [
                      //                                 Padding(
                      //                                   padding:
                      //                                       const EdgeInsets
                      //                                           .all(8.0),
                      //                                   child: Text(
                      //                                     "คุณต้องการลบ ${value.goodsReceiving!.supplier!.poDocNo![index].head!.docNo} หรือไม่?",
                      //                                     textAlign:
                      //                                         TextAlign.center,
                      //                                     style: _styledefult,
                      //                                   ),
                      //                                 ),
                      //                                 Spacer(),
                      //                                 Row(
                      //                                   children: [
                      //                                     Expanded(
                      //                                       child:
                      //                                           GestureDetector(
                      //                                         onTap: () {
                      //                                           Navigator.pop(
                      //                                               context);
                      //                                           Future.delayed(
                      //                                               Duration(
                      //                                                   milliseconds:
                      //                                                       600),
                      //                                               () => SystemChannels
                      //                                                   .textInput
                      //                                                   .invokeListMethod(
                      //                                                       'TextInput.hide'));
                      //                                         },
                      //                                         child: Container(
                      //                                           alignment:
                      //                                               Alignment
                      //                                                   .center,
                      //                                           height: 40,
                      //                                           color: red,
                      //                                           child: Text(
                      //                                             "ไม่ใช่",
                      //                                             style: _styledefult
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         white),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                     Expanded(
                      //                                       child:
                      //                                           GestureDetector(
                      //                                         onTap: () {
                      //                                           context
                      //                                               .read<
                      //                                                   ControllerGetPoScreen>()
                      //                                               .removeItemInGoodsReceiving(
                      //                                                   index:
                      //                                                       index);

                      //                                           Navigator.pop(
                      //                                               context);
                      //                                           Future.delayed(
                      //                                               Duration(
                      //                                                   milliseconds:
                      //                                                       600),
                      //                                               () => SystemChannels
                      //                                                   .textInput
                      //                                                   .invokeListMethod(
                      //                                                       'TextInput.hide'));
                      //                                         },
                      //                                         child: Container(
                      //                                           height: 40,
                      //                                           alignment:
                      //                                               Alignment
                      //                                                   .center,
                      //                                           color: Colors
                      //                                               .indigo,
                      //                                           child: Text(
                      //                                             "ใช่",
                      //                                             style: _styledefult
                      //                                                 .copyWith(
                      //                                                     color:
                      //                                                         white),
                      //                                           ),
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ],
                      //                                 )
                      //                               ],
                      //                             ),
                      //                           ),
                      //                         ),
                      //                       );
                      //                     },
                      //                     child: Container(
                      //                       width: 60,
                      //                       height: 30,
                      //                       decoration: BoxDecoration(
                      //                           borderRadius:
                      //                               BorderRadius.circular(5),
                      //                           color: Colors.red),
                      //                       child: Icon(
                      //                         Icons.delete,
                      //                         color: white,
                      //                         size: 18,
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         }),
                      //       ],
                      //     );
                      //   }))
                      // ],
                      // SizedBox(
                      //   height: 90,
                      // ),
                    ],
                  ),
                ),
              ),
              if (controller.goodsReceiving != null &&
                  controller.goodsReceiving!.head!
                      .any((element) => element.statusSearch == true))
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.indigo),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: TextButton(
                                onPressed: () async {
                                  bool statuscode = false;
                                  controller.goodsReceiving!.head!
                                      .forEach((element) async {
                                    if (element.statusSearch) {
                                      statuscode = await updateIsLockRecord(
                                          code: 1,
                                          reDocNo: "${element.refDocNo}");

                                      print("statuscode$statuscode");
                                    }
                                  });
                                  if (controller.goodsReceiving!.head!.any(
                                      (element) =>
                                          element.statusSearch == true)) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BeginGetPo(
                                            dbReceiving: context
                                                .read<ControllerGetPoScreen>()
                                                .goodsReceiving!,
                                            date: dateTime ?? DateTime.now()),
                                      ),
                                    );
                                  }

                                  // print(statuscode);
                                  // if (statuscode == true) {

                                  //   // var res = await Navigator.push(
                                  //   //   context,
                                  //   //   MaterialPageRoute(
                                  //   //     builder: (_) => BeginGetPo(
                                  //   //         dbReceiving: context
                                  //   //             .read<ControllerGetPoScreen>()
                                  //   //             .goodsReceiving!,
                                  //   //         date: dateTime ?? DateTime.now()),
                                  //   //   ),
                                  //   // );
                                  //   // if (res == 'OK') {
                                  //   //   Future.delayed(
                                  //   //       Duration(milliseconds: 400),
                                  //   //       () => SystemChannels.textInput
                                  //   //           .invokeListMethod(
                                  //   //               'TextInput.hide'));
                                  //   // } else {
                                  //   //   Future.delayed(
                                  //   //       Duration(milliseconds: 400),
                                  //   //       () => SystemChannels.textInput
                                  //   //           .invokeListMethod(
                                  //   //               'TextInput.hide'));
                                  //   // }
                                  // }
                                },
                                child: Column(
                                  children: [
                                    Text(
                                      "สถานะ PO กำลังรับ เริ่มรับสินค้า",
                                      style: _styledefult.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> updateIsLockRecord(
      {required int code, required String reDocNo}) async {
    bool status = false;
    await RequestAssistant.putRequestHttpResponse(
            url: BaseUrl.url +
                'updatelockrecord?db=0&code=$code&reDocNo=$reDocNo')
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        status = true;
      }
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
    print(status);
    return status;
  }

  void getPolist({required String query}) async {
    // context.read<ControllerGetPoScreen>().goodsReceiving = null;
    var response = await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + "getPoRecive?db=0&query=$query");
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      // print(responseJson["data"]);
      if (context.read<ControllerGetPoScreen>().goodsReceiving != null &&
          context
              .read<ControllerGetPoScreen>()
              .goodsReceiving!
              .head!
              .isNotEmpty) {
        print(query);
        // print(
        //     context.read<ControllerGetPoScreen>().goodsReceiving!.head!.length);
        // updateStatusSearch
        String response = context
            .read<ControllerGetPoScreen>()
            .updateStatusSearch(docNo: query);
        print("response Code$response");
        if (response == '2') {
          Fluttertoast.showToast(msg: "$query Po นี้ยังไม่อนุมัติ");
        } else if (response == '4') {
          Fluttertoast.showToast(msg: "$query Po นี้วันที่สินค้าไม่ตรงกัน");
        } else if (response == '1') {
          Fluttertoast.showToast(
              msg: "$query นี้ไม่ได้อยู่ในเจ้าหนี้นี้หรือประเภทภาษีไม่ตรงกัน");
        }
      } else {
        GoodsReceiving _goodsReceiving =
            GoodsReceiving.fromMap(responseJson["data"]);

        context
            .read<ControllerGetPoScreen>()
            .updateGoodReceiving(ojb: _goodsReceiving);
        String response = context
            .read<ControllerGetPoScreen>()
            .updateStatusSearch(docNo: query, status: true);

        if (response == '2') {
          Fluttertoast.showToast(msg: "$query Po นี้ยังไม่อนุมัติ");
        } else if (response == '4') {
          Fluttertoast.showToast(msg: "$query Po นี้วันที่สินค้าไม่ตรงกัน");
        } else if (response == '1') {
          Fluttertoast.showToast(
              msg: "$query นี้ไม่ได้อยู่ในเจ้าหนี้นี้หรือประเภทภาษีไม่ตรงกัน");
        }
      }

      // setState(() {});
    } else {
      // context.read<ControllerGetPoScreen>().goodsReceiving = null;
      Fluttertoast.showToast(
          msg: "$query นี้ไม่ได้อยู่ในเจ้าหนี้นี้หรือประเภทภาษีไม่ตรงกัน");
    }
    //

    // Provider.of<ControllerGetPoScreen>(context, listen: false)
    //     .updateGoodsReceiving(oject: _goodsReceiving);
    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();
  Future<String?> getCamera() async {
    XFile? imagePath;
    imagePath = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    // setState(() {});
    return imagePath?.path;
  }
}
