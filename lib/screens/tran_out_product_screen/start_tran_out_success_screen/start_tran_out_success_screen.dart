import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:wms/screens/tran_out_product_screen/start_tran_out_success_screen/signature.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/serchbar.dart';

import '../tran_out_product_screen.dart';

class StartTranOutSuccessScreen extends StatefulWidget {
  const StartTranOutSuccessScreen({
    Key? key,
    required this.detail,
    required this.index1,
    required this.index2,
    required this.sumPayQty,
    required this.docNo,
    required this.head,
  }) : super(key: key);
  final List<Detail> detail;
  final int index1, index2;
  final double sumPayQty;
  final String docNo;
  final Head head;
  @override
  _StartTranOutSuccessScreenState createState() =>
      _StartTranOutSuccessScreenState();
}

class _StartTranOutSuccessScreenState extends State<StartTranOutSuccessScreen> {
  List<TextEditingController> _listEditControllerQty = [];
  List<TextEditingController> _listEditControllerRemark = [];
  List<DropdownMenuItem<ListItem>> dropdownMenuItems = [];
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool statusUpdate = false;

  @override
  void initState() {
    List.generate(
        widget.detail.length,
        (index) => {
              _listEditControllerQty.add(TextEditingController(text: '0')),
              _listEditControllerRemark.add(TextEditingController(text: ''))
              // widget.detail[index].eventQty.toString()
              // if (widget.detail[index].eventQty == widget.detail[index].qty)
              //   {
              //     controllerTranOutProduct.updateStatusSuccess(
              //         index1: widget.index1,
              //         index2: widget.index2,
              //         linenumber: widget.detail[index].lineNumber!)
              //   }
            });
    super.initState();
    initstateDropItem();
  }

  initstateDropItem() async {
    ControllerTranOutProduct controllerTranOutProduct =
        context.read<ControllerTranOutProduct>();
    await reason();
    controllerTranOutProduct.updateDropdownbutton(
        listItem: controllerTranOutProduct.dropdownItems[0]);
  }

  // List<ListItem> listReason = [];
  // ListItem? selectlistReason;

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason() async {
    ControllerTranOutProduct controllerTranOutProduct =
        context.read<ControllerTranOutProduct>();
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url + 'reason?db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'reason?db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${responseJson["data"]}");
          // setState(() {
          //   _dropdownItems = (responseJson["data"] as List)
          //       .map((e) => ListItem.fromJson(e))
          //       .toList();
          // });
          controllerTranOutProduct.updateListDropdownbutton(
              listItem: (responseJson["data"] as List)
                  .map((e) => ListItem.fromJson(e))
                  .toList());
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
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: 10,
            );
    List<Detail> _detail = widget.detail;
    final ControllerTranOutProduct controllerTranOutProduct =
        context.read<ControllerTranOutProduct>();
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_outlined,
            size: kdefultsize,
            color: white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "จัดเสร็จรอจ่าย",
          style: TextStyle(color: white),
        ),
        backgroundColor: Colors.green[700],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _key,
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
                              Row(
                                children: [
                                  Text(
                                    "${widget.head.detail![0].whCode} ~ ${widget.head.detail![0].shelfCode}  ${widget.head.detail![0].nameShlfCode}",
                                    style: _textStyle.copyWith(
                                      color: black,
                                    ),
                                  ),
                                  //     Text(
                                  //   "${widget.head.detail![0].whCode} ~ ${widget.head.detail![0].shelfCode}  ${widget.head.detail![0].nameShlfCode}",
                                  //   style: _textStyle.copyWith(
                                  //     color: black,
                                  //   ),
                                  // ),
                                ],
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  ...List.generate(
                    _detail.length,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 3,
                              color: _detail[index].statussuccess
                                  ? Colors.green.shade700
                                  : black)),
                      child: ListTile(
                        // onTap: () {},
                        minLeadingWidth: 5,
                        title: Text(
                          "${(_detail[index].lineNumber! + 1).toString()} : ${_detail[index].icCode.toString()} : ${_detail[index].itemName.toString()}",
                          style: _textStyle.copyWith(color: black, fontSize: 8),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Text(
                                //   "${_detail[index].shelfCode.toString()} ~ ${_detail[index].nameShlfCode}",
                                //   style: _textStyle.copyWith(
                                //       color: black, fontSize: 8),
                                // ),
                                // SizedBox(
                                //   width: 10,
                                // ),
                                Text(
                                  "หน่วยนับ  ${_detail[index].unitCode.toString()} - ${_detail[index].unitName.toString()}",
                                  style: _textStyle.copyWith(
                                      color: red, fontSize: 8),
                                ),
                                Spacer(),
                                SizedBox(
                                  width: 20,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "จ่าย  ${_detail[index].payQty.toString()} :",
                                  style: _textStyle.copyWith(
                                    color: black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "จ่ายจริง",
                                  style: _textStyle.copyWith(
                                    color: black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 100,
                                  child: SearchBar(
                                    fontSize: 10,
                                    title: _listEditControllerQty[index].text,
                                    controller: _listEditControllerQty[index],
                                    keyboardType: TextInputType.number,
                                    style: _textStyle.copyWith(
                                        color: black, fontSize: 10),
                                    iconSize: 0,

                                    contentPadding: 5,
                                    enabled: true,
                                    autovalidate: true,

                                    validator: (p0) {
                                      if (!(double.parse(p0!) <
                                          _detail[index].qty!)) {
                                        return "กรอกจำนวนให้ถูกต้อง";
                                      } else {
                                        return null;
                                      }
                                    },
                                    // enabled: !_detail[index].statussuccess,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    print(_detail[index].payQty!);
                                    print(_listEditControllerQty[index].text);
                                    if (double.parse(
                                            _listEditControllerQty[index]
                                                .text) ==
                                        (_detail[index].eventQty! -
                                            _detail[index].payQty!)) {
                                      controllerTranOutProduct
                                          .updateStatusSuccess(
                                              index1: widget.index1,
                                              index2: widget.index2,
                                              linenumber:
                                                  _detail[index].lineNumber!);

                                      controllerTranOutProduct.updateEventQty(
                                          index1: widget.index1,
                                          index2: widget.index2,
                                          linenumber:
                                              _detail[index].lineNumber!,
                                          eventQty: double.parse(
                                              _listEditControllerQty[index]
                                                  .text));

                                      print("จำนวนที่รับมาเท่ากับ");
                                      setState(() {});
                                    } else if (double.parse(
                                            _listEditControllerQty[index]
                                                .text) >
                                        _detail[index].eventQty!) {
                                      Fluttertoast.showToast(
                                          msg: "จะนวนมากกว่าที่จัดได้");
                                    } else {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible:
                                            true, // user must tap button!
                                        builder: (BuildContext context) {
                                          return Consumer<
                                              ControllerTranOutProduct>(
                                            builder: (context, value, child) =>
                                                AlertDialog(
                                              title: Center(
                                                child: Text(
                                                  'ระบุสาเหตุที่จัดสินค้าได้ครบ',
                                                  style: _textStyle.copyWith(
                                                      fontSize: 15),
                                                ),
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    if (value.dropdownItems
                                                        .isNotEmpty)
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: gray
                                                              .withOpacity(0.3),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5,
                                                                vertical: 5),
                                                        child: DropdownButton<
                                                            ListItem>(
                                                          value: value
                                                                  .selectedItem ??
                                                              value.dropdownItems[
                                                                  0],
                                                          elevation: 0,
                                                          isExpanded: true,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .deepPurple),
                                                          underline:
                                                              Container(),
                                                          onChanged: (ListItem?
                                                              newValue) {
                                                            value.updateDropdownbutton(
                                                                listItem:
                                                                    newValue!);
                                                          },
                                                          items: value
                                                              .dropdownItems
                                                              .map<
                                                                      DropdownMenuItem<
                                                                          ListItem>>(
                                                                  (ListItem
                                                                      value) {
                                                            return DropdownMenuItem<
                                                                ListItem>(
                                                              value: value,
                                                              child: Text(
                                                                  value.name ??
                                                                      '',
                                                                  style: _textStyle
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12)),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text('หมายเหตุ',
                                                        style:
                                                            _textStyle.copyWith(
                                                                fontSize: 12)),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: gray
                                                            .withOpacity(0.3),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 5),
                                                      child: TextFormField(
                                                        minLines:
                                                            3, // any number you need (It works as the rows for the textarea)
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        controller:
                                                            _listEditControllerRemark[
                                                                index],
                                                        style:
                                                            _textStyle.copyWith(
                                                                fontSize: 12),
                                                        maxLines: null,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: const Text('ตกลง'),
                                                  onPressed: () {
                                                    // controllerTranOutProduct.updateEventQty(index1: index1, index2: index2, linenumber: linenumber, eventQty: eventQty)
                                                    controllerTranOutProduct
                                                        .updateRemark(
                                                            index1:
                                                                widget.index1,
                                                            index2:
                                                                widget.index2,
                                                            linenumber: _detail[
                                                                    index]
                                                                .lineNumber!,
                                                            remark:
                                                                _listEditControllerRemark[
                                                                        index]
                                                                    .text);
                                                    controllerTranOutProduct
                                                        .updatereason(
                                                            index1:
                                                                widget.index1,
                                                            index2:
                                                                widget.index2,
                                                            linenumber: _detail[
                                                                    index]
                                                                .lineNumber!,
                                                            reason: value
                                                                    .selectedItem!
                                                                    .name ??
                                                                '',
                                                            reasonCode: value
                                                                    .selectedItem!
                                                                    .value ??
                                                                '');
                                                    Navigator.of(context).pop();
                                                    controllerTranOutProduct
                                                        .updateStatusSuccess(
                                                            index1:
                                                                widget.index1,
                                                            index2:
                                                                widget.index2,
                                                            linenumber: _detail[
                                                                    index]
                                                                .lineNumber!);
                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                      // print("จำนวนที่รับมาน้อบกว่า จำนวนที่อยู่ในระบบ");
                                      // var res = await Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => SelectReasonScreen(
                                      //           index1: widget.index1,
                                      //           index2: widget.index2,
                                      //           linenumber: _detail[index].lineNumber!,
                                      //           head: widget.head),
                                      //     ));
                                      // if (res == 'Ok') {
                                      //   setState(() {});
                                      // }

                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "ตกลง",
                                      style: TextStyle(
                                        color: white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              double _sumQty = 0;
                              widget.detail
                                  .asMap()
                                  .forEach((index, element) async {
                                _sumQty += (element.payQty! +
                                    double.parse(
                                        _listEditControllerQty[index].text));
                              });
                              print("=>>>>>>>> ยอดที่จัด$_sumQty");
                              print("=>>>>>>>> ยอดที่จัด${widget.sumPayQty}");
                              if (_sumQty == widget.sumPayQty) {
                                print("ปิดยอด");
                                widget.detail
                                    .asMap()
                                    .forEach((index, element) async {
                                  await updatestatuspaymentsuccess(
                                      docNo: element.docNo!,
                                      qty: (element.payQty! +
                                              double.parse(
                                                  _listEditControllerQty[index]
                                                      .text))
                                          .toString(),
                                      lineNumber:
                                          element.lineNumber!.toString());
                                });
                                await updatestatusclosepayment(
                                    docNo: widget.docNo);
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SignTure(detail: widget.detail),
                                    ));
                              } else {
                                print("ไม่ปิด");
                                widget.detail
                                    .asMap()
                                    .forEach((index, element) async {
                                  await updatestatuspaymentsuccess(
                                      docNo: element.docNo!,
                                      qty: (element.payQty! +
                                              double.parse(
                                                  _listEditControllerQty[index]
                                                      .text))
                                          .toString(),
                                      lineNumber:
                                          element.lineNumber!.toString());

                                  if (element.season != null) {
                                    await insertsiriwmsnotset(
                                        docNo: element.docNo!,
                                        refCode: widget.head.refCode!,
                                        transFlag:
                                            widget.head.transFlag!.toString(),
                                        itemCode: element.icCode!,
                                        linenumber:
                                            element.lineNumber!.toString(),
                                        reason: element.season ?? '',
                                        reasonCode: element.reasonCode ?? '',
                                        remark: element.remark ?? '');
                                  }
                                });
                              }
                              // ! ปิดใบจัดเพราะยอดครบ
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => TranOutProductScreen()),
                                  (route) => false);
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
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Future<bool?> islockrecord({required String docNo}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'lockrecord?doc_no=$docNo&db=${db.getselectedItem.value}');
    bool status = false;
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'lockrecord?doc_no=$docNo&db=${db.getselectedItem.value}')
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

  Future<void> updatestatuspaymentsuccess(
      {required String docNo,
      required String qty,
      required String lineNumber}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusPaymentSuccess?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      var bodyFields = {'event_qty': qty, 'status': '1', 'is_confirm': '1'};
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusPaymentSuccess?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}',
              body: bodyFields)
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
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

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
        } else if (response.statusCode == 400) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

  Future<void> insertsiriwmsnotset({
    required String docNo,
    required String refCode,
    required String transFlag,
    required String itemCode,
    required String linenumber,
    required String reason,
    required String reasonCode,
    required String remark,
  }) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'insertsiriwmsnotset?doc_no=$docNo&ref_code=$refCode&trans_flag=$transFlag&item_code=$itemCode&line_number=$itemCode&reason_code=$reasonCode&remark=$remark&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.postRequestHttpResponse(
              url: BaseUrl.url +
                  'insertsiriwmsnotset?doc_no=$docNo&ref_code=$refCode&trans_flag=$transFlag&item_code=$itemCode&line_number=$itemCode&reason_code=$reasonCode&remark=$remark&db=${db.getselectedItem.value}')
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
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }
}
