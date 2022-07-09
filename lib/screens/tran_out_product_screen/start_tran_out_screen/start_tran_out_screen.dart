import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:wms/screens/tran_out_product_screen/create_barcode_screen/create_barcode_screen.dart';
import 'package:wms/screens/tran_out_product_screen/start_tran_out_success_screen/signature.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/serchbar.dart';

import '../tran_out_product_screen.dart';

class StartTranOutScreen extends StatefulWidget {
  const StartTranOutScreen({
    Key? key,
    required this.detail,
    required this.index1,
    required this.index2,
    // required this.sumQty,
    required this.docNo,
    required this.arName,
    required this.statusQty,
    required this.head,
    required this.indexpageView,
  }) : super(key: key);
  final List<Detail> detail;
  final int index1, index2;
  // final double sumQty;
  final String docNo;
  final String arName;
  final bool statusQty;
  final Head head;
  final int indexpageView;

  @override
  _StartTranOutScreenState createState() => _StartTranOutScreenState();
}

class _StartTranOutScreenState extends State<StartTranOutScreen> {
  List<TextEditingController> _listEditControllerQty = [];
  List<TextEditingController> _listEditControllerRemark = [];
  List<DropdownMenuItem<ListItem>> dropdownMenuItems = [];
  ListItem? _selectedItem;
  bool statusUpdate = false;
  List<ListItem> _dropdownItems = [
    // ListItem("0", "สินค้าขาดสต๊อก"),
    // ListItem("1", "KCV (บริษัท เคซีวี จำกัด)"),
    // ListItem("2", "pgl (บริษัท พีจีแอล เทรดดิ้ง จำกัด)"),
    // ListItem("3", "PGLX1 (PGLX CO,LTD)"),
    // ListItem("4", "UBONTEST (บริษัท ศิริมหาชัย อุบลราชธานี จำกัด)"),
  ];

  initstateDropItem() async {
    await reason();
    dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
  }

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kdefultsize - 10),
            child: Text(
              listItem.name!,
              style: TextStyle(
                fontSize: kdefultsize - 8,
                color: black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  // List<ListItem> listReason = [];
  // ListItem? selectlistReason;

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason() async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    // print(BaseUrl.url + 'reason&db=${db.getselectedItem.value}');
    print(BaseUrl.url + 'reason&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'reason&db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${responseJson["data"]}");
          setState(() {
            _dropdownItems = (responseJson["data"] as List)
                .map((e) => ListItem.fromJson(e))
                .toList();
          });
        }

        //   print(response.body);

        //   var responseJson = json.decode(utf8.decode(response.bodyBytes));
        //   Fluttertoast.showToast(
        //       msg: responseJson["msg"],
        //       backgroundColor: Colors.green,
        //       textColor: white);
        // } else if (response.statusCode == 400) {
        //   var responseJson = json.decode(utf8.decode(response.bodyBytes));
        //   Fluttertoast.showToast(
        //       msg: responseJson["msg"],
        //       backgroundColor: Colors.red,
        //       textColor: white);
        // }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

  @override
  void initState() {
    initstateDropItem();
    List.generate(
        widget.detail.length,
        (index) => {
              _listEditControllerQty.add(TextEditingController(
                  text: '')), //widget.detail[index].eventQty.toString()
              _listEditControllerRemark..add(TextEditingController(text: ""))
            });
    super.initState();
  }

  // Navigator.pop(context)
  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: white,
              fontSize: 10,
            );
    List<Detail> _detail = widget.detail;
    final ControllerTranOutProduct controllerTranOutProduct =
        context.read<ControllerTranOutProduct>();
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => TranOutProductScreen()),
            (route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => TranOutProductScreen()),
                  (route) => false)
              // _listEditControllerQty.asMap().forEach((index3, element) {
              //   controllerTranOutProduct.updateStatus(
              //       index1: widget.index1, index2: widget.index2, index3: index3);
              //   controllerTranOutProduct.updateEventQty(
              //       index1: widget.index1,
              //       index2: widget.index2,
              //       index3: index3,
              //       eventQty: widget.detail[index3].eventQty! -
              //           double.parse(element.text.isEmpty ? '0' : element.text));
              // }),
              // Navigator.pop(context),
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              size: kdefultsize,
              color: black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text("กำลังจัด"),
          backgroundColor: Colors.yellow[700],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.detail.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "เลขที่เอกสาร : ${widget.docNo}",
                                style: _textStyle.copyWith(
                                  color: black,
                                ),
                              ),
                              Text(
                                "ลูกค้า : ${widget.head.arName}",
                                style: _textStyle.copyWith(
                                  color: black,
                                ),
                              ),
                              Text(
                                "ประเภทการส่ง : ${widget.head.sendType}",
                                style: _textStyle.copyWith(
                                  color: black,
                                ),
                              ),
                              Text(
                                "${widget.head.detail![0].whCode} ~ ${widget.head.detail![0].shelfCode}  ${widget.head.detail![0].nameShlfCode}",
                                style: _textStyle.copyWith(
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  ...List.generate(
                      _detail.length,
                      (index) => Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: _detail[index].statussuccess
                                        ? Colors.green.shade700
                                        : red)),
                            child: ListTile(
                              onTap: () {
                                // Navigator.pop(
                                //     context);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           StartTranOutScreen(
                                //               detail: _detail[index]),
                                //     ));
                              },
                              minLeadingWidth: 5,
                              title: Text(
                                "${(_detail[index].lineNumber! + 1).toString()} : ${_detail[index].icCode.toString()} : ${_detail[index].itemName.toString()}",
                                style: _textStyle.copyWith(
                                    color: black, fontSize: 8),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "รอจัด ${_detail[index].diffQty.toString()}",
                                        style: _textStyle.copyWith(
                                            color: black, fontSize: 8),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "จัดได้ ${double.parse(((_detail[index].eventQty! - double.parse(_listEditControllerQty[index].text.isEmpty ? "0" : _listEditControllerQty[index].text.toString())).toString())) < 0 ? double.parse(((_detail[index].eventQty! - double.parse(_listEditControllerQty[index].text.isEmpty ? "0" : _listEditControllerQty[index].text.toString())).toString())) * -1 : ((_detail[index].eventQty! - double.parse(_listEditControllerQty[index].text.isEmpty ? "0" : _listEditControllerQty[index].text.toString())).toString())}",
                                        style: _textStyle.copyWith(
                                            color: black, fontSize: 8),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "จำนวน",
                                        style: _textStyle.copyWith(
                                            color: red, fontSize: 8),
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          height: 30,
                                          child: SearchBar(
                                            fontSize: 10,
                                            controller:
                                                _listEditControllerQty[index],
                                            keyboardType: TextInputType.number,
                                            title: '',
                                            iconSize: 0,
                                            contentPadding: 10,
                                            enabled:
                                                !_detail[index].statussuccess,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      Colors.orange.shade400)),
                                          onPressed: () {
                                            setState(() {
                                              _detail[index].statussuccess =
                                                  false;
                                              _detail[index]
                                                  .eventQty = (_detail[index]
                                                      .eventQty! -
                                                  double.parse(
                                                      _listEditControllerQty[
                                                              index]
                                                          .text));
                                              _listEditControllerQty[index]
                                                  .clear();

                                              // _detail[index].eventQty =
                                              //     _detail[index].eventQty! -
                                              //         int.parse(
                                              //             _listEditControllerQty[
                                              //                     index]
                                              //                 .text);
                                            });
                                          },
                                          child: Text(
                                            "แก้ไข",
                                            style: _textStyle.copyWith(
                                                color: white, fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 60,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            if (_listEditControllerQty[index]
                                                .text
                                                .isNotEmpty) {
                                              // _detail[index].eventQty =
                                              //     double.parse(
                                              //             _listEditControllerQty[
                                              //                     index]
                                              //                 .text
                                              //                 .toString()) +
                                              //         double.parse(_detail[index]
                                              //             .eventQty
                                              //             .toString());

                                              print(
                                                  "QTY ${double.parse(_listEditControllerQty[index].text.toString())} == ${_detail[index].qty}");

                                              if (!_detail[index]
                                                  .statussuccess) {
                                                if ((double.parse(
                                                            _listEditControllerQty[
                                                                    index]
                                                                .text) +
                                                        _detail[index]
                                                            .eventQty!) <
                                                    _detail[index].qty!) {
                                                  print(
                                                      "จำนวนที่รับมาน้อบกว่า จำนวนที่อยู่ในระบบ");
                                                  showDialog<void>(
                                                    context: context,
                                                    barrierDismissible:
                                                        false, // user must tap button!
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                            "ระบุสาเหตุที่จัดสินค้าได้ไม่ครบ",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                        ),
                                                        content:
                                                            SingleChildScrollView(
                                                          child: ListBody(
                                                            children: <Widget>[
                                                              DropdownButton<
                                                                  ListItem>(
                                                                isExpanded:
                                                                    true,
                                                                value: _selectedItem ??
                                                                    _dropdownItems[
                                                                        0],
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  size: 12,
                                                                ),
                                                                elevation: 16,
                                                                style: TextStyle(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        12),
                                                                underline:
                                                                    Container(),
                                                                onChanged:
                                                                    (ListItem?
                                                                        newValue) {},
                                                                items:
                                                                    dropdownMenuItems,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                child:
                                                                    TextField(
                                                                  maxLines: 3,
                                                                  style: _textStyle
                                                                      .copyWith(
                                                                          color:
                                                                              black),
                                                                  decoration: InputDecoration
                                                                      .collapsed(
                                                                          hintText:
                                                                              "ระบุหมายเหตุ"),
                                                                  controller:
                                                                      _listEditControllerRemark[
                                                                          index],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.red[700])),
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'ปิด',
                                                                  style: _textStyle.copyWith(
                                                                      color:
                                                                          white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    backgroundColor:
                                                                        MaterialStateProperty.all(
                                                                            Colors.blue[700])),
                                                                onPressed:
                                                                    () async {
                                                                  if (_listEditControllerRemark[
                                                                          index]
                                                                      .text
                                                                      .isNotEmpty) {
                                                                    String
                                                                        _str =
                                                                        "${_listEditControllerRemark[index].text},${_selectedItem == null ? _dropdownItems[0].name : _selectedItem!.name}";
                                                                    print(_str);

                                                                    controllerTranOutProduct.updateRemark(
                                                                        index1: widget
                                                                            .index1,
                                                                        index2: widget
                                                                            .index2,
                                                                        linenumber:
                                                                            _detail[index]
                                                                                .lineNumber!,
                                                                        remark:
                                                                            _str);
                                                                    controllerTranOutProduct.updateEventQty(
                                                                        index1: widget
                                                                            .index1,
                                                                        index2: widget
                                                                            .index2,
                                                                        linenumber:
                                                                            _detail[index]
                                                                                .lineNumber!,
                                                                        eventQty:
                                                                            (double.parse(_listEditControllerQty[index].text) +
                                                                                _detail[index].eventQty!));

                                                                    // await updatestatusRemark(
                                                                    //     docNo: _detail[
                                                                    //             index]
                                                                    //         .docNo!,
                                                                    //     remark: _str
                                                                    //         .toString());
                                                                  } else {
                                                                    print(
                                                                        "${_selectedItem == null ? _dropdownItems[0].name : _selectedItem!.name}");
                                                                    controllerTranOutProduct.updateRemark(
                                                                        index1: widget
                                                                            .index1,
                                                                        index2: widget
                                                                            .index2,
                                                                        linenumber:
                                                                            _detail[index]
                                                                                .lineNumber!,
                                                                        remark:
                                                                            "${_selectedItem == null ? _dropdownItems[0].name : _selectedItem!.name}");

                                                                    controllerTranOutProduct.updateEventQty(
                                                                        index1: widget
                                                                            .index1,
                                                                        index2: widget
                                                                            .index2,
                                                                        linenumber:
                                                                            _detail[index]
                                                                                .lineNumber!,
                                                                        eventQty:
                                                                            (double.parse(_listEditControllerQty[index].text) +
                                                                                _detail[index].eventQty!));
                                                                    // await updatestatusRemark(
                                                                    //     docNo: _detail[
                                                                    //             index]
                                                                    //         .docNo!,
                                                                    //     remark:
                                                                    //         "${_selectedItem == null ? _dropdownItems[0].name : _selectedItem!.name}");
                                                                  }
                                                                  setState(() {
                                                                    _detail[index]
                                                                            .statussuccess =
                                                                        true;
                                                                  });

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                  'บันทึก',
                                                                  style: _textStyle.copyWith(
                                                                      color:
                                                                          white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  );
                                                } else if ((double.parse(
                                                            _listEditControllerQty[
                                                                    index]
                                                                .text) +
                                                        _detail[index]
                                                            .eventQty!) ==
                                                    _detail[index].qty!) {
                                                  controllerTranOutProduct
                                                      .updateEventQty(
                                                          index1: widget.index1,
                                                          index2: widget.index2,
                                                          linenumber:
                                                              _detail[index]
                                                                  .lineNumber!,
                                                          eventQty: (double.parse(
                                                                  _listEditControllerQty[
                                                                          index]
                                                                      .text) +
                                                              _detail[index]
                                                                  .eventQty!));
                                                  // _detail[index]
                                                  //     .eventQty = _detail[index]
                                                  //         .eventQty! +
                                                  //     double.parse(
                                                  //         _listEditControllerQty[
                                                  //                 index]
                                                  //             .text);

                                                  setState(() {
                                                    _detail[index]
                                                        .statussuccess = true;
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "จ่ายเกินกว่าจำนวนจัด");
                                                }
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "ระบุจำนวนจ่ายไปแล้ว");
                                              }
                                            }
                                          },
                                          child: Text(
                                            "ตกลง",
                                            style: _textStyle.copyWith(
                                                color: white, fontSize: 10),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[700])),
                        onPressed: () async {
                          // Navigator.of(
                          //         context)
                          //     .pop();
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            // user must tap button!

                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ยืนยันการจัดสินค้าเลขที่",
                                      style: _textStyle.copyWith(
                                          color: black,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text(
                                        "${widget.detail[0].docNo}",
                                        style: _textStyle.copyWith(
                                            color: black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "พื้นที่เก็บ : ${widget.detail[0].shelfCode}",
                                        style: _textStyle.copyWith(
                                            color: black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      Text(
                                        "(แนบรูปภาพพื้นที่ที่วางสินค้า-จัดเสร็จ)~ไม่พบฟิว",
                                        style: _textStyle.copyWith(
                                            color: black,
                                            fontSize: 8,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      // ...List.generate(widget.detail.length,
                                      //     (index3) {
                                      //   List<Detail> _subdetail = widget.detail;
                                      //   return Container(
                                      //     margin: EdgeInsets.symmetric(
                                      //         horizontal: 0, vertical: 5),
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.circular(10),
                                      //       border: Border.all(
                                      //           color: _subdetail[index3]
                                      //                   .statussuccess
                                      //               ? Colors.green.shade700
                                      //               : red),
                                      //     ),
                                      //     child: ListTile(
                                      //       onTap: () {
                                      //         // Navigator.pop(
                                      //         //     context);
                                      //         // Navigator.push(
                                      //         //     context,
                                      //         //     MaterialPageRoute(
                                      //         //       builder: (context) =>
                                      //         //           StartTranOutScreen(
                                      //         //               detail: _subdetail[index3]),
                                      //         //     ));
                                      //       },
                                      //       minLeadingWidth: 5,
                                      //       title: Text(
                                      //         "${(_subdetail[index3].lineNumber! + 1).toString()} : ${_subdetail[index3].icCode.toString()} : ${_subdetail[index3].itemName.toString()}",
                                      //         style: _textStyle.copyWith(
                                      //             color: black, fontSize: 8),
                                      //       ),
                                      //       subtitle: Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: [
                                      //           Row(
                                      //             children: [
                                      //               Text(
                                      //                 "${_subdetail[index3].shelfCode.toString()} ~ ",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Text(
                                      //                 "หน่วยนับ ",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Text(
                                      //                 "${_subdetail[index3].unitCode.toString()} ~ ${_subdetail[index3].unitName.toString()}",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Spacer(),
                                      //               Text(
                                      //                 "รอจ่าย :",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Text(
                                      //                 "${_subdetail[index3].diffQty.toString()}",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               )
                                      //             ],
                                      //           ),
                                      //           Row(
                                      //             children: [
                                      //               // InkWell(
                                      //               //   onTap: () {},
                                      //               //   child: Text(
                                      //               //     "ดูตำแหน่งสินค้า",
                                      //               //     style:
                                      //               //         _textStyle.copyWith(
                                      //               //             color: Colors
                                      //               //                 .green[800],
                                      //               //             fontSize: 8),
                                      //               //   ),
                                      //               // ),
                                      //               Text(
                                      //                 "  จ่าย :",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: red,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Text(
                                      //                 "${_listEditControllerQty[index3].text}",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: red,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Spacer(),
                                      //               Text(
                                      //                 "จ่ายจริง :",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: black,
                                      //                     fontSize: 8),
                                      //               ),
                                      //               Text(
                                      //                 "${_subdetail[index3].qty.toString()}",
                                      //                 style: _textStyle.copyWith(
                                      //                     color: red,
                                      //                     fontSize: 8),
                                      //               )
                                      //               // SizedBox(
                                      //               //   height: 25,
                                      //               //   width: 40,
                                      //               //   child: SearchBar(
                                      //               //     contentPadding: 5,
                                      //               //     fontSize: 8,
                                      //               //     title: "",
                                      //               //     iconSize: 0,
                                      //               //   ),
                                      //               // )
                                      //             ],
                                      //           )
                                      //         ],
                                      //       ),
                                      //     ),
                                      //   );
                                      // }),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.purple[700])),
                                            onPressed: () async {
                                              bool _createBarCode = false;
                                              Navigator.of(context).pop();
                                              bool status = widget.detail.any(
                                                  (element) =>
                                                      element.statussuccess ==
                                                      false);
                                              if (status) {
                                                Fluttertoast.showToast(
                                                    msg: "กรุณาทำรายการให้ครบ");
                                              } else {
                                                // print(widget.sumQty);
                                                double _sumQty = 0;
                                                double _sumQtyOfBin = 0;
                                                double headersumQty = 0;

                                                controllerTranOutProduct
                                                    .data[widget.indexpageView]
                                                    .head!
                                                    .forEach((element) {
                                                  if (element.custCode ==
                                                      widget.head.custCode) {
                                                    element.detail!
                                                        .forEach((element2) {
                                                      headersumQty +=
                                                          element2.eventQty!;
                                                    });
                                                  }
                                                });
                                                // widget.head.detail!
                                                //     .forEach((element) {
                                                //   headersumQty +=
                                                //       element.eventQty!;
                                                // });
                                                widget.detail
                                                    .forEach((element) async {
                                                  _sumQty += element.eventQty!;
                                                  _sumQtyOfBin += element.qty!;

                                                  // print(element.docNo!);
                                                  print(
                                                      '=>>>>>>>>>>${element.eventQty.toString()}');
                                                  print(element.lineNumber!
                                                      .toString());
                                                });
                                                print(
                                                    "boolean ==== ${widget.statusQty}");
                                                print(
                                                    "$_sumQty == $_sumQtyOfBin");
                                                // ! งานเก่า **********************************
                                                // if ((_sumQty == _sumQtyOfBin) &&
                                                //     headersumQty ==
                                                //         widget.head.sumQty) {
                                                //   widget.detail
                                                //       .forEach((element) async {
                                                //     if (element.remark !=
                                                //             null &&
                                                //         element.remark!
                                                //             .isNotEmpty) {
                                                //       await updatestatusRemark(
                                                //           docNo: element.docNo!,
                                                //           remark:
                                                //               element.remark!,
                                                //           lineNumber: element
                                                //               .lineNumber!
                                                //               .toString()
                                                //               .trim());
                                                //     }
                                                //     await updatestatuspayment(
                                                //         docNo: element.docNo!,
                                                //         isConfirm: "1",
                                                //         status: "1",
                                                //         qty: element.eventQty
                                                //             .toString(),
                                                //         lineNumber: element
                                                //             .lineNumber!
                                                //             .toString());
                                                //     await updatestatuswaitpayment(
                                                //         isPrint: "1",
                                                //         docNo: element.docNo!);
                                                //     _createBarCode = true;
                                                //     print("เท่ากัน");
                                                //   });

                                                //   Navigator.pushAndRemoveUntil(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (_) =>
                                                //               CreateBarCode(
                                                //                 head:
                                                //                     widget.head,
                                                //                 arName: widget
                                                //                     .arName,
                                                //               )),
                                                //       (route) => false);
                                                // } else {
                                                //   widget.detail
                                                //       .forEach((element) async {
                                                //     await updatestatuspayment(
                                                //         docNo: element.docNo!,
                                                //         isConfirm: "0",
                                                //         status: "0",
                                                //         qty: element.eventQty
                                                //             .toString(),
                                                //         lineNumber: element
                                                //             .lineNumber!
                                                //             .toString());

                                                //     await updatestatuswaitpayment(
                                                //         isPrint: "0",
                                                //         docNo: element.docNo!);
                                                //     print("ไม่เท่ากัน");
                                                //   });
                                                //   Navigator.pushAndRemoveUntil(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //           builder: (_) =>
                                                //               TranOutProductScreen()),
                                                //       (route) => false);
                                                // }
                                                // ! งานเก่า ***************************
                                                print(
                                                    widget.head.detail!.length);
                                                if (((_sumQty ==
                                                            _sumQtyOfBin) &&
                                                        headersumQty ==
                                                            widget
                                                                .head.sumQty) ||
                                                    widget.head.detail!
                                                            .length ==
                                                        1) {
                                                  widget.detail
                                                      .forEach((element) async {
                                                    if (element.remark !=
                                                            null &&
                                                        element.remark!
                                                            .isNotEmpty) {
                                                      await updatestatusRemark(
                                                          docNo: element.docNo!,
                                                          remark:
                                                              element.remark!,
                                                          lineNumber: element
                                                              .lineNumber!
                                                              .toString()
                                                              .trim());
                                                    }
                                                    await updatestatuspayment(
                                                        docNo: element.docNo!,
                                                        isConfirm: "1",
                                                        status: "1",
                                                        qty: element.eventQty
                                                            .toString(),
                                                        lineNumber: element
                                                            .lineNumber!
                                                            .toString());
                                                    await updatestatuswaitpayment(
                                                        isPrint: "1",
                                                        docNo: element.docNo!);
                                                    _createBarCode = true;
                                                    print("เท่ากัน");
                                                  });
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              CreateBarCode(
                                                                head:
                                                                    widget.head,
                                                                arName: widget
                                                                    .arName,
                                                                eventdate:
                                                                    DateTime
                                                                        .now(),
                                                              )),
                                                      (route) => false);
                                                } else {
                                                  widget.detail
                                                      .forEach((element) async {
                                                    if (element.remark !=
                                                            null &&
                                                        element.remark!
                                                            .isNotEmpty) {
                                                      await updatestatusRemark(
                                                          docNo: element.docNo!,
                                                          remark:
                                                              element.remark!,
                                                          lineNumber: element
                                                              .lineNumber!
                                                              .toString()
                                                              .trim());
                                                    }
                                                    await updatestatuspayment(
                                                        docNo: element.docNo!,
                                                        isConfirm: "1",
                                                        status: "1",
                                                        qty: element.eventQty
                                                            .toString(),
                                                        lineNumber: element
                                                            .lineNumber!
                                                            .toString());
                                                    await updatestatuswaitpayment(
                                                        isPrint: "1",
                                                        docNo: element.docNo!);
                                                    _createBarCode = true;
                                                    print("ไม่เท่ากัน");
                                                  });
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              TranOutProductScreen()),
                                                      (route) => false);
                                                }
                                              }
                                            },
                                            child: Text(
                                              'ยืนยันจัดเสร็จ',
                                              style: _textStyle.copyWith(
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'จัดเสร็จ รอจ่าย',
                          style: _textStyle.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue[700]),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                        onPressed: () async {
                          bool? _check =
                              await islockrecord(docNo: widget.docNo);
                          if (_check == null) {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Text(
                                    'ข้อความแจ้งเตือน',
                                    style: _textStyle.copyWith(fontSize: 12),
                                  )),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'มีการแก้ไขเอกสารขายเลขที่ ${widget.docNo}\nกรุณาปิดใบจัดก่อน',
                                          textAlign: TextAlign.center,
                                          style: _textStyle,
                                        ),
                                        // Text('Would you like to approve of this message?'),
                                      ],
                                    ),
                                  ),
                                  // actions: <Widget>[
                                  //   TextButton(
                                  //     child: const Text('Approve'),
                                  //     onPressed: () {
                                  //       Navigator.of(context).pop();
                                  //     },
                                  //   ),
                                  // ],
                                );
                              },
                            );
                          } else if (_check) {
                            bool status = widget.detail.any(
                                (element) => element.statussuccess == false);
                            if (status) {
                              Fluttertoast.showToast(
                                  msg: "กรุณาทำรายการให้ครบ");
                            } else {
                              var res = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignTure(
                                      detail: widget.detail,
                                    ),
                                  ));
                              if (res == 'OK') {
                                await updatestatusclosepayment(
                                    docNo: widget.docNo);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => TranOutProductScreen()),
                                    (route) => false);
                              }

                              // print(widget.sumQty);
                              // double _sumQty = 0;
                              // widget.detail.forEach((element) async {
                              //   _sumQty += element.eventQty!;
                              //   print(element.docNo!);
                              //   print(element.eventQty.toString());
                              //   print(element.lineNumber!.toString());
                              //   // await updatestatuspayment(
                              //   //     docNo: element.docNo!,
                              //   //     qty: element.eventQty.toString(),
                              //   //     lineNumber: element.lineNumber!.toString());
                              // });
                              // ! ปิดใบจัดเพราะยอดครบ
                              // if (_sumQty == widget.sumQty) {
                              //   await updatestatusclosepayment(docNo: widget.docNo);
                              // }
                              // Navigator.pop(context, 'OK');
                            }
                          } else {
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                      child: Text(
                                    'ข้อความแจ้งเตือน',
                                    style: _textStyle.copyWith(fontSize: 12),
                                  )),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(
                                          'มีการแก้ไขเอกสารขายเลขที่ ${widget.docNo}\nกรุณาปิดใบจัดก่อน',
                                          textAlign: TextAlign.center,
                                          style: _textStyle,
                                        ),
                                        // Text('Would you like to approve of this message?'),
                                      ],
                                    ),
                                  ),
                                  // actions: <Widget>[
                                  //   TextButton(
                                  //     child: const Text('Approve'),
                                  //     onPressed: () {
                                  //       Navigator.of(context).pop();
                                  //     },
                                  //   ),
                                  // ],
                                );
                              },
                            );
                          }
                        },
                        child: Text(
                          'จัดเสร็จ จ่ายสินค้า',
                          style: _textStyle.copyWith(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool?> islockrecord({required String docNo}) async {
    print(BaseUrl.url + 'lockrecord?doc_no=$docNo');
    bool status = false;
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url + 'lockrecord?doc_no=$docNo')
          .then((response) {
        print(response.body);
        if (response.statusCode == 200) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          status = responseJson["data"]["status"];
        } else if (response.statusCode == 400) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
    return status;
  }

  // ! อัพเดทสถานะไปแทบจัดเสร็จรอจ่าย
  Future<void> updatestatuspayment(
      {required String docNo,
      required String qty,
      required String lineNumber,
      required String isConfirm,
      required String status}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusPayment?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      var bodyFields = {
        'event_qty': qty,
        'status': status,
        'is_confirm': isConfirm
      };
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusPayment?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}',
              body: bodyFields)
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(
              msg: responseJson["msg"],
              backgroundColor: Colors.green,
              textColor: white);
          statusUpdate = true;
        } else if (response.statusCode == 400) {
          statusUpdate = false;
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        } else {
          statusUpdate = false;
        }
      });
    } catch (e) {
      statusUpdate = false;
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
  }

  // ! ปิดสถานะบิล
  Future<void> updatestatusclosepayment({required String docNo}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusClosePayment?doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusClosePayment?doc_no=$docNo&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(
              msg: responseJson["msg"],
              backgroundColor: Colors.green,
              textColor: white);
          statusUpdate = true;
        } else if (response.statusCode == 400) {
          statusUpdate = false;
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        } else {
          statusUpdate = false;
        }
      });
    } catch (e) {
      statusUpdate = false;

      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

  // ! บันทึกหมายเหตุ
  Future<void> updatestatusRemark(
      {required String docNo,
      required String remark,
      required String lineNumber}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateRemark?remark=$remark 2&doc_no=$docNo&line_number=$lineNumber&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateRemark?remark=$remark 2&doc_no=$docNo&line_number=$lineNumber&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          statusUpdate = true;

          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(
              msg: responseJson["msg"],
              backgroundColor: Colors.green,
              textColor: white);
        } else if (response.statusCode == 400) {
          statusUpdate = false;
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        } else {
          statusUpdate = false;
        }
      });
    } catch (e) {
      statusUpdate = false;

      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

  // ! กลับไปรอจัด สถานะ isPrint = 0
  Future<void> updatestatuswaitpayment(
      {required String docNo, required String isPrint}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusWaitPayment?is_print=$isPrint&doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusWaitPayment?is_print=$isPrint&doc_no=$docNo&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(
              msg: responseJson["msg"],
              backgroundColor: Colors.green,
              textColor: white);
        } else if (response.statusCode == 400) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      throw Exception(e);
    } finally {}
  }
}
