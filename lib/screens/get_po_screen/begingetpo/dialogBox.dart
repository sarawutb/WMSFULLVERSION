import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wms/models/GoodsReceiving.dart';
import 'package:wms/themes/colors.dart';

import '../../../controllers/controller_get_po_screen.dart';
import 'dart:async';
import 'dart:io';

class ShowDialogGetRecevices extends StatefulWidget {
  const ShowDialogGetRecevices({
    Key? key,
    // required this.goodsReceiving,
    // required this.index,
    // // required this.index2
    // required this.detail
  }) : super(key: key);
  // final GoodsReceiving goodsReceiving;
  // final int index;
  // // final int index2;
  // final List<Detail> detail;
  @override
  State<ShowDialogGetRecevices> createState() => _ShowDialogGetRecevicesState();
}

class _ShowDialogGetRecevicesState extends State<ShowDialogGetRecevices> {
  // TextEditingController receiveQty = TextEditingController(text: "0");
  // TextEditingController reMark = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14);
    Size size = MediaQuery.of(context).size;

    // List<PoDocNo> _poDocNo = widget.goodsReceiving.supplier!.poDocNo!;
    // final ControllerGetPoScreen data =
    //     Provider.of<ControllerGetPoScreen>(context, listen: false);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, 'FALSE');

        return Future.value(false);
      },
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          color: Colors.white,
          child: Stack(children: [
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Consumer<ControllerGetPoScreen>(
                    builder: (context, data, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            // border: Border.all(color: Colors.indigo),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.wysiwyg,
                                color: white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "เจ้าหนี้ : ${data.goodsReceiving!.apName ?? ''}",
                                    style: _styledefult.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        ...List.generate(data.goodsReceiving!.head!.length,
                            (indexpo) {
                          List<Head> _listPo = data.goodsReceiving!.head!;
                          return _listPo[indexpo].statusSearch
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (_listPo[indexpo].statusSearch &&
                                          (_listPo[indexpo].detail!.any(
                                              (element) =>
                                                  element.statusSearch ==
                                                      true &&
                                                  element.statusSuccess ==
                                                      false)))
                                        Text(
                                          "${_listPo[indexpo].docNo ?? ''}",
                                          style: _styledefult.copyWith(
                                              color: black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                      ...List.generate(
                                          _listPo[indexpo].detail!.length,
                                          (indexdetail) {
                                        List<Detail> _detail =
                                            _listPo[indexpo].detail!;
                                        return (_detail[indexdetail]
                                                    .statusSearch &&
                                                _detail[indexdetail]
                                                        .statusSuccess ==
                                                    false)
                                            ? Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 20,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.indigo.shade100,
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.place,
                                                          color: Colors.red,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "${_detail[indexdetail].shelfCode} ~ ${_detail[indexdetail].whCode ?? ''} ${_detail[indexdetail].statusSearch}::${_detail[indexdetail].statusSuccess}",
                                                          style: _styledefult
                                                              .copyWith(
                                                            color:
                                                                Colors.indigo,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 10,
                                                            horizontal: 10),
                                                    decoration: BoxDecoration(
                                                      // color: Colors.indigo.shade100,
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${(_detail[indexdetail].lineNumber! + 1)} : ${_detail[indexdetail].itemCode} - ${_detail[indexdetail].itemName}",
                                                            style: _styledefult
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13,
                                                              color: black,
                                                            ),
                                                          ),
                                                          Text(
                                                            "ราคา : ${_detail[indexdetail].price} บาท",
                                                            style: _styledefult
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        13,
                                                                    color: Colors
                                                                        .indigo),
                                                          ),
                                                        ]),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.grey
                                                                  .shade200,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade200),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        3),
                                                            child:
                                                                TextFormField(
                                                              style:
                                                                  _styledefult
                                                                      .copyWith(
                                                                color: Colors
                                                                    .indigo,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              onChanged:
                                                                  (value) {},
                                                              controller: _detail[
                                                                      indexdetail]
                                                                  .eventQty,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              decoration: new InputDecoration
                                                                      .collapsed(
                                                                  hintText:
                                                                      'ระบุจำนวน'),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "หน่วย ${_detail[indexdetail].unitCode} - ${_detail[indexdetail].unitName ?? ''}",
                                                          style: _styledefult
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .indigo),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding: EdgeInsets.only(
                                                        left: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.indigo),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            margin:
                                                                EdgeInsets.all(
                                                                    5),
                                                            child:
                                                                TextFormField(
                                                              controller: _detail[
                                                                      indexdetail]
                                                                  .controllerdiffreceivingRemark,
                                                              style:
                                                                  _styledefult
                                                                      .copyWith(
                                                                color: Colors
                                                                    .indigo,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              // controller: receiveQty,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,

                                                              maxLines: 3,
                                                              decoration: new InputDecoration
                                                                      .collapsed(
                                                                  hintText:
                                                                      'หมายเหตุ'),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      String? path =
                                                          await getCamera();
                                                      if (path != null) {
                                                        data.addImagePathItemInGoodsReceviceing(
                                                            index:
                                                                _listPo[indexpo]
                                                                    .docNo!,
                                                            value: path,
                                                            index2:
                                                                indexdetail);
                                                      }
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 5),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10,
                                                              horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.indigo,
                                                        border: Border.all(
                                                            color:
                                                                Colors.indigo),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.camera,
                                                            color: white,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "รูปภาพ",
                                                            style: _styledefult
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        white),
                                                          ),
                                                          Spacer(),
                                                          Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "จำนวน ${_detail[indexdetail].imagePathDetail.length} รูป",
                                                                style: _styledefult.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        white),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          ...List.generate(
                                                              _detail[indexdetail]
                                                                  .imagePathDetail
                                                                  .length,
                                                              (index) =>
                                                                  Container(
                                                                      width:
                                                                          100.00,
                                                                      height:
                                                                          100.00,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              5),
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        image:
                                                                            new DecorationImage(
                                                                          image:
                                                                              FileImage(File(
                                                                            _detail[indexdetail].imagePathDetail[index].toString(),
                                                                          )),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                      )))
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : SizedBox.shrink();
                                      })
                                    ],
                                  ),
                                )
                              : SizedBox.shrink();
                        }),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ),
                // Spacer(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, 'FALSE');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 181, 63, 63),
                            border: Border.all(
                                color: Color.fromARGB(255, 181, 63, 63)),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                            ),
                          ),
                          child: Text(
                            "ปิด",
                            style: _styledefult.copyWith(color: white
                                // fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context
                              .read<ControllerGetPoScreen>()
                              .goodsReceiving!
                              .head!
                              .forEach((element) {
                            if (element.statusSearch) {}
                            element.detail!.asMap().forEach((index, element2) {
                              if (element2.statusSearch) {
                                context
                                    .read<ControllerGetPoScreen>()
                                    .clearGoodsReceviceing(
                                        linenumber:
                                            element.detail![index].lineNumber!,
                                        index: element.docNo!);
                              }
                            });
                          });

                          setState(() {});

                          // Navigator.pop(context, 'NO');
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 235, 168, 67),
                              border: Border.all(
                                  color: Color.fromARGB(255, 235, 168, 67)),
                            ),
                            child: Text(
                              "เคลียร์",
                              style: _styledefult.copyWith(color: white
                                  // fontWeight: FontWeight.bold,
                                  ),
                            )),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          bool status = false;
                          bool statusNavigator = false;
                          context
                              .read<ControllerGetPoScreen>()
                              .goodsReceiving!
                              .head!
                              .forEach((element) {
                            print("DOCNO ==>${element.docNo}");
                            if (element.detail!.any(
                                (element) => element.eventQty!.text.isEmpty)) {
                              status = true;
                            }
                            element.detail!.forEach((element) {
                              print(element.eventQty!.text);
                            });
                          });

                          if (status) {
                            Fluttertoast.showToast(msg: "กรุณาระบุจำนวนให้ครบ");
                          } else {
                            context
                                .read<ControllerGetPoScreen>()
                                .goodsReceiving!
                                .head!
                                .forEach((element) {
                              if (element.statusSearch) {
                                element.detail!
                                    .asMap()
                                    .forEach((index, element2) {
                                  if (element2.statusSearch) {
                                    if (((double.parse(
                                                element2.eventQty!.text)) <=
                                            (element.detail![index].qty!)) &&
                                        double.parse(element2.eventQty!.text) >=
                                            0) {
                                      context
                                          .read<ControllerGetPoScreen>()
                                          .updateEventQtyItemInGoodsReceviceing(
                                              index: element.docNo!,
                                              index2: index,
                                              eventQty: double.parse(
                                                  element2.eventQty!.text));
                                      context
                                          .read<ControllerGetPoScreen>()
                                          .updateItemInGoodsReceivingSuccessIsTrue(
                                              index: element.docNo!,
                                              index2: index);
                                    } else {
                                      statusNavigator = true;
                                      Fluttertoast.showToast(
                                          msg:
                                              "กรุณาระบุจำนวนที่มากกว่า 0 และต้องไม่มากกว่าจำนวนรับได้");
                                    }
                                  }
                                });
                              }
                            });
                          }

                          SystemChannels.textInput
                              .invokeListMethod('TextInput.hide');
                          if (statusNavigator == false && status == false) {
                            Navigator.pop(context, 'OK');
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              border: Border.all(color: Colors.indigo),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                              ),
                            ),
                            child: Text(
                              "บันทึก",
                              style: _styledefult.copyWith(color: white
                                  // fontWeight: FontWeight.bold,
                                  ),
                            )),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ]),
        ),
      ),
    );
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
