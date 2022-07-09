import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/widgets/willPopScope.dart';

import '../../controllers/controller_login_screen.dart';
import '../../controllers/controller_user.dart';
import '../../themes/colors.dart';
import '../../widgets/simpleText.dart';
import '../main_screen/main_screen.dart';
import 'package:http/http.dart' as http;

class GetPoToShopScreen extends StatefulWidget {
  const GetPoToShopScreen({Key? key}) : super(key: key);

  @override
  State<GetPoToShopScreen> createState() => _GetPoToShopScreenState();
}

class _GetPoToShopScreenState extends State<GetPoToShopScreen> {
  final f = new DateFormat('dd-MM-yyyy');
  // var now = DateTime.now().toLocal();
  DateTime? dateTime;
  Duration? duration;
  TextEditingController _query = TextEditingController();
  TextEditingController _reMark = TextEditingController();
  FocusNode _node = FocusNode();
  bool checkStatus = false;
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
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 14);
    return willPopScope(
        press: () async {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => MainScreen()),
              (route) => false);
          return Future.value(false);
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
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
                                    lastDate: DateTime(DateTime.now().year + 1),
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
                                          .invokeListMethod('TextInput.hide'));
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
                                      bottomRight: Radius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    "${dateTime!.day}/${dateTime!.month}/" +
                                        (dateTime!.year + 543).toString(),
                                    style: _styledefult.copyWith(color: white
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
                          onSubmitted: (value) async {
                            if (value.isNotEmpty) {
                              if (checkStatus) {
                                dialogBoxCancel(
                                    massage: value,
                                    context: context,
                                    date: dateTime!);
                              } else {
                                functionGetpotoShop(
                                    query: value, context: context);
                              }
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                                value: checkStatus,
                                onChanged: (value) {
                                  setState(() {
                                    checkStatus = !checkStatus;
                                  });
                                }),
                            Text(
                              "ขอยกเลิกบันทึกวันที่สินค้าถึงร้าน",
                              style: _styledefult,
                            )
                          ],
                        ),
                        // TextButton(
                        //     onPressed: () async {
                        //       await sendEmailMessage(
                        //           name: "sutthinai senkram",
                        //           subject: "ข้อความ",
                        //           message: "X02-HZV6505-00511-01",
                        //           userEmail: "sutthinai.senk59@gmail.com");
                        //     },
                        //     child: Text("Send Email"))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void functionGetpotoShop(
      {required String query, required BuildContext context}) async {
    ControllerUser _user = context.read<ControllerUser>();
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    var headers = {'Authorization': 'Bearer ${_user.getUser.token}'};

    var response = await RequestAssistant.getRequestHttpResponse(
        url:
            "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/NoRecive/?dbid=${db.getselectedItem.value}&branch=${_user.gebranchList.branchCode}&s=$query",
        headers: headers);
    print(
        "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/NoRecive/?dbid=${db.getselectedItem.value}&branch=${_user.gebranchList.branchCode}&s=$query");
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      dialogBox(massage: responseJson["massage"], context: context);
      print(responseJson);
    }
  }

  dialogBox({required String massage, required BuildContext context}) {
    return showDialog(
        context: context,
        builder: (ctx) => Dialog(
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("$massage"),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Future.delayed(
                            Duration(milliseconds: 400),
                            () => SystemChannels.textInput
                                .invokeMethod('TextInput.hide'));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        height: 45,
                        child: Text(
                          "ปิด",
                          style: TextStyle(color: white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  dialogBoxCancel(
      {required String massage,
      required BuildContext context,
      required DateTime date}) {
    return showDialog(
        context: context,
        builder: (ctx) => Dialog(
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "$massage",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "ต้องการขอยกเลิกการบันทึก\nวันที่สินค้าถึงร้าน\nณ วันที่ $date",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      child: TextField(
                        maxLines: 3,
                        controller: _reMark,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: 14),
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 5, bottom: 5, top: 5, right: 0),
                            hintText: "หมายเหตุ"),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _reMark.clear();
                              Future.delayed(
                                  Duration(milliseconds: 400),
                                  () => SystemChannels.textInput
                                      .invokeMethod('TextInput.hide'));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 45,
                              child: Text(
                                "ปิด",
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _reMark.clear();
                              Future.delayed(
                                  Duration(milliseconds: 400),
                                  () => SystemChannels.textInput
                                      .invokeMethod('TextInput.hide'));
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.indigo,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              height: 45,
                              child: Text(
                                "ตกลง",
                                style: TextStyle(color: white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  Future sendEmailMessage(
      {required String name,
      required String subject,
      required String userEmail,
      required String message}) async {
    final String serviceId = 'service_hvrowpj';
    final String templateId = 'template_oej3tfp';
    final String userId = '2l3FAFGrJSRq8AZJ_';
    // POST https://api.emailjs.com/api/v1.0/email/send
    var response = await RequestAssistant.postRequestHttpResponse(
        url: "https://api.emailjs.com/api/v1.0/email/send",
        headers: {
          'origin': 'http://locahost',
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'subject': subject, // หัวเรื่อง
            'user_email': userEmail, // อีเมลที่ต้องการส่ง
            'name': name, // ชื่อคนอยู่ในระบบ
            'message': message, // เลขที่ใบ PO
          }
        }));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "ส่งอีเมลสำเร็จ");
    }
  }
}
