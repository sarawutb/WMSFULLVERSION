import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/check_permission_model.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/model_upldate_po.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/main_screen/main_screen.dart';
import 'package:wms/screens/tran_out_product_screen/create_barcode_screen/create_barcode_screen.dart';
import 'package:wms/screens/tran_out_product_screen/list_status_update/list_status_update.dart';
import 'package:wms/screens/tran_out_product_screen/location_out_screen/location_our_screen.dart';

import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/app_color.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/serchbar.dart';
import 'package:provider/provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:wms/widgets/snack.dart';
import 'list_permission_screen/list_permisstion_screen.dart';

class TranOutProductScreen extends StatefulWidget {
  const TranOutProductScreen({Key? key}) : super(key: key);

  @override
  _TranOutProductScreenState createState() => _TranOutProductScreenState();
}

class _TranOutProductScreenState extends State<TranOutProductScreen> {
  // showInfoFlushbar
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  PageController _controllerPageView = PageController(initialPage: 0);
  TextEditingController _query = TextEditingController();
  TextEditingController _customercode = TextEditingController();
  List<ModelUpdatePo> _modeupdatepo = [];
  List<CheckPermissions> _checkpermisionuser = [];
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  StreamSubscription? iosSubscription;

  Future<String?> getCamera() async {
    _image = await _picker.pickImage(
        source: ImageSource.camera, maxHeight: 720, maxWidth: 1280);
    print(">>>>>>>>>>>>>>>>>>>>>>>Image path ${_image?.path}");
    // setState(() {});
    return _image?.path;
  }

  getGallery() async {
    _image = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 720, maxWidth: 1280);
    setState(() {});
  }

  Timer? _timer;
  // List<PageViewModel> data = [];
  bool _statusLoadData = false;
  // bool _statusButton = false;
  int _selectIndex = 0;
  List<ListItem> listStatusSend = [
    ListItem(value: '0', name: 'รับเอง'),
    ListItem(value: '1', name: 'ส่งให้'),
    ListItem(value: '2', name: 'ทั้งหมด'),
  ];
  ListItem? selectlistStatusSend;
  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    // ControllerUser _user = context.read<ControllerUser>();
    // _fcm.subscribeToTopic('${_user.user!.userId}');
    ControllerUser _user = context.read<ControllerUser>();
    // FirebaseMessaging.instance
    //     .subscribeToTopic('${_user.user!.userId}')
    //     .then((value) => print("subcript"));

    checkpermisstionuser();
    // checkserver();

    selectlistStatusSend = listStatusSend[2];
    if (mounted) {
      fetchDataToCratePageView(
          docNo: '', status: listStatusSend[2], customer: _customercode.text);
      // .whenComplete(() => setState(() {
      //       print("ทำอีกครั้ง");
      //       fetchDataToCratePageView(
      //           docNo: '',
      //           status: listStatusSend[2],
      //           customer: _customercode.text);
      // })
      // );
    }
    getmodelupdatepo();
    super.initState();
    // setUpTimedFetch();
    reason1(flag: "1");
    reason2(flag: "2");
  }

  // List<TextEditingController> listRemark1 = [];
  // List<TextEditingController> listRemark2 = [];
  // List<TextEditingController> _controllerSearch = [];

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason1({required String flag}) async {
    ControllerTranOutProduct ctx = context.read<ControllerTranOutProduct>();
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url + 'reason?flag=$flag&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'reason?flag=$flag&db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${responseJson["data"]}");
          List<ListItem> _listReason1 = (responseJson["data"] as List)
              .map((e) => ListItem.fromJson(e))
              .toList();
          ctx.updateListDropdownbuttonlistReason1(list: _listReason1);
          ctx.updateDropdownbuttonlistReason1(item: _listReason1[0]);
          // List.generate(ctx.listReason1.length,
          //     (index) => {listRemark1.add(TextEditingController(text: ""))});
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
  }

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason2({required String flag}) async {
    ControllerTranOutProduct ctx = context.read<ControllerTranOutProduct>();
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();
    print(BaseUrl.url + 'reason?flag=$flag&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'reason?flag=$flag&db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${responseJson["data"]}");
          List<ListItem> _listReason2 = (responseJson["data"] as List)
              .map((e) => ListItem.fromJson(e))
              .toList();
          ctx.updateListDropdownbuttonlistReason2(list: _listReason2);
          ctx.updateDropdownbuttonlistReason2(item: _listReason2[0]);
          // List.generate(ctx.listReason2.length,
          //     (index) => {listRemark2.add(TextEditingController(text: ""))});
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
  }

  setUpTimedFetch() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) async {
      if (mounted) {
        // getmodelupdatepo();
        checkserver();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: white,
              fontSize: 8,
            );
    // final f = new DateFormat('dd/M/yyyy HH:mm', 'th');
    // ! ตัวเลขต้องมี , บัคในอนาคต
    final f_resive = new DateFormat('dd/M/yyyy', 'th');
    final ControllerUser _user = context.read<ControllerUser>();
    final ControllerLoginScreen db = context.read<ControllerLoginScreen>();
    final ControllerTranOutProduct ctl =
        context.read<ControllerTranOutProduct>();
    // Future.delayed(Duration(seconds: 2), () async => await getmodelupdatepo());
    return WillPopScope(
      onWillPop: () {
        // ctl.data.clear();
        ctl.clearData();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.routeNameMainScreen, (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context, RouteName.routeNameMainScreen, (route) => false),
            icon: Icon(
              Icons.arrow_back_outlined,
              size: kdefultsize,
              color: black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text("จัด-จ่ายสินค้า"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListStatusUpdate(list: _modeupdatepo),
                        )),
                    child: Icon(
                      Icons.notifications,
                      color: black,
                    ),
                  ),
                  if (_modeupdatepo.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        alignment: Alignment.center,
                        height: 15,
                        width: 15,
                        decoration:
                            BoxDecoration(color: red, shape: BoxShape.circle),
                        child: Text(
                          ("${_modeupdatepo.length > 99 ? (99.toString() + "+") : _modeupdatepo.length}"),
                          style: TextStyle(color: white, fontSize: 5),
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: Consumer<ControllerTranOutProduct>(
            builder: (context, controllerTranOutProduct, child) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          color: AppColor.kPrimary,
                          height: 25,
                          child: Text(
                            "${db.getselectedItem.value == '0' ? 'UBON1' : db.getselectedItem.value == '6' ? 'TRADING' : db.getselectedItem.value == '1' ? 'PGL' : db.getselectedItem.value == '2' ? 'KCV' : ''}" +
                                ' : ${_user.gebranchList.branchCode} ${_user.gebranchList.branchname} : ${_user.user!.userId}',
                            style: TextStyle(color: white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 2),
                          child: SearchBar(
                            title: "ค้นหา INV/SO",
                            contentPadding: 5,
                            controller: _query,
                            iconSize: 15,
                            style:
                                _textStyle.copyWith(color: black, fontSize: 8),
                            press: () => setState(() {
                              _query.clear();
                              fetchDataToCratePageView(
                                  docNo: _query.text,
                                  status:
                                      selectlistStatusSend ?? listStatusSend[2],
                                  customer: _customercode.text);
                            }),
                            onSubmitted: (p0) {
                              if (p0.isNotEmpty) {
                                fetchDataToCratePageView(
                                    docNo: _query.text,
                                    status: selectlistStatusSend ??
                                        listStatusSend[2],
                                    customer: _customercode.text);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 5, left: 2),
                          child: SearchBar(
                            iconSize: 15,
                            title: "ค้นหาลูกค้า",
                            controller: _customercode,
                            contentPadding: 5,
                            style:
                                _textStyle.copyWith(color: black, fontSize: 8),
                            onSubmitted: (p0) {
                              if (p0.isNotEmpty) {
                                fetchDataToCratePageView(
                                    docNo: _query.text,
                                    status: selectlistStatusSend ??
                                        listStatusSend[2],
                                    customer: _customercode.text);
                              }
                            },
                            press: () => setState(() {
                              _customercode.clear();
                              fetchDataToCratePageView(
                                  docNo: _query.text,
                                  status:
                                      selectlistStatusSend ?? listStatusSend[2],
                                  customer: _customercode.text);
                            }),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 2),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: blue,
                            border: Border.all(
                              color: white,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton<ListItem>(
                            underline: Container(),
                            dropdownColor: blue,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: white,
                              size: 20,
                            ),
                            value: selectlistStatusSend ?? listStatusSend[2],
                            items: listStatusSend
                                .map<DropdownMenuItem<ListItem>>(
                                    (ListItem value) {
                              return DropdownMenuItem<ListItem>(
                                value: value,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                    value.name ?? '',
                                    style: _textStyle.copyWith(
                                        color: white, fontSize: 8),
                                  ),
                                ),
                              );
                            }).toList(),
                            isExpanded: true,
                            onChanged: (item) {
                              setState(() {
                                selectlistStatusSend = item;
                              });
                              fetchDataToCratePageView(
                                  docNo: _query.text,
                                  status:
                                      selectlistStatusSend ?? listStatusSend[2],
                                  customer: _customercode.text);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2, right: 5),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListPerMisstionScreen(
                                    list: _checkpermisionuser),
                              )),
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: blue,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "เช็คสิทธิ์คลัง/ที่เก็บ",
                              style:
                                  _textStyle.copyWith(color: blue, fontSize: 8),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...List.generate(controllerTranOutProduct.data.length,
                          (index) {
                        List<PageViewModel> _list =
                            controllerTranOutProduct.data;
                        return Flexible(
                            child: InkWell(
                          onTap: () async {
                            setState(() {
                              _controllerPageView.animateToPage(index,
                                  duration: Duration(microseconds: 100),
                                  curve: Curves.easeOut);
                              _selectIndex = index;
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_selectIndex == index)
                                      Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: red,
                                        size: 25,
                                      )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 30,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: _list[index].itemId == 1
                                      ? red
                                      : _list[index].itemId == 2
                                          ? Colors.yellow[700]
                                          : _list[index].itemId == 3
                                              ? Colors.green[800]
                                              : Colors.black,
                                  border: Border.all(
                                    color: _selectIndex == index
                                        ? black
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: kdefultsize - 15, horizontal: 5),
                                child: Text(
                                  _list[index].itemId == 1
                                      ? 'รอจัด(${_list[index].head == null ? '0' : _list[index].head!.length})'
                                      : (_list[index].itemId == 2
                                          ? 'กำลังจัด(${_list[index].head == null ? '0' : _list[index].head!.length})'
                                          : (_list[index].itemId == 3
                                              ? 'จัดเสร็จรอจ่าย(${_list[index].head == null ? '0' : _list[index].head!.length})'
                                              : '')),
                                  style: _textStyle.copyWith(fontSize: 8),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ));
                      })
                    ],
                  ),
                ),
                _statusLoadData
                    ? Expanded(
                        child: PageView(
                          controller: _controllerPageView,
                          onPageChanged: (value) {
                            setState(() {
                              _selectIndex = value;
                            });
                          },
                          children: [
                            ...List.generate(
                                controllerTranOutProduct.data.length,
                                (indexTab) {
                              List<PageViewModel> _detail =
                                  controllerTranOutProduct.data;

                              if (_detail[indexTab].itemId == 1) {
                                return ListView(children: [
                                  headerTable(_textStyle),
                                  if (_detail[indexTab].head != null)
                                    ...List.generate(
                                        _detail[indexTab].head!.length,
                                        (index2) {
                                      List<Head> _listHead =
                                          _detail[indexTab].head!;
                                      return Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        color: index2.isEven
                                            ? Colors.blue.shade50
                                            : Colors.white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _listHead[index2].isselected =
                                                      !_listHead[index2]
                                                          .isselected;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 50,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (_listHead[index2]
                                                                  .sendType ==
                                                              "ส่งให้")
                                                            Image.asset(
                                                              "assets/icons/delivery.png",
                                                              height: 16,
                                                              color: Colors
                                                                  .green[800],
                                                            ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${_listHead[index2].docDate2}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        8),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].docNo}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].arName}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (_listHead[index2].isselected)
                                              AnimatedContainer(
                                                width: double.infinity,
                                                color: white,
                                                alignment: Alignment.center,
                                                duration:
                                                    const Duration(seconds: 2),
                                                curve: Curves.fastOutSlowIn,
                                                child: Column(
                                                  children: [
                                                    ...List.generate(
                                                        _listHead[index2]
                                                            .detail!
                                                            .length, (index3) {
                                                      List<Detail> _detaillist =
                                                          _listHead[index2]
                                                              .detail!;
                                                      return Container(
                                                        // padding:
                                                        //     EdgeInsets.all(8),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: index3.isEven
                                                              ? white
                                                              : gray
                                                                  .withOpacity(
                                                                      0.2),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.purple,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: ListTile(
                                                          // leading: Text(
                                                          //   "${_detaillist[index3].lineNumber! + 1}",
                                                          //   style: _textStyle
                                                          //       .copyWith(
                                                          //           fontSize:
                                                          //               8,
                                                          //           color:
                                                          //               black),
                                                          // ),
                                                          title: Text(
                                                            "${_detaillist[index3].lineNumber! + 1} : ${_detaillist[index3].icCode}  ${_detaillist[index3].itemName}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        black),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${_detaillist[index3].shelfCode} ~ ${_detaillist[index3].nameShlfCode}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "หน่วยนับ ${_detaillist[index3].unitCode} ~ ${_detaillist[index3].unitName}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            red,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    "รอจัด ${_detaillist[index3].qty}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) => LocationOutScreen(
                                                                              itemCode: _detaillist[index3].icCode ?? '',
                                                                              zoneCode: _detaillist[index3].shelfCode ?? '',
                                                                              whCode: _detaillist[index3].whCode ?? '')));
                                                                },
                                                                child: Text(
                                                                  "ดูตำแหน่งจัดเก็บสินค้า",
                                                                  style: _textStyle.copyWith(
                                                                      fontSize:
                                                                          11,
                                                                      color:
                                                                          blue,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        SizedBox(
                                                          width: 80,
                                                          height: 30,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              // // Navigator.of(
                                                              // //         context)
                                                              // //     .pop();

                                                              var res = await checkisprint(
                                                                  docNo: _detail[
                                                                          indexTab]
                                                                      .head![
                                                                          index2]
                                                                      .docNo!);
                                                              if (res != null &&
                                                                  res == true) {
                                                                if (_detail[
                                                                        indexTab]
                                                                    .head![
                                                                        index2]
                                                                    .statusButtonClick) {
                                                                  controllerTranOutProduct.updateStatusstatusButtonClick(
                                                                      index1:
                                                                          indexTab,
                                                                      index2:
                                                                          index2,
                                                                      status:
                                                                          false);
                                                                  await updatestatuswaitpayment(
                                                                      userId: _user
                                                                              .user
                                                                              ?.userId ??
                                                                          '',
                                                                      docNo: _detail[indexTab]
                                                                              .head![index2]
                                                                              .docNo ??
                                                                          '');
                                                                  await fetchDataToCratePageView(
                                                                      docNo: _query
                                                                          .text,
                                                                      status: selectlistStatusSend ??
                                                                          listStatusSend[
                                                                              2],
                                                                      customer:
                                                                          _customercode
                                                                              .text);
                                                                  await actionstatus(
                                                                      docNo:
                                                                          _listHead[index2].docNo ??
                                                                              '',
                                                                      refCode:
                                                                          _listHead[index2].refCode ??
                                                                              '',
                                                                      transFlag:
                                                                          _listHead[index2]
                                                                              .transFlag!,
                                                                      userCode:
                                                                          _user.getUser.userId ??
                                                                              '',
                                                                      action:
                                                                          '2');

                                                                  Future.delayed(
                                                                      Duration(
                                                                          milliseconds:
                                                                              100),
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      _selectIndex =
                                                                          indexTab +
                                                                              1;
                                                                      _controllerPageView.animateToPage(
                                                                          _selectIndex,
                                                                          duration: Duration(
                                                                              microseconds:
                                                                                  100),
                                                                          curve:
                                                                              Curves.easeOut);
                                                                    });
                                                                  });

                                                                  controllerTranOutProduct.updateStatusstatusButtonClick(
                                                                      index1:
                                                                          indexTab,
                                                                      index2:
                                                                          index2,
                                                                      status:
                                                                          true);
                                                                }
                                                              } else {
                                                                showAlertDialog(
                                                                    context,
                                                                    fontsize:
                                                                        10,
                                                                    text:
                                                                        "เอกสาร ${_detail[indexTab].head![index2].docNo!} เริ่มจัดไปแล้ว");
                                                              }

                                                              print(res);
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .orange
                                                                      .shade700,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "เริ่มจัด",
                                                                style: _textStyle
                                                                    .copyWith(
                                                                  color: white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    })
                                ]);
                              } else if (_detail[indexTab].itemId == 2) {
                                return ListView(children: [
                                  headerTable(_textStyle),
                                  if (_detail[indexTab].head != null)
                                    ...List.generate(
                                        _detail[indexTab].head!.length,
                                        (index2) {
                                      List<Head> _listHead =
                                          _detail[indexTab].head!;
                                      return Container(
                                        color: index2.isEven
                                            ? Colors.blue.shade50
                                            : Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _listHead[index2].isselected =
                                                      !_listHead[index2]
                                                          .isselected;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (_listHead[index2]
                                                                  .sendType ==
                                                              "ส่งให้")
                                                            Image.asset(
                                                              "assets/icons/delivery.png",
                                                              height: 16,
                                                              color: Colors
                                                                  .green[800],
                                                            ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${_listHead[index2].docDate2}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        8),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].docNo}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].arName}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (_listHead[index2].isselected)
                                              AnimatedContainer(
                                                width: double.infinity,
                                                color: white,
                                                alignment: Alignment.center,
                                                duration:
                                                    const Duration(seconds: 2),
                                                curve: Curves.fastOutSlowIn,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    if (_listHead[index2]
                                                            .userName !=
                                                        null)
                                                      Container(
                                                        color: Colors.yellow,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5),
                                                        child: Text(
                                                          "เริ่มจัดโดย : ${_listHead[index2].userName}",
                                                          style: _textStyle
                                                              .copyWith(
                                                                  fontSize: 10,
                                                                  color: black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: SearchBar(
                                                          contentPadding: 10,
                                                          fontSize: 8,
                                                          title: "สแกนบาร์โค้ด",
                                                          onSubmitted: (p0) {
                                                            print(p0);
                                                            if (p0.isNotEmpty) {
                                                              List<
                                                                  Detail> _list = _listHead[
                                                                      index2]
                                                                  .detail!
                                                                  .where((e) =>
                                                                      e.icCode!
                                                                          .contains(
                                                                              p0) ||
                                                                      e.barcode!
                                                                          .any((barcode) =>
                                                                              barcode.contains(p0)))
                                                                  .toList();
                                                              if (_list
                                                                  .isNotEmpty) {
                                                                _list.forEach(
                                                                    (element) {
                                                                  controllerTranOutProduct.updateStatusSearchComfirm(
                                                                      index1:
                                                                          indexTab,
                                                                      index2:
                                                                          index2,
                                                                      linenumber:
                                                                          element
                                                                              .lineNumber!);
                                                                });
                                                              } else {
                                                                showAlertDialog(
                                                                    context,
                                                                    text:
                                                                        "ไม่พบสินค้า");
                                                                // Fluttertoast.showToast(
                                                                //     msg: "ไม่พบสินค้า");
                                                              }

                                                              setState(() {
                                                                _listHead[index2]
                                                                        .isselected =
                                                                    true;
                                                              });
                                                            }
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        400),
                                                                () => _listHead[
                                                                        index2]
                                                                    .controllerSearchDocument!
                                                                    .clear());
                                                          },
                                                          press: () {
                                                            _listHead[index2]
                                                                .controllerSearchDocument!
                                                                .clear();
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: _textStyle
                                                              .copyWith(
                                                                  color: black),
                                                          controller: _listHead[
                                                                  index2]
                                                              .controllerSearchDocument!,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ...List.generate(
                                                        _listHead[index2]
                                                            .detail!
                                                            .length, (index3) {
                                                      List<Detail> _detaillist =
                                                          _listHead[index2]
                                                              .detail!;

                                                      List<
                                                              TextEditingController>
                                                          _listRemark1 =
                                                          List.generate(
                                                              _listHead[index2]
                                                                  .detail!
                                                                  .length,
                                                              (index) =>
                                                                  TextEditingController());
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: index3.isEven
                                                              ? white
                                                              : gray
                                                                  .withOpacity(
                                                                      0.2),
                                                          border: Border.all(
                                                              color: _detaillist[
                                                                          index3]
                                                                      .statussearchConfirm
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .purple,
                                                              width: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: ListTile(
                                                          title: Text(
                                                            "${_detaillist[index3].lineNumber! + 1} : ${_detaillist[index3].icCode}  ${_detaillist[index3].itemName}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        black),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${_detaillist[index3].shelfCode} ~ ${_detaillist[index3].nameShlfCode}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    "หน่วยนับ${_detaillist[index3].unitCode} ~ ${_detaillist[index3].unitName}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            red,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                "รอจัด ${_detaillist[index3].qty}",
                                                                style: _textStyle.copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (_) => LocationOutScreen(itemCode: _detaillist[index3].icCode ?? '', zoneCode: _detaillist[index3].shelfCode ?? '', whCode: _detaillist[index3].whCode ?? '')));
                                                                    },
                                                                    child: Text(
                                                                      "ดูตำแหน่งจัดเก็บสินค้า",
                                                                      style: _textStyle.copyWith(
                                                                          fontSize:
                                                                              11,
                                                                          color:
                                                                              blue,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 25,
                                                                    width: 200,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "จัดได้",
                                                                          style: _textStyle.copyWith(
                                                                              fontSize: 11,
                                                                              color: red,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              if (_detaillist[index3].statussearch) {
                                                                                showDialog<void>(
                                                                                  context: context,
                                                                                  barrierDismissible: false, // user must tap button!
                                                                                  builder: (BuildContext context) {
                                                                                    _detaillist[index3].focusNode!.requestFocus();
                                                                                    return AlertDialog(
                                                                                      title: Center(
                                                                                        child: Text(
                                                                                          'ระบุจำนวน',
                                                                                          style: _textStyle.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: black),
                                                                                        ),
                                                                                      ),
                                                                                      content: SingleChildScrollView(
                                                                                        child: ListBody(
                                                                                          reverse: false,
                                                                                          children: <Widget>[
                                                                                            Text(
                                                                                              "${_detaillist[index3].lineNumber! + 1} : ${_detaillist[index3].icCode}  ${_detaillist[index3].itemName}",
                                                                                              style: _textStyle.copyWith(fontSize: 12, color: black),
                                                                                            ),
                                                                                            Row(
                                                                                              children: [
                                                                                                Text(
                                                                                                  "หน่วยนับ ${_detaillist[index3].unitCode} ~ ${_detaillist[index3].unitName}",
                                                                                                  style: _textStyle.copyWith(fontSize: 12, color: red, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                                Spacer(),
                                                                                                Text(
                                                                                                  "รอจัด ${_detaillist[index3].qty}",
                                                                                                  style: _textStyle.copyWith(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                            SearchBar(
                                                                                              controller: _detaillist[index3].controllerPayQty,
                                                                                              iconSize: 0,
                                                                                              contentPadding: 5,
                                                                                              focusNode: _detaillist[index3].focusNode,
                                                                                              title: "",
                                                                                              keyboardType: TextInputType.number,
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                      actions: <Widget>[
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.symmetric(horizontal: 13),
                                                                                          child: Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: GestureDetector(
                                                                                                  onTap: () => Navigator.pop(context),
                                                                                                  child: Container(
                                                                                                    height: 45,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.red,
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                                    // color: Colors.green,
                                                                                                    child: Icon(
                                                                                                      Icons.close,
                                                                                                      color: white,
                                                                                                      size: 25,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: InkWell(
                                                                                                  onTap: () async {
                                                                                                    if (double.parse(_detaillist[index3].controllerPayQty!.text) < _detaillist[index3].qty!) {
                                                                                                      // controllerTranOutProduct.updateEventQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, eventQty: double.parse(_controllerQty[index3].text));
                                                                                                      print("ระบุหมายเหตุ");
                                                                                                      //  Navigator.pop(context);
                                                                                                      await Future.delayed(
                                                                                                          Duration(milliseconds: 400),
                                                                                                          () => showMaterialModalBottomSheet(
                                                                                                                expand: false,
                                                                                                                context: context,
                                                                                                                backgroundColor: Colors.transparent,
                                                                                                                builder: (context) => Padding(
                                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                                                                                  child: SafeArea(
                                                                                                                    child: Align(
                                                                                                                      alignment: Alignment.topCenter,
                                                                                                                      child: Container(
                                                                                                                          height: 200,
                                                                                                                          color: white,
                                                                                                                          child: Padding(
                                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                                                              child: Consumer<ControllerTranOutProduct>(
                                                                                                                                builder: (context, v, child) => Column(
                                                                                                                                  children: [
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                      children: [
                                                                                                                                        Text(
                                                                                                                                          "ระบุสาเหตุที่จัดสินค้าได้ไม่ครบ",
                                                                                                                                          style: _textStyle.copyWith(color: black, fontWeight: FontWeight.bold, fontSize: 10),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    if (v.listReason1.isNotEmpty)
                                                                                                                                      DropdownButton<ListItem>(
                                                                                                                                        value: v.selectedReason1,
                                                                                                                                        elevation: 0,
                                                                                                                                        isExpanded: true,
                                                                                                                                        // style: const TextStyle(color: Colors.deepPurple),
                                                                                                                                        underline: Container(),
                                                                                                                                        onChanged: (ListItem? newValue) {
                                                                                                                                          v.updateDropdownbuttonlistReason1(item: newValue!);
                                                                                                                                        },
                                                                                                                                        items: v.listReason1.map<DropdownMenuItem<ListItem>>((ListItem value) {
                                                                                                                                          return DropdownMenuItem<ListItem>(
                                                                                                                                            value: value,
                                                                                                                                            child: Padding(
                                                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                                                              child: Text(
                                                                                                                                                value.name ?? '',
                                                                                                                                                style: _textStyle.copyWith(color: black),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          );
                                                                                                                                        }).toList(),
                                                                                                                                      ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                      padding: EdgeInsets.all(5),
                                                                                                                                      color: Colors.grey.shade300,
                                                                                                                                      child: TextField(
                                                                                                                                        maxLines: 3,
                                                                                                                                        style: _textStyle.copyWith(color: black),
                                                                                                                                        decoration: InputDecoration.collapsed(hintText: "ระบุหมายเหตุ"),
                                                                                                                                        controller: _listRemark1[index3],
                                                                                                                                        keyboardType: TextInputType.text,
                                                                                                                                        textInputAction: TextInputAction.done,
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    Spacer(),
                                                                                                                                    Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                      children: [
                                                                                                                                        SizedBox(
                                                                                                                                          width: 130,
                                                                                                                                          height: 30,
                                                                                                                                          child: InkWell(
                                                                                                                                            onTap: () async {
                                                                                                                                              Navigator.of(context).pop();
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                                                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                                                                                                                                              alignment: Alignment.center,
                                                                                                                                              child: Text(
                                                                                                                                                "ปิด",
                                                                                                                                                style: _textStyle.copyWith(
                                                                                                                                                  color: white,
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                        SizedBox(
                                                                                                                                          width: 130,
                                                                                                                                          height: 30,
                                                                                                                                          child: InkWell(
                                                                                                                                            onTap: () async {
                                                                                                                                              String _name = "";
                                                                                                                                              String _value = "";
                                                                                                                                              v.updateRemark(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, remark: _listRemark1[index3].text);
                                                                                                                                              _name = (controllerTranOutProduct.selectedReason1 == null ? controllerTranOutProduct.listReason1[0].name : controllerTranOutProduct.selectedReason1!.name)!;
                                                                                                                                              _value = (controllerTranOutProduct.selectedReason1 == null ? controllerTranOutProduct.listReason1[0].value : controllerTranOutProduct.selectedReason1!.value)!;
                                                                                                                                              controllerTranOutProduct.updatereason(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, reason: _name, reasonCode: _value);

                                                                                                                                              controllerTranOutProduct.updateEventQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, eventQty: double.parse(_detaillist[index3].controllerPayQty!.text));
                                                                                                                                              controllerTranOutProduct.updateStatusSuccess(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!);
                                                                                                                                              if (_detaillist.any((element) => element.statussuccess == false)) {
                                                                                                                                              } else {
                                                                                                                                                controllerTranOutProduct.updateStatusButtomInDocument(index1: indexTab, index2: index2, status: true);
                                                                                                                                              }

                                                                                                                                              await insertsiriwmsnotset(docNo: _detaillist[index3].docNo!, refCode: _listHead[index2].refCode!, transFlag: _listHead[index2].transFlag!.toString(), itemCode: _detaillist[index3].icCode!, linenumber: _detaillist[index3].lineNumber!.toString(), reason: _detaillist[index3].season ?? '', reasonCode: _detaillist[index3].reasonCode ?? '', remark: _detaillist[index3].remark ?? '');
                                                                                                                                              await updatestatuspayment(docNo: _detaillist[index3].docNo!, qty: _detaillist[index3].controllerPayQty!.text, lineNumber: _detaillist[index3].lineNumber.toString(), isConfirm: "0", status: "1");
                                                                                                                                              Navigator.of(context).pop();
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                                                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                                                                                                              alignment: Alignment.center,
                                                                                                                                              child: Text(
                                                                                                                                                "บันทึก",
                                                                                                                                                style: _textStyle.copyWith(
                                                                                                                                                  color: white,
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    )
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                              ))),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ));
                                                                                                    } else if (double.parse(_detaillist[index3].controllerPayQty!.text) > _detaillist[index3].qty!) {
                                                                                                      Navigator.pop(context);
                                                                                                      // await Future.delayed(Duration(milliseconds: 200), () => showInfoFlushbar(context: context, title: "แจ้งเตือน", message: "จำนานเกินจัดได้", color: red, time: 5));
                                                                                                      // showAlertDialog(context, text: "จำนานเกินจัดได้");
                                                                                                      Fluttertoast.showToast(msg: "จำนานเกินจัดได้", timeInSecForIosWeb: 5);
                                                                                                      print("เกินนนนน");
                                                                                                      // showInfoFlushbar(context: context, title: "แจ้งเตือน", message: "จำนานเกินจัดได้", color: red, time: 5);
                                                                                                    } else if (double.parse(_detaillist[index3].controllerPayQty!.text) == _detaillist[index3].qty!) {
                                                                                                      controllerTranOutProduct.updateEventQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, eventQty: double.parse(_detaillist[index3].controllerPayQty!.text));
                                                                                                      controllerTranOutProduct.updateStatusSuccess(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!);
                                                                                                      await updatestatuspayment(docNo: _detaillist[index3].docNo!, qty: _detaillist[index3].controllerPayQty!.text, lineNumber: _detaillist[index3].lineNumber.toString(), isConfirm: "0", status: "1");
                                                                                                      if (_detaillist.any((element) => element.statussuccess == false)) {
                                                                                                      } else {
                                                                                                        controllerTranOutProduct.updateStatusButtomInDocument(index1: indexTab, index2: index2, status: true);
                                                                                                      }
                                                                                                    } else {
                                                                                                      // showAlertDialog(context, text: "คุณทำรายการไม่ถูกต้อง");

                                                                                                      Fluttertoast.showToast(msg: "คุณทำรายการไม่ถูกต้อง", timeInSecForIosWeb: 5);
                                                                                                    }
                                                                                                    controllerTranOutProduct.updateStatusSearchComfirm(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!);
                                                                                                    Navigator.pop(context);
                                                                                                    Future.delayed(Duration(milliseconds: 400), () => SystemChannels.textInput.invokeListMethod("TextInput.hide"));
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    height: 45,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.green,
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                                    // color: Colors.green,
                                                                                                    child: Icon(
                                                                                                      Icons.check_circle,
                                                                                                      color: white,
                                                                                                      size: 25,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                );
                                                                              }
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                horizontal: 10,
                                                                              ),
                                                                              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                                                              child: Text(
                                                                                "${_detaillist[index3].controllerPayQty!.text.isEmpty ? 0 : _detaillist[index3].controllerPayQty!.text}",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              25,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color: _detaillist[index3].statussuccess
                                                                                ? Colors.green
                                                                                : red,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                          margin:
                                                                              EdgeInsets.symmetric(horizontal: 2),
                                                                          // color: Colors.green,
                                                                          child:
                                                                              Icon(
                                                                            Icons.check_circle,
                                                                            color:
                                                                                white,
                                                                            size:
                                                                                15,
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width: 130,
                                                          height: 30,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              if (_listHead[
                                                                      index2]
                                                                  .statusButtonInDocument) {
                                                                bool? status =
                                                                    await islockrecord(
                                                                        docNo: _listHead[index2].docNo ??
                                                                            '');
                                                                if (status !=
                                                                        null &&
                                                                    status !=
                                                                        false) {
                                                                  if (_listHead[
                                                                          index2]
                                                                      .statusButtonInDocument) {
                                                                    if (_listHead[
                                                                            index2]
                                                                        .detail!
                                                                        .any((element) =>
                                                                            element.statussearch ==
                                                                            false)) {
                                                                      showAlertDialog(
                                                                          context,
                                                                          text:
                                                                              "กรุณาสแกนรายการให้ครบ");
                                                                      // Fluttertoast.showToast(msg: "กรุณาสแกนรายการให้ครบ");
                                                                    } else {
                                                                      if (_listHead[index2].detail!.any((element) =>
                                                                              element.statussuccess ==
                                                                              false) ||
                                                                          _listHead[index2].detail!.any((element) =>
                                                                              element.statussearch ==
                                                                              false)) {
                                                                        showAlertDialog(
                                                                            context,
                                                                            text:
                                                                                "กรุณาสแกนรายการให้ครบ");

                                                                        print(
                                                                            "กรุณาทำรายการให้ครบ");
                                                                        // Fluttertoast.showToast(msg: "กรุณาทำรายการให้ครบ");
                                                                      } else {
                                                                        showDialog<
                                                                            void>(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              true, // user must tap button!
                                                                          builder:
                                                                              (BuildContext context) {
                                                                            return AlertDialog(
                                                                              title: Center(
                                                                                  child: Text(
                                                                                'ยืนยันการจัดสินค้าเลขที่',
                                                                                style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                              )),
                                                                              content: SingleChildScrollView(child: Consumer<ControllerTranOutProduct>(
                                                                                builder: (context, imagepath, child) {
                                                                                  List<String> _imagePath = imagepath.data[indexTab].head![index2].imagepath!;
                                                                                  // String? _signture = imagepath.data[indexTab].head![index2].signture;
                                                                                  // SignatureController? _signatureController = imagepath.data[indexTab].head![index2].signatureController;

                                                                                  return ListBody(
                                                                                    children: <Widget>[
                                                                                      Text(
                                                                                        '${_listHead[index2].detail![0].docNo}',
                                                                                        style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                      ),
                                                                                      Text(
                                                                                        'ที่เก็บ : ${_listHead[index2].detail![0].whCode}-${_listHead[index2].detail![0].shelfCode} ~ ${_listHead[index2].detail![0].nameShlfCode}',
                                                                                        style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          GestureDetector(
                                                                                            onTap: () async {
                                                                                              String? image;
                                                                                              await getCamera().then((value) {
                                                                                                print("VALUE >>>>>>>>>>>>>>> $value");

                                                                                                image = value;
                                                                                              }).whenComplete(() => controllerTranOutProduct.updateImageDetail(index1: indexTab, index2: index2, imagepath: image));

                                                                                              setState(() {});
                                                                                            },
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: blue,
                                                                                                borderRadius: BorderRadius.circular(5),
                                                                                              ),
                                                                                              alignment: Alignment.center,
                                                                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                              child: Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    'แนบรูปภาพการจัดสินค้า',
                                                                                                    style: _textStyle.copyWith(color: white, fontSize: 10),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: 5,
                                                                                                  ),
                                                                                                  Icon(
                                                                                                    Icons.camera_alt_sharp,
                                                                                                    color: white,
                                                                                                    size: 12,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                            children: [
                                                                                              Text(
                                                                                                '${_imagePath.isEmpty ? "" : "รูปภาพ ${_imagePath.length} รูป"}',
                                                                                                style: _textStyle.copyWith(color: _imagePath.isNotEmpty ? blue : Colors.green, fontSize: 10),
                                                                                              ),
                                                                                              if (_imagePath.isNotEmpty)
                                                                                                Icon(
                                                                                                  Icons.check,
                                                                                                  color: Colors.green,
                                                                                                  size: 15,
                                                                                                )
                                                                                            ],
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                },
                                                                              )),
                                                                              actions: <Widget>[
                                                                                SizedBox(
                                                                                  width: double.maxFinite,
                                                                                  height: 30,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                    child: ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(
                                                                                          primary: Colors.purple,
                                                                                        ),
                                                                                        onPressed: () async {
                                                                                          ControllerUser _user = context.read<ControllerUser>();

                                                                                          if (_detail[indexTab].head![index2].statusButtonClick) {
                                                                                            controllerTranOutProduct.updateStatusstatusButtonClick(index1: indexTab, index2: index2, status: false);
                                                                                            if (_listHead[index2].imagepath!.isNotEmpty) {
                                                                                              _listHead[index2].imagepath!.forEach((element) async {
                                                                                                await uploadImageDocument(path: element, docno: _listHead[index2].docNo ?? '', createby: _user.user?.userId ?? '', flag: 1);
                                                                                              });

                                                                                              _listHead[index2].detail!.forEach((element) async {
                                                                                                if (element.statussuccess) await updatestatuspayment(docNo: element.docNo ?? '', qty: element.controllerPayQty!.text.toString(), lineNumber: element.lineNumber.toString(), isConfirm: "1", status: "1");
                                                                                              });

                                                                                              // await fetchDataToCratePageView(docNo: '', status: listStatusSend[2], customer: _customercode.text);
                                                                                            } else {
                                                                                              _listHead[index2].detail!.forEach((element) async {
                                                                                                if (element.statussuccess) await updatestatuspayment(docNo: element.docNo ?? '', qty: element.controllerPayQty!.text.toString(), lineNumber: element.lineNumber.toString(), isConfirm: "1", status: "1");
                                                                                              });

                                                                                              // await fetchDataToCratePageView(docNo: '', status: listStatusSend[2], customer: _customercode.text);
                                                                                            }
                                                                                            await actionstatus(docNo: _listHead[index2].docNo ?? '', refCode: _listHead[index2].refCode ?? '', transFlag: _listHead[index2].transFlag!, userCode: _user.getUser.userId ?? '', action: '3');

                                                                                            var res = await Navigator.push(
                                                                                                context,
                                                                                                MaterialPageRoute(
                                                                                                  builder: (context) => CreateBarCode(head: _listHead[index2], arName: _listHead[index2].arName ?? '', eventdate: DateTime.now()),
                                                                                                ));

                                                                                            if (res == 'OK') {
                                                                                              Navigator.pop(context);
                                                                                              controllerTranOutProduct.updateStatusstatusButtonClick(index1: indexTab, index2: index2, status: true);

                                                                                              // await fetchDataToCratePageView(docNo: '', status: listStatusSend[2], customer: _customercode.text);
                                                                                              await fetchDataToCratePageView(docNo: _query.text, status: selectlistStatusSend ?? listStatusSend[2], customer: _customercode.text);

                                                                                              await Future.delayed(Duration(milliseconds: 400), () async {
                                                                                                setState(() {
                                                                                                  _selectIndex = indexTab + 1;
                                                                                                  _controllerPageView.animateToPage(_selectIndex, duration: Duration(microseconds: 100), curve: Curves.easeOut);
                                                                                                });
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                        },
                                                                                        child: Text(
                                                                                          "ยืนยันจัดเสร็จ",
                                                                                          style: _textStyle.copyWith(fontSize: 12),
                                                                                        )),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      }
                                                                    }
                                                                  } else {
                                                                    showAlertDialog(
                                                                        context,
                                                                        text:
                                                                            "กรุณาทำรายการให้ครบ");
                                                                    // showInfoFlushbar(
                                                                    //     context: context,
                                                                    //     title: "แจ้งเตือน",
                                                                    //     message: "กรุณาทำรายการให้ครบ",
                                                                    //     color: Colors.red);
                                                                  }
                                                                } else {
                                                                  // Fluttertoast.showToast(msg: "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}", timeInSecForIosWeb: 5);
                                                                  // showAlertDialog(context,
                                                                  //     text: "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}");
                                                                  showInfoFlushbar(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          "แจ้งเตือน",
                                                                      message:
                                                                          "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}",
                                                                      color: Colors
                                                                          .yellow,
                                                                      time: 5);
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              decoration: BoxDecoration(
                                                                  color: _listHead[
                                                                              index2]
                                                                          .statusButtonInDocument
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "จัดเสร็จ รอลูกค้ารับ",
                                                                style: _textStyle
                                                                    .copyWith(
                                                                  color: white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 130,
                                                          height: 30,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              if (_listHead[
                                                                      index2]
                                                                  .statusButtonInDocument) {
                                                                bool? status =
                                                                    await islockrecord(
                                                                        docNo: _listHead[index2].docNo ??
                                                                            '');
                                                                if (status !=
                                                                        null &&
                                                                    status !=
                                                                        false) {
                                                                  showDialog<
                                                                      void>(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true, // user must tap button!
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: Center(
                                                                            child: Text(
                                                                          'ยืนยันการจ่ายสินค้าเลขที่',
                                                                          style: _textStyle.copyWith(
                                                                              color: black,
                                                                              fontSize: 10),
                                                                        )),
                                                                        content:
                                                                            SingleChildScrollView(child:
                                                                                Consumer<ControllerTranOutProduct>(
                                                                          builder: (context,
                                                                              imagepath,
                                                                              child) {
                                                                            List<String>?
                                                                                _imagePath =
                                                                                imagepath.data[indexTab].head![index2].imagepath;
                                                                            String?
                                                                                _signture =
                                                                                imagepath.data[indexTab].head![index2].signture;
                                                                            SignatureController?
                                                                                _signatureController =
                                                                                imagepath.data[indexTab].head![index2].signatureController;

                                                                            return ListBody(
                                                                              children: <Widget>[
                                                                                Text(
                                                                                  '${_listHead[index2].detail![0].docNo}',
                                                                                  style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                ),
                                                                                Text(
                                                                                  'ที่เก็บ : ${_listHead[index2].detail![0].whCode}-${_listHead[index2].detail![0].shelfCode} ~ ${_listHead[index2].detail![0].nameShlfCode}',
                                                                                  style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                        onTap: () async {
                                                                                          String? image;
                                                                                          await getCamera().then((value) {
                                                                                            print("VALUE >>>>>>>>>>>>>>> $value");

                                                                                            image = value;
                                                                                          }).whenComplete(() => controllerTranOutProduct.updateImageDetail(index1: indexTab, index2: index2, imagepath: image));

                                                                                          setState(() {});
                                                                                        },
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: blue,
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                'แนบรูปภาพการจ่ายสินค้า',
                                                                                                style: _textStyle.copyWith(color: white, fontSize: 10),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Icon(
                                                                                                Icons.camera_alt_sharp,
                                                                                                color: white,
                                                                                                size: 12,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        )),
                                                                                    Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${_imagePath!.isEmpty ? "" : "รูปภาพ ${_imagePath.length} รูป"}',
                                                                                          style: _textStyle.copyWith(color: _imagePath.isNotEmpty ? blue : Colors.green, fontSize: 10),
                                                                                        ),
                                                                                        if (_imagePath.isNotEmpty)
                                                                                          Icon(
                                                                                            Icons.check,
                                                                                            color: Colors.green,
                                                                                            size: 15,
                                                                                          )
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                // Row(
                                                                                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //   children: [
                                                                                //     Text(
                                                                                //       'ลายเซ็นผู้รับสินค้า',
                                                                                //       style: _textStyle.copyWith(color: Colors.purple, fontSize: 10),
                                                                                //     ),
                                                                                //     Row(
                                                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                //       children: [
                                                                                //         Text(
                                                                                //           '${_signture == null ? "" : "บันทึกเรียบร้อย"}',
                                                                                //           style: _textStyle.copyWith(color: _signture == null ? blue : Colors.green, fontSize: 10),
                                                                                //         ),
                                                                                //         if (_signture != null)
                                                                                //           Icon(
                                                                                //             Icons.check,
                                                                                //             color: Colors.green,
                                                                                //             size: 15,
                                                                                //           )
                                                                                //       ],
                                                                                //     ),
                                                                                //   ],
                                                                                // ),

                                                                                //SIGNATURE CANVAS
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.all(5),
                                                                                  decoration: const BoxDecoration(color: Colors.black),
                                                                                  child: Signature(
                                                                                    controller: _signatureController!,
                                                                                    height: 160,
                                                                                    backgroundColor: Colors.white,
                                                                                  ),
                                                                                ),
                                                                                //OK AND CLEAR BUTTONS
                                                                                Container(
                                                                                  decoration: const BoxDecoration(color: Colors.black),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: <Widget>[
                                                                                      //SHOW EXPORTED IMAGE IN NEW ROUTE
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.check),
                                                                                        color: Colors.blue,
                                                                                        onPressed: () async {
                                                                                          // if (_signatureController.isNotEmpty) {
                                                                                          //   final tempDir = await getTemporaryDirectory();
                                                                                          //   File file = await File('${tempDir.path}/image.png').create();
                                                                                          //   final Uint8List? data = await _signatureController.toPngBytes();
                                                                                          //   if (data != null) {
                                                                                          //     file.writeAsBytesSync(data);
                                                                                          //     controllerTranOutProduct.updateSigntureDocument(index1: indexTab, index2: index2, signture: file.path);
                                                                                          //     print(file.path);
                                                                                          //   }
                                                                                          // }
                                                                                        },
                                                                                      ),
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.undo),
                                                                                        color: Colors.blue,
                                                                                        onPressed: () {
                                                                                          setState(() => _signatureController.undo());
                                                                                        },
                                                                                      ),
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.redo),
                                                                                        color: Colors.blue,
                                                                                        onPressed: () {
                                                                                          setState(() => _signatureController.redo());
                                                                                        },
                                                                                      ),
                                                                                      //CLEAR CANVAS
                                                                                      IconButton(
                                                                                        icon: const Icon(Icons.clear),
                                                                                        color: Colors.blue,
                                                                                        onPressed: () {
                                                                                          setState(() => _signatureController.clear());
                                                                                          controllerTranOutProduct.clearSignture(index1: indexTab, index2: index2);
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        )),
                                                                        actions: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            width:
                                                                                double.maxFinite,
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                              child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.purple,
                                                                                ),
                                                                                onPressed: () async {
                                                                                  ControllerUser _user = context.read<ControllerUser>();
                                                                                  // if (_listHead[index2].signture == null) {
                                                                                  //   Fluttertoast.showToast(msg: "กรุณาเซ็นผู้รับสินค้า");
                                                                                  // } else {
                                                                                  // if (_listHead[index2].signture != null) {

                                                                                  if (_listHead[index2].imagepath!.isEmpty) {
                                                                                    showAlertDialog(context, text: "กรุณาแนบรูปภาพการจัดสินค้า");
                                                                                  } else {
                                                                                    _listHead[index2].detail!.forEach((element) async {
                                                                                      if (element.statussuccess) {
                                                                                        await updatePayment(docNo: element.docNo!, qty: (double.parse(element.controllerPayQty!.text)).toString(), lineNumber: element.lineNumber.toString(), isConfirm: "1", status: "1");
                                                                                      }
                                                                                    });

                                                                                    // if (_listHead[index2].signture != null) {
                                                                                    if (_listHead[index2].signatureController!.isNotEmpty) {
                                                                                      final tempDir = await getTemporaryDirectory();
                                                                                      File file = await File('${tempDir.path}/image.png').create();
                                                                                      final Uint8List? data = await _listHead[index2].signatureController!.toPngBytes();
                                                                                      if (data != null) {
                                                                                        file.writeAsBytesSync(data);
                                                                                        controllerTranOutProduct.updateSigntureDocument(index1: indexTab, index2: index2, signture: file.path);
                                                                                        print(file.path);
                                                                                        await uploadImageDocument(path: _listHead[index2].signture!, docno: _listHead[index2].docNo ?? '', createby: _user.user?.userId ?? '', flag: 4);
                                                                                      }
                                                                                    }
                                                                                    // }

                                                                                    if (_listHead[index2].imagepath != null) {
                                                                                      if (_listHead[index2].imagepath!.isNotEmpty) {
                                                                                        _listHead[index2].imagepath!.forEach((element) async {
                                                                                          // ! รูปภาพยืนยันจ่ายเสร็จ
                                                                                          await uploadImageDocument(path: element, docno: _listHead[index2].docNo ?? '', createby: _user.user?.userId ?? '', flag: 3);
                                                                                        });
                                                                                      }
                                                                                    }
                                                                                    await actionstatus(docNo: _listHead[index2].docNo ?? '', refCode: _listHead[index2].refCode ?? '', transFlag: _listHead[index2].transFlag!, userCode: _user.getUser.userId ?? '', action: '6');
                                                                                    await updatestatusclosepayment(docNo: _listHead[index2].docNo ?? '');
                                                                                    // ! บัคโปรแกรมในอนาคต
                                                                                    // await fetchDataToCratePageView(docNo: '', status: listStatusSend[2], customer: _customercode.text);
                                                                                    await fetchDataToCratePageView(docNo: _query.text, status: selectlistStatusSend ?? listStatusSend[2], customer: _customercode.text);
                                                                                    // }
                                                                                    // }

                                                                                    Navigator.pop(context);
                                                                                    await Future.delayed(Duration(milliseconds: 400), () {
                                                                                      setState(() {
                                                                                        _selectIndex = 2;
                                                                                        print("ไปที่แทบ 2");
                                                                                        if (_listHead.isNotEmpty) _controllerPageView.animateToPage(_selectIndex, duration: Duration(microseconds: 100), curve: Curves.easeOut);
                                                                                      });
                                                                                    });
                                                                                  }
                                                                                },
                                                                                child: Text(
                                                                                  "ยืนยันจ่ายเสร็จ",
                                                                                  style: _textStyle.copyWith(fontSize: 12),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  );
                                                                } else {
                                                                  // showAlertDialog(context,
                                                                  //     text: "${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}");
                                                                  showInfoFlushbar(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          "แจ้งเตือน",
                                                                      message:
                                                                          "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}",
                                                                      color: Colors
                                                                          .yellow,
                                                                      time: 5);
                                                                }
                                                              }
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              decoration: BoxDecoration(
                                                                  color: _listHead[
                                                                              index2]
                                                                          .statusButtonInDocument
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                "จัดเสร็จ จ่ายสินค้า",
                                                                style: _textStyle
                                                                    .copyWith(
                                                                  color: white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    })
                                ]);
                              } else if (_detail[indexTab].itemId == 3) {
                                return ListView(children: [
                                  headerTable(_textStyle),
                                  if (_detail[indexTab].head != null)
                                    ...List.generate(
                                        _detail[indexTab].head!.length,
                                        (index2) {
                                      List<Head> _listHead =
                                          _detail[indexTab].head!;

                                      return Container(
                                        color: index2.isEven
                                            ? Colors.blue.shade50
                                            : Colors.white,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _listHead[index2].isselected =
                                                      !_listHead[index2]
                                                          .isselected;
                                                });
                                              },
                                              child: SizedBox(
                                                height: 50,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (_listHead[index2]
                                                                  .sendType ==
                                                              "ส่งให้")
                                                            Image.asset(
                                                              "assets/icons/delivery.png",
                                                              height: 16,
                                                              color: Colors
                                                                  .green[800],
                                                            ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "${_listHead[index2].docDate2}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        8),
                                                          ),
                                                        ],
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].docNo}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                    Flexible(
                                                        child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${_listHead[index2].arName}",
                                                        style:
                                                            _textStyle.copyWith(
                                                                color: black,
                                                                fontSize: 8),
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            if (_listHead[index2].isselected)
                                              AnimatedContainer(
                                                width: double.infinity,
                                                color: white,
                                                alignment: Alignment.center,
                                                duration:
                                                    const Duration(seconds: 2),
                                                curve: Curves.fastOutSlowIn,
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4),
                                                      child: SizedBox(
                                                        height: 40,
                                                        child: SearchBar(
                                                          contentPadding: 10,
                                                          fontSize: 8,
                                                          title: "สแกนบาร์โค้ด",
                                                          onSubmitted: (p0) {
                                                            print(p0);
                                                            if (p0.isNotEmpty) {
                                                              List<
                                                                  Detail> _list = _listHead[
                                                                      index2]
                                                                  .detail!
                                                                  .where((e) =>
                                                                      e.icCode!
                                                                          .contains(
                                                                              p0) ||
                                                                      e.barcode!
                                                                          .any((barcode) =>
                                                                              barcode.contains(p0)))
                                                                  .toList();
                                                              if (_list
                                                                  .isNotEmpty) {
                                                                _list.forEach(
                                                                    (element) {
                                                                  controllerTranOutProduct.updateStatusSearch(
                                                                      index1:
                                                                          indexTab,
                                                                      index2:
                                                                          index2,
                                                                      linenumber:
                                                                          element
                                                                              .lineNumber!);
                                                                });
                                                              } else {
                                                                showAlertDialog(
                                                                    context,
                                                                    text:
                                                                        "ไม่พบสินค้า");

                                                                // Fluttertoast
                                                                //     .showToast(
                                                                //         msg:
                                                                //             "ไม่พบสินค้า");
                                                              }

                                                              setState(() {
                                                                _listHead[index2]
                                                                        .isselected =
                                                                    true;
                                                              });
                                                            }
                                                            Future.delayed(
                                                                Duration(
                                                                    milliseconds:
                                                                        400),
                                                                () => _listHead[
                                                                        index2]
                                                                    .controllerSearchDocument!
                                                                    .clear());
                                                          },
                                                          press: () {
                                                            _listHead[index2]
                                                                .controllerSearchDocument!
                                                                .clear();
                                                          },
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          style: _textStyle
                                                              .copyWith(
                                                                  color: black),
                                                          controller: _listHead[
                                                                  index2]
                                                              .controllerSearchDocument!,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    ...List.generate(
                                                        _listHead[index2]
                                                            .detail!
                                                            .length, (index3) {
                                                      List<Detail> _detaillist =
                                                          _listHead[index2]
                                                              .detail!;

                                                      List<TextEditingController>
                                                          _remark =
                                                          List.generate(
                                                              _listHead[index2]
                                                                  .detail!
                                                                  .length,
                                                              (index) =>
                                                                  TextEditingController());

                                                      return Container(
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: index3.isEven
                                                              ? white
                                                              : gray
                                                                  .withOpacity(
                                                                      0.2),
                                                          border: Border.all(
                                                              color: _detaillist[
                                                                          index3]
                                                                      .statussearch
                                                                  ? Colors.green
                                                                  : Colors
                                                                      .purple,
                                                              width: 1.5),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: ListTile(
                                                          // leading:
                                                          //     ConstrainedBox(
                                                          //   constraints:
                                                          //       BoxConstraints(
                                                          //     minWidth: 10,
                                                          //     minHeight: 20,
                                                          //     maxWidth: 10,
                                                          //     maxHeight: 64,
                                                          //   ),
                                                          //   child: Center(
                                                          //     child: Text(
                                                          //       "${_detaillist[index3].lineNumber! + 1}",
                                                          //       style: _textStyle.copyWith(
                                                          //           fontSize:
                                                          //               8,
                                                          //           color:
                                                          //               black),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          title: Text(
                                                            "${_detaillist[index3].lineNumber! + 1} : ${_detaillist[index3].icCode}  ${_detaillist[index3].itemName}",
                                                            style: _textStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        11,
                                                                    color:
                                                                        black),
                                                          ),
                                                          subtitle: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "${_detaillist[index3].shelfCode} ~ ${_detaillist[index3].nameShlfCode}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Spacer(),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "หน่วยนับ ${_detaillist[index3].unitCode} ~ ${_detaillist[index3].unitName}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            red,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Spacer(),
                                                                  Text(
                                                                    "รอจ่าย ${_detaillist[index3].diffPayQty!}",
                                                                    style: _textStyle.copyWith(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            black,
                                                                        fontWeight:
                                                                            FontWeight.normal),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    height: 25,
                                                                    width: 150,
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                          "จ่าย",
                                                                          style: _textStyle.copyWith(
                                                                              fontSize: 11,
                                                                              color: red,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2,
                                                                        ),
                                                                        Expanded(
                                                                          child: GestureDetector(
                                                                              onTap: () {
                                                                                if (!_detaillist[index3].statussuccess) if (_detaillist[index3].statussearch) {
                                                                                  showDialog<void>(
                                                                                    context: context,
                                                                                    barrierDismissible: false, // user must tap button!
                                                                                    builder: (BuildContext context) {
                                                                                      return AlertDialog(
                                                                                        title: Center(
                                                                                          child: Text(
                                                                                            'ระบุจำนวน',
                                                                                            style: _textStyle.copyWith(fontSize: 15, fontWeight: FontWeight.bold, color: black),
                                                                                          ),
                                                                                        ),
                                                                                        content: SingleChildScrollView(
                                                                                          child: ListBody(
                                                                                            reverse: false,
                                                                                            children: <Widget>[
                                                                                              Text(
                                                                                                "${_detaillist[index3].lineNumber! + 1} : ${_detaillist[index3].icCode}  ${_detaillist[index3].itemName}",
                                                                                                style: _textStyle.copyWith(fontSize: 12, color: black),
                                                                                              ),
                                                                                              Row(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "หน่วยนับ ${_detaillist[index3].unitCode} ~ ${_detaillist[index3].unitName}",
                                                                                                    style: _textStyle.copyWith(fontSize: 12, color: red, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                  Spacer(),
                                                                                                  Text(
                                                                                                    "รอจ่าย ${_detaillist[index3].diffPayQty!}",
                                                                                                    style: _textStyle.copyWith(fontSize: 12, color: black, fontWeight: FontWeight.bold),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                              SearchBar(
                                                                                                controller: _detaillist[index3].controllerPayQty,
                                                                                                iconSize: 0,
                                                                                                contentPadding: 5,
                                                                                                title: "",
                                                                                                // title: _detaillist[index3].controllerPayQty!.text,
                                                                                                keyboardType: TextInputType.number,
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                        actions: <Widget>[
                                                                                          Row(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            children: [
                                                                                              Expanded(
                                                                                                child: GestureDetector(
                                                                                                  onTap: () => Navigator.pop(context),
                                                                                                  child: Container(
                                                                                                    width: 40,
                                                                                                    height: 45,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.red,
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                                    // color: Colors.green,
                                                                                                    child: Icon(
                                                                                                      Icons.close,
                                                                                                      color: white,
                                                                                                      size: 15,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Expanded(
                                                                                                child: InkWell(
                                                                                                  onTap: () async {
                                                                                                    print((double.parse(_detaillist[index3].controllerPayQty!.text)));
                                                                                                    print(_detaillist[index3].payQty!);
                                                                                                    print((double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!));
                                                                                                    if ((double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!) < _detaillist[index3].eventQty!) {
                                                                                                      // controllerTranOutProduct.updateEventQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, eventQty: double.parse(_controllerQty[index3].text));
                                                                                                      print("ระบุหมายเหตุ");
                                                                                                      //Navigator.pop(context);
                                                                                                      await Future.delayed(
                                                                                                          Duration(milliseconds: 400),
                                                                                                          () => showMaterialModalBottomSheet(
                                                                                                                expand: false,
                                                                                                                context: context,
                                                                                                                backgroundColor: Colors.transparent,
                                                                                                                builder: (context) => Padding(
                                                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                                                                                  child: SafeArea(
                                                                                                                    child: Align(
                                                                                                                      alignment: Alignment.topCenter,
                                                                                                                      child: Container(
                                                                                                                          height: 200,
                                                                                                                          color: white,
                                                                                                                          child: Padding(
                                                                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                                                                              child: Consumer<ControllerTranOutProduct>(
                                                                                                                                builder: (context, v, child) => Column(
                                                                                                                                  children: [
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                      children: [
                                                                                                                                        Text(
                                                                                                                                          "ระบุสาเหตุที่จ่ายสินค้าได้ไม่ครบ",
                                                                                                                                          style: _textStyle.copyWith(color: black, fontWeight: FontWeight.bold, fontSize: 10),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    if (v.listReason2.isNotEmpty)
                                                                                                                                      DropdownButton<ListItem>(
                                                                                                                                        value: v.selectedReason2,
                                                                                                                                        elevation: 0,
                                                                                                                                        isExpanded: true,
                                                                                                                                        // style: const TextStyle(color: Colors.deepPurple),
                                                                                                                                        underline: Container(),
                                                                                                                                        onChanged: (ListItem? newValue) {
                                                                                                                                          v.updateDropdownbuttonlistReason2(item: newValue!);
                                                                                                                                        },
                                                                                                                                        items: v.listReason2.map<DropdownMenuItem<ListItem>>((ListItem value) {
                                                                                                                                          return DropdownMenuItem<ListItem>(
                                                                                                                                            value: value,
                                                                                                                                            child: Padding(
                                                                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                                                                              child: Text(
                                                                                                                                                value.name ?? '',
                                                                                                                                                style: _textStyle.copyWith(color: black),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          );
                                                                                                                                        }).toList(),
                                                                                                                                      ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    ),
                                                                                                                                    Container(
                                                                                                                                      padding: EdgeInsets.all(5),
                                                                                                                                      color: Colors.grey.shade300,
                                                                                                                                      child: TextField(
                                                                                                                                        maxLines: 3,
                                                                                                                                        style: _textStyle.copyWith(color: black),
                                                                                                                                        decoration: InputDecoration.collapsed(hintText: "ระบุหมายเหตุ"),
                                                                                                                                        controller: _remark[index3],
                                                                                                                                      ),
                                                                                                                                    ),
                                                                                                                                    Spacer(),
                                                                                                                                    Row(
                                                                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                                                      children: [
                                                                                                                                        SizedBox(
                                                                                                                                          width: 130,
                                                                                                                                          height: 30,
                                                                                                                                          child: InkWell(
                                                                                                                                            onTap: () async {
                                                                                                                                              Navigator.of(context).pop();
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                                                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                                                                                                                                              alignment: Alignment.center,
                                                                                                                                              child: Text(
                                                                                                                                                "ปิด",
                                                                                                                                                style: _textStyle.copyWith(
                                                                                                                                                  color: white,
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                        SizedBox(
                                                                                                                                          width: 130,
                                                                                                                                          height: 30,
                                                                                                                                          child: InkWell(
                                                                                                                                            onTap: () async {
                                                                                                                                              String _name = "";
                                                                                                                                              String _value = "";
                                                                                                                                              v.updateRemark(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, remark: _remark[index3].text);
                                                                                                                                              _name = (controllerTranOutProduct.selectedReason1 == null ? controllerTranOutProduct.listReason2[0].name : controllerTranOutProduct.selectedReason2!.name)!;
                                                                                                                                              _value = (controllerTranOutProduct.selectedReason1 == null ? controllerTranOutProduct.listReason2[0].value : controllerTranOutProduct.selectedReason2!.value)!;
                                                                                                                                              controllerTranOutProduct.updatereason(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, reason: _name, reasonCode: _value);
                                                                                                                                              // controllerTranOutProduct.updatePayQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, payQty: (double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!));
                                                                                                                                              // controllerTranOutProduct.updateEventQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, eventQty: double.parse(_controllerQty[index3].text));
                                                                                                                                              controllerTranOutProduct.updateStatusSuccess(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!);
                                                                                                                                              if (_detaillist.any((element) => element.statussuccess == false)) {
                                                                                                                                              } else {
                                                                                                                                                controllerTranOutProduct.updateStatusButtomInDocument(index1: indexTab, index2: index2, status: true);
                                                                                                                                              }
                                                                                                                                              // await updatestatuspaymentsuccess(docNo: _detaillist[index3].docNo!, qty: _detaillist[index3].controllerPayQty!.text, lineNumber: _detaillist[index3].lineNumber.toString());
                                                                                                                                              // if (_detaillist[index3].season != null && _detaillist[index3].season!.isNotEmpty) await insertsiriwmsnotset(docNo: _detaillist[index3].docNo!, refCode: _listHead[index2].refCode!, transFlag: _listHead[index2].transFlag!.toString(), itemCode: _detaillist[index3].icCode!, linenumber: _detaillist[index3].lineNumber!.toString(), reason: _detaillist[index3].season ?? '', reasonCode: _detaillist[index3].reasonCode ?? '', remark: _detaillist[index3].remark ?? '');
                                                                                                                                              Navigator.of(context).pop();
                                                                                                                                            },
                                                                                                                                            child: Container(
                                                                                                                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                                                                                                                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                                                                                                              alignment: Alignment.center,
                                                                                                                                              child: Text(
                                                                                                                                                "บันทึก",
                                                                                                                                                style: _textStyle.copyWith(
                                                                                                                                                  color: white,
                                                                                                                                                ),
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                      ],
                                                                                                                                    ),
                                                                                                                                    SizedBox(
                                                                                                                                      height: 10,
                                                                                                                                    )
                                                                                                                                  ],
                                                                                                                                ),
                                                                                                                              ))),
                                                                                                                    ),
                                                                                                                  ),
                                                                                                                ),
                                                                                                              ));
                                                                                                    } else if ((double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!) > _detaillist[index3].eventQty!) {
                                                                                                      Fluttertoast.showToast(msg: "จำนานเกินจัดได้", timeInSecForIosWeb: 5);
                                                                                                      // showAlertDialog(context, text: "จำนานเกินจัดได้");
                                                                                                    } else if ((double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!) == _detaillist[index3].eventQty!) {
                                                                                                      // controllerTranOutProduct.updatePayQty(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!, payQty: (double.parse(_detaillist[index3].controllerPayQty!.text) + _detaillist[index3].payQty!));
                                                                                                      controllerTranOutProduct.updateStatusSuccess(index1: indexTab, index2: index2, linenumber: _detaillist[index3].lineNumber!);
                                                                                                      // controllerTranOutProduct.updateStatusButtomInDocument(index1: indexTab, index2: index2, status: true);
                                                                                                      // await updatestatuspaymentsuccess(docNo: _detaillist[index3].docNo!, qty: _detaillist[index3].controllerPayQty!.text, lineNumber: _detaillist[index3].lineNumber.toString());
                                                                                                      if (_detaillist.any((element) => element.statussuccess == false)) {
                                                                                                      } else {
                                                                                                        controllerTranOutProduct.updateStatusButtomInDocument(index1: indexTab, index2: index2, status: true);
                                                                                                      }
                                                                                                    } else {
                                                                                                      Fluttertoast.showToast(msg: "จำนานเกินจัดได้", timeInSecForIosWeb: 5);

                                                                                                      // showAlertDialog(context, text: "คุณทำรายการไม่ถูกต้อง");

                                                                                                      // Fluttertoast.showToast(msg: "คุณทำรายการไม่ถูกต้อง");
                                                                                                    }

                                                                                                    Navigator.pop(context);
                                                                                                    Future.delayed(Duration(milliseconds: 400), () => SystemChannels.textInput.invokeListMethod("TextInput.hide"));
                                                                                                  },
                                                                                                  child: Container(
                                                                                                    width: 40,
                                                                                                    height: 45,
                                                                                                    decoration: BoxDecoration(
                                                                                                      color: Colors.green,
                                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                                    ),
                                                                                                    margin: EdgeInsets.symmetric(horizontal: 2),
                                                                                                    // color: Colors.green,
                                                                                                    child: Icon(
                                                                                                      Icons.check_circle,
                                                                                                      color: white,
                                                                                                      size: 15,
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
                                                                                }
                                                                                // if (!_detaillist[index3].statussuccess)
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                                                                                child: Text(
                                                                                  "${_detaillist[index3].controllerPayQty!.text}",
                                                                                  style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              )
                                                                              //     SearchBar(
                                                                              //   fontSize: 10,
                                                                              //   iconSize: 0,
                                                                              //   contentPadding: 10,
                                                                              //   enabled: false,
                                                                              //   title: "",
                                                                              //   // title: (_detaillist[index3].payQty! + double.parse()).toString(),
                                                                              //   // title: _detaillist[index3].controllerPayQty!.text,
                                                                              //   controller: _detaillist[index3].controllerPayQty!,
                                                                              //   style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                              //   // controller: _controllerQty[index3],
                                                                              // ),
                                                                              ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      if (_detaillist[
                                                                              index3]
                                                                          .statussearch) {
                                                                        if (_detaillist[index3]
                                                                            .statussuccess) {
                                                                          // print(
                                                                          // "PAYQTY ${_detaillist[index3].payQty!+_detaillist[index3].payQty!}");

                                                                          // controllerTranOutProduct.updatePayQty(
                                                                          //     index1: indexTab,
                                                                          //     index2: index2,
                                                                          //     linenumber: _detaillist[index3].lineNumber!,
                                                                          //     payQty: (double.parse(_detaillist[index3].controllerPayQty!.text)));
                                                                          controllerTranOutProduct.updateStatus(
                                                                              index1: indexTab,
                                                                              index2: index2,
                                                                              linenumber: _detaillist[index3].lineNumber!);
                                                                          if (_detaillist.any((element) =>
                                                                              element.statussuccess ==
                                                                              false)) {
                                                                            controllerTranOutProduct.updateStatusButtomInDocument(
                                                                                index1: indexTab,
                                                                                index2: index2,
                                                                                status: false);
                                                                          } else {
                                                                            controllerTranOutProduct.updateStatusButtomInDocument(
                                                                                index1: indexTab,
                                                                                index2: index2,
                                                                                status: true);
                                                                          }
                                                                          setState(
                                                                              () {
                                                                            _detaillist[index3].controllerPayQty!.clear();
                                                                            _detaillist[index3].controllerPayQty!.text =
                                                                                "0";
                                                                          });
                                                                        }
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: 40,
                                                                      height:
                                                                          25,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: _detaillist[index3].statussuccess
                                                                            ? Colors.yellow.shade900
                                                                            : gray,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              2),
                                                                      // color: Colors.green,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .edit,
                                                                        color:
                                                                            white,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    width: 40,
                                                                    height: 25,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: _detaillist[index3]
                                                                              .statussuccess
                                                                          ? Colors
                                                                              .green
                                                                          : red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                2),
                                                                    // color: Colors.green,
                                                                    child: Icon(
                                                                      Icons
                                                                          .check_circle,
                                                                      color:
                                                                          white,
                                                                      size: 15,
                                                                    ),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showDialog<void>(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true, // user must tap button!
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    content:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          ListBody(
                                                                        children: <
                                                                            Widget>[
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              'รูปภาพ',
                                                                              style: _textStyle.copyWith(color: black, fontSize: 15),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          if (_listHead[index2]
                                                                              .image!
                                                                              .isNotEmpty)
                                                                            SizedBox(
                                                                                height: 170,
                                                                                child: CarouselSlider.builder(
                                                                                  options: CarouselOptions(
                                                                                    height: 150,
                                                                                    // aspectRatio: 16 / 9,
                                                                                    pageSnapping: true,
                                                                                    viewportFraction: 1,
                                                                                    initialPage: 0,
                                                                                    enableInfiniteScroll: true,
                                                                                    reverse: false,
                                                                                    autoPlay: false,
                                                                                    autoPlayInterval: Duration(seconds: 3),
                                                                                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                                                                                    autoPlayCurve: Curves.fastOutSlowIn,
                                                                                    enlargeCenterPage: true,
                                                                                    onPageChanged: (index, reason) {},
                                                                                    scrollDirection: Axis.horizontal,
                                                                                  ),
                                                                                  itemCount: _listHead[index2].image!.length,
                                                                                  itemBuilder: (context, indexImage, realIndex) => Column(
                                                                                    children: [
                                                                                      Text(
                                                                                        "รูปที่ ${indexImage + 1} / ${_listHead[index2].image!.length}",
                                                                                        style: _textStyle.copyWith(fontSize: 12, color: black),
                                                                                      ),
                                                                                      ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(5),
                                                                                        child: Image.network(
                                                                                          '${_listHead[index2].image![indexImage]}',
                                                                                          fit: BoxFit.cover,
                                                                                          height: 130,
                                                                                          width: double.infinity,
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                )),
                                                                          if (_listHead[index2]
                                                                              .image!
                                                                              .isEmpty)
                                                                            Container(
                                                                              height: 150,
                                                                              alignment: Alignment.center,
                                                                              child: Text(
                                                                                "ไม่มีรูปภาพ !",
                                                                                style: _textStyle.copyWith(color: red, fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                30,
                                                                            child: ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(primary: Colors.red),
                                                                                onPressed: () => {Navigator.pop(context)},
                                                                                child: Text(
                                                                                  'ปิด',
                                                                                  style: _textStyle.copyWith(
                                                                                    color: white,
                                                                                    fontSize: 15,
                                                                                  ),
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  border: Border
                                                                      .all(
                                                                          color:
                                                                              blue),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                " ดูภาพพื้นที่วางสินค้า-จัดเสร็จ",
                                                                style: _textStyle
                                                                    .copyWith(
                                                                  color: blue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Flexible(
                                                          child: InkWell(
                                                            onTap: () async {
                                                              bool? status =
                                                                  await islockrecord(
                                                                      docNo: _listHead[index2]
                                                                              .docNo ??
                                                                          '');
                                                              if (status !=
                                                                      null &&
                                                                  status !=
                                                                      false) {
                                                                if (_listHead[
                                                                        index2]
                                                                    .statusButtonInDocument) {
                                                                  if (_listHead[
                                                                              index2]
                                                                          .detail!
                                                                          .any((element) =>
                                                                              element.statussuccess ==
                                                                              false) ||
                                                                      _listHead[
                                                                              index2]
                                                                          .detail!
                                                                          .any((element) =>
                                                                              element.statussearch ==
                                                                              false)) {
                                                                    print(
                                                                        "กรุณาทำรายการให้ครบ");
                                                                    showAlertDialog(
                                                                        context,
                                                                        text:
                                                                            "กรุณาทำรายการให้ครบ");
                                                                    // showInfoFlushbar(
                                                                    //     context:
                                                                    //         context,
                                                                    //     title:
                                                                    //         "แจ้งเตือน",
                                                                    //     message:
                                                                    //         "กรุณาทำรายการให้ครบ",
                                                                    //     color:
                                                                    //         red);
                                                                    // Fluttertoast
                                                                    //     .showToast(
                                                                    //         msg:
                                                                    //             "กรุณาทำรายการให้ครบ");
                                                                  } else {
                                                                    showDialog<
                                                                        void>(
                                                                      context:
                                                                          context,
                                                                      barrierDismissible:
                                                                          true, // user must tap button!
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return AlertDialog(
                                                                          title: Center(
                                                                              child: Text(
                                                                            'ยืนยันการจ่ายสินค้าเลขที่',
                                                                            style:
                                                                                _textStyle.copyWith(color: black, fontSize: 10),
                                                                          )),
                                                                          content:
                                                                              SingleChildScrollView(child: Consumer<ControllerTranOutProduct>(
                                                                            builder: (context,
                                                                                imagepath,
                                                                                child) {
                                                                              List<String>? _imagePath = imagepath.data[indexTab].head![index2].imagepath;
                                                                              String? _signture = imagepath.data[indexTab].head![index2].signture;
                                                                              SignatureController? _signatureController = imagepath.data[indexTab].head![index2].signatureController;
                                                                              // _signatureController!.addListener(() async {

                                                                              // });
                                                                              return ListBody(
                                                                                children: <Widget>[
                                                                                  Text(
                                                                                    '${_listHead[index2].detail![0].docNo}',
                                                                                    style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                  ),
                                                                                  Text(
                                                                                    'ที่เก็บ : ${_listHead[index2].detail![0].whCode}-${_listHead[index2].detail![0].shelfCode} ~ ${_listHead[index2].detail![0].nameShlfCode}',
                                                                                    style: _textStyle.copyWith(color: black, fontSize: 10),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        onTap: () async {
                                                                                          String? image;
                                                                                          await getCamera().then((value) {
                                                                                            print("VALUE >>>>>>>>>>>>>>> $value");

                                                                                            image = value;
                                                                                          }).whenComplete(() => controllerTranOutProduct.updateImageDetail(index1: indexTab, index2: index2, imagepath: image));

                                                                                          setState(() {});
                                                                                        },
                                                                                        child: Container(
                                                                                          decoration: BoxDecoration(
                                                                                            color: blue,
                                                                                            borderRadius: BorderRadius.circular(5),
                                                                                          ),
                                                                                          alignment: Alignment.center,
                                                                                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                'แนบรูปภาพการจ่ายสินค้า',
                                                                                                style: _textStyle.copyWith(color: white, fontSize: 10),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                width: 5,
                                                                                              ),
                                                                                              Icon(
                                                                                                Icons.camera_alt_sharp,
                                                                                                color: white,
                                                                                                size: 12,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Text(
                                                                                            '${_imagePath!.isEmpty ? "" : "รูปภาพ ${_imagePath.length} รูป"}',
                                                                                            style: _textStyle.copyWith(color: _imagePath.isNotEmpty ? blue : Colors.green, fontSize: 10),
                                                                                          ),
                                                                                          if (_imagePath.isNotEmpty)
                                                                                            Icon(
                                                                                              Icons.check,
                                                                                              color: Colors.green,
                                                                                              size: 15,
                                                                                            )
                                                                                        ],
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  // Row(
                                                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  //   children: [
                                                                                  //     Text(
                                                                                  //       'ลายเซ็นผู้รับสินค้า',
                                                                                  //       style: _textStyle.copyWith(color: Colors.purple, fontSize: 10),
                                                                                  //     ),
                                                                                  //     Row(
                                                                                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  //       children: [
                                                                                  //         Text(
                                                                                  //           '${_signture == null ? "" : "บันทึกเรียบร้อย"}',
                                                                                  //           style: _textStyle.copyWith(color: _signture == null ? blue : Colors.green, fontSize: 10),
                                                                                  //         ),
                                                                                  //         if (_signture != null)
                                                                                  //           Icon(
                                                                                  //             Icons.check,
                                                                                  //             color: Colors.green,
                                                                                  //             size: 15,
                                                                                  //           )
                                                                                  //       ],
                                                                                  //     ),
                                                                                  //   ],
                                                                                  // ),

                                                                                  //SIGNATURE CANVAS
                                                                                  SizedBox(
                                                                                    height: 5,
                                                                                  ),
                                                                                  Container(
                                                                                    padding: EdgeInsets.all(5),
                                                                                    decoration: const BoxDecoration(color: Colors.black),
                                                                                    child: Signature(
                                                                                      controller: _signatureController!,
                                                                                      height: 160,
                                                                                      backgroundColor: Colors.white,
                                                                                    ),
                                                                                  ),
                                                                                  //OK AND CLEAR BUTTONS
                                                                                  Container(
                                                                                    decoration: const BoxDecoration(color: Colors.black),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: <Widget>[
                                                                                        //SHOW EXPORTED IMAGE IN NEW ROUTE
                                                                                        IconButton(
                                                                                          icon: const Icon(Icons.check),
                                                                                          color: Colors.blue,
                                                                                          onPressed: () async {
                                                                                            // if (_signatureController.isNotEmpty) {
                                                                                            //   final tempDir = await getTemporaryDirectory();
                                                                                            //   File file = await File('${tempDir.path}/image.png').create();
                                                                                            //   final Uint8List? data = await _signatureController.toPngBytes();
                                                                                            //   if (data != null) {
                                                                                            //     file.writeAsBytesSync(data);
                                                                                            //     controllerTranOutProduct.updateSigntureDocument(index1: indexTab, index2: index2, signture: file.path);
                                                                                            //     print(file.path);
                                                                                            //   }
                                                                                            // }
                                                                                          },
                                                                                        ),
                                                                                        IconButton(
                                                                                          icon: const Icon(Icons.undo),
                                                                                          color: Colors.blue,
                                                                                          onPressed: () {
                                                                                            setState(() => _signatureController.undo());
                                                                                          },
                                                                                        ),
                                                                                        IconButton(
                                                                                          icon: const Icon(Icons.redo),
                                                                                          color: Colors.blue,
                                                                                          onPressed: () {
                                                                                            setState(() => _signatureController.redo());
                                                                                          },
                                                                                        ),
                                                                                        //CLEAR CANVAS
                                                                                        IconButton(
                                                                                          icon: const Icon(Icons.clear),
                                                                                          color: Colors.blue,
                                                                                          onPressed: () {
                                                                                            setState(() => _signatureController.clear());
                                                                                            controllerTranOutProduct.clearSignture(index1: indexTab, index2: index2);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                          )),
                                                                          actions: <
                                                                              Widget>[
                                                                            SizedBox(
                                                                              width: double.maxFinite,
                                                                              height: 30,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                                                                child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      primary: Colors.purple,
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      ControllerUser _user = context.read<ControllerUser>();
                                                                                      if (_listHead[index2].imagepath!.isEmpty) {
                                                                                        showAlertDialog(context, text: "กรุณาแนบรูปภาพการจัดสินค้า");
                                                                                      } else {
                                                                                        if (_listHead[index2].statusButtonClick) {
                                                                                          controllerTranOutProduct.updateStatusstatusButtonClick(index1: indexTab, index2: index2, status: false);
                                                                                          double _sumPayQty = 0;
                                                                                          _listHead[index2].detail!.asMap().forEach((key, element) {
                                                                                            _sumPayQty += (double.parse(element.controllerPayQty!.text) + element.payQty!);
                                                                                          });
                                                                                          if (_sumPayQty == _listHead[index2].sumPayQty) {
                                                                                            print("เท่ากันปิดยอด");
                                                                                            _listHead[index2].detail!.forEach((element) async {
                                                                                              print(">>>>>>>>>>>>>>${element.payQty}");
                                                                                              // ! OLD await updatestatuspaymentsuccess(docNo: element.docNo!, qty: element.payQty!.toString(), lineNumber: element.lineNumber!.toString());
                                                                                              // await updatestatuspaymentsuccess(docNo: element.docNo!, qty: "0", lineNumber: element.lineNumber!.toString());
                                                                                              await updatestatuspaymentsuccess(docNo: element.docNo!, qty: (double.parse(element.controllerPayQty!.text)).toString(), lineNumber: element.lineNumber!.toString());
                                                                                            });
                                                                                            await updatestatusclosepayment(docNo: _listHead[index2].docNo ?? '');
                                                                                          } else {
                                                                                            print("ไม่เท่ากัน");
                                                                                            _listHead[index2].detail!.forEach((element) async {
                                                                                              print(">>>>>>>>>>>>>>${element.payQty}");
                                                                                              // ! OLD await updatestatuspaymentsuccess(docNo: element.docNo!, qty: element.payQty!.toString(), lineNumber: element.lineNumber!.toString());

                                                                                              await updatestatuspaymentsuccess(docNo: element.docNo!, qty: (double.parse(element.controllerPayQty!.text)).toString(), lineNumber: element.lineNumber!.toString());
                                                                                              // await updatestatuspaymentsuccess(docNo: element.docNo!, qty: "0", lineNumber: element.lineNumber!.toString());
                                                                                              if (element.season != null && element.season!.isNotEmpty) await insertsiriwmsnotset(docNo: element.docNo!, refCode: _listHead[index2].refCode!, transFlag: _listHead[index2].transFlag!.toString(), itemCode: element.icCode!, linenumber: element.lineNumber!.toString(), reason: element.season ?? '', reasonCode: element.reasonCode ?? '', remark: element.remark ?? '');
                                                                                            });
                                                                                          }
                                                                                          // if (_listHead[index2].signture != null) {
                                                                                          if (_listHead[index2].signatureController!.isNotEmpty) {
                                                                                            final tempDir = await getTemporaryDirectory();
                                                                                            File file = await File('${tempDir.path}/image.png').create();
                                                                                            final Uint8List? data = await _listHead[index2].signatureController!.toPngBytes();
                                                                                            if (data != null) {
                                                                                              file.writeAsBytesSync(data);
                                                                                              controllerTranOutProduct.updateSigntureDocument(index1: indexTab, index2: index2, signture: file.path);
                                                                                              print(file.path);
                                                                                              await uploadImageDocument(path: _listHead[index2].signture!, docno: _listHead[index2].docNo ?? '', createby: _user.user?.userId ?? '', flag: 4);
                                                                                            }
                                                                                          }
                                                                                          // }
                                                                                          if (_listHead[index2].imagepath != null) {
                                                                                            if (_listHead[index2].imagepath!.isNotEmpty) {
                                                                                              _listHead[index2].imagepath!.forEach((element) async {
                                                                                                // ! รูปภาพจ่ายเสร็จ
                                                                                                await uploadImageDocument(path: element, docno: _listHead[index2].docNo ?? '', createby: _user.user?.userId ?? '', flag: 3);
                                                                                              });
                                                                                            }
                                                                                          }
                                                                                          await actionstatus(docNo: _listHead[index2].docNo ?? '', refCode: _listHead[index2].refCode ?? '', transFlag: _listHead[index2].transFlag!, userCode: _user.getUser.userId ?? '', action: '4');

                                                                                          // ! บัคโปรแกรมในอนาคต
                                                                                          controllerTranOutProduct.updateStatusstatusButtonClick(index1: indexTab, index2: index2, status: true);

                                                                                          Navigator.pop(context);
                                                                                          // await fetchDataToCratePageView(docNo: '', status: listStatusSend[2], customer: _customercode.text);
                                                                                          await fetchDataToCratePageView(docNo: _query.text, status: selectlistStatusSend ?? listStatusSend[2], customer: _customercode.text);
                                                                                          await Future.delayed(Duration(milliseconds: 400), () async {
                                                                                            setState(() {
                                                                                              _selectIndex = 2;
                                                                                              _controllerPageView.animateToPage(2, duration: Duration(microseconds: 100), curve: Curves.easeOut);
                                                                                            });
                                                                                          });
                                                                                        }
                                                                                      }
                                                                                    },
                                                                                    child: Text(
                                                                                      "ยืนยันจ่ายสินค้า",
                                                                                      style: _textStyle.copyWith(fontSize: 12),
                                                                                    )),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                } else {
                                                                  // showAlertDialog(
                                                                  //     context,
                                                                  //     text:
                                                                  //         "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}");
                                                                  showInfoFlushbar(
                                                                      context:
                                                                          context,
                                                                      title:
                                                                          "แจ้งเตือน",
                                                                      message:
                                                                          "เอกสาร ${_listHead[index2].docNo ?? ''} มีการแก้ไข้ \nกรุณาปิดเอกสาร ${_listHead[index2].docNo ?? ''}",
                                                                      color: Colors
                                                                          .yellow,
                                                                      time: 5);
                                                                }
                                                              } else {
                                                                showAlertDialog(
                                                                    context,
                                                                    text:
                                                                        "กรุณาทำรายการให้ครบ");
                                                                // showInfoFlushbar(
                                                                //     context:
                                                                //         context,
                                                                //     title:
                                                                //         "แจ้งเตือน",
                                                                //     message:
                                                                //         "กรุณาทำรายการให้ครบ",
                                                                //     color: Colors
                                                                //         .red);
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          4),
                                                              decoration: BoxDecoration(
                                                                  color: _listHead[
                                                                              index2]
                                                                          .statusButtonInDocument
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .grey,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                " จ่ายสินค้า",
                                                                style: _textStyle
                                                                    .copyWith(
                                                                  color: white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    })
                                ]);
                              } else {
                                return Container(
                                  color: white,
                                  child: Center(
                                    child: Text(
                                      "ไม่พบข้อมูล",
                                      style: _textStyle,
                                    ),
                                  ),
                                );
                              }
                            })
                          ],
                        ),
                      )
                    : Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context,
      {required String text, double? fontsize}) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(
                "$text",
                style: TextStyle(fontSize: fontsize ?? 12),
              )),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  SizedBox headerTable(TextStyle _textStyle) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "วันที่เอกสาร",
              style: _textStyle.copyWith(color: black),
            ),
          )),
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "เลขที่เอกสาร",
              style: _textStyle.copyWith(color: black),
            ),
          )),
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "ลูกค้า",
              style: _textStyle.copyWith(color: black),
            ),
          )),
        ],
      ),
    );
  }

  SizedBox headerItemLayoutTwo(
      List<Head> _listHead, int index2, TextStyle _textStyle) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_listHead[index2].sendType == "ส่งให้")
                  Image.asset(
                    "assets/icons/delivery.png",
                    height: 16,
                    color: Colors.green[800],
                  ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${_listHead[index2].docDate2}",
                  style: _textStyle.copyWith(color: black, fontSize: 8),
                ),
              ],
            ),
          )),
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "${_listHead[index2].docNo}",
              style: _textStyle.copyWith(color: black, fontSize: 8),
            ),
          )),
          Flexible(
              child: Container(
            alignment: Alignment.center,
            child: Text(
              "${_listHead[index2].arName}",
              style: _textStyle.copyWith(color: black, fontSize: 8),
            ),
          )),
        ],
      ),
    );
  }

  DataRow recentFileDataRow({
    required Head head,
    required TextStyle style,
    required VoidCallback press,
  }) {
    final f = new DateFormat('dd/MM/yyyy HH:mm', 'th');
    return DataRow(
      // key: index,
      // selected: selected,
      // onSelectChanged: (value) {
      //   print(value);
      //   setState(() {
      //     selected = value!;
      //   });
      // },
      color: MaterialStateProperty.all(Colors.grey[50]),
      cells: [
        DataCell(
            Row(
              children: [
                if (head.sendType == "ส่งให้")
                  Image.asset(
                    "assets/icons/delivery.png",
                    height: 16,
                    color: Colors.green[800],
                  ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "${head.docDate2!}",
                  style: style,
                ),
                // Text(
                //   "${f.format(head.docDate!)}",
                //   style: style,
                // ),
              ],
            ),
            onTap: press),
        DataCell(
            Text(
              "${head.docNo}",
              style: style,
            ),
            onTap: press),
        DataCell(
            Text(
              "${head.arName}",
              style: style,
            ),
            onTap: press),
      ],
    );
  }

  Future<void> fetchDataToCratePageView(
      {required String docNo,
      required ListItem status,
      required String customer}) async {
    setState(() {
      _statusLoadData = false;
      _selectIndex = 0;
    });
    ControllerUser _user = context.read<ControllerUser>();
    ControllerTranOutProduct cntrollerTranOutProduct =
        context.read<ControllerTranOutProduct>();

    ControllerLoginScreen db = context.read<ControllerLoginScreen>();
    print(BaseUrl.url +
        'reportPayment?branch_code=${_user.gebranchList.branchCode}&doc_no=${docNo.trim()}&user_code=${_user.getUser.userId}&send_type=${status.value}&name_1=${_customercode.text}&db=${db.getselectedItem.value}');
    // cntrollerTranOutProduct.data.clear();
    cntrollerTranOutProduct.data.clear();
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'reportPayment?branch_code=${_user.gebranchList.branchCode}&doc_no=${docNo.trim()}&user_code=${_user.getUser.userId}&send_type=${status.value}&name_1=${_customercode.text}&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            cntrollerTranOutProduct.data = (responseJson["data"] as List)
                .map((e) => PageViewModel.fromJson(e))
                .toList();
          });
          // print(">>>>>>>>>>>>>>>>>>>>>${cntrollerTranOutProduct.data.length}");
          cntrollerTranOutProduct.data.asMap().forEach((key, value) {
            if (key == 1) {
              value.head!.asMap().forEach((index2, e1) {
                cntrollerTranOutProduct.updateStatusButtomInDocument(
                    index1: key, index2: index2, status: false);
                // print("KEY HEAD >>>>>>>>> $index2 ${element.st")
                e1.detail!.forEach((e2) {
                  // e2.controllerPayQty!.text = "";
                  // e2.controllerPayQty!.text = "";
                  e2.statussearch = true;
                  e2.statussuccess = false;
                  if (e2.eventQty == 0) {
                    e2.eventQty = e2.qty!;
                  }

                  e2.controllerPayQty!.text = (e2.eventQty!).toString();
                });
                //
              });
            }

            if (key == 2) {
              // print("HEAD >>>>>>>>>> ${value.head!.length}");

              if (value.head != null) {
                value.head!.asMap().forEach((index2, e1) {
                  cntrollerTranOutProduct.updateStatusButtomInDocument(
                      index1: key, index2: index2, status: false);
                  // print("KEY HEAD >>>>>>>>> $index2 ${element.st")
                  e1.detail!.forEach((e2) {
                    e2.controllerPayQty!.text = e2.diffPayQty!.toString();

                    // cntrollerTranOutProduct.updateStatusSuccess(
                    //     index1: key,
                    //     index2: index2,
                    //     linenumber: e2.lineNumber!);
                    cntrollerTranOutProduct.updateStatusSearch(
                        index1: key,
                        index2: index2,
                        linenumber: e2.lineNumber!);
                  });
                  //
                });
              }
            }

            if (value.head!.isNotEmpty) {
              setState(() {
                if (value.head!.length == 1 &&
                    value.head![0].docNo == _query.text) {
                  _selectIndex = key;
                  Future.delayed(
                      Duration(milliseconds: 400),
                      () => setState(() {
                            _statusLoadData = true;
                            _controllerPageView.animateToPage(_selectIndex,
                                duration: Duration(microseconds: 100),
                                curve: Curves.easeOut);
                          }));
                }
              });
            }
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      throw Exception(e);
    } finally {
      setState(() {
        _statusLoadData = true;
      });

      // Future.delayed(
      //     Duration(seconds: 1),
      //     () => setState(() {
      //           _statusLoadData = true;
      //         }));
      // setState(() {
      //   _statusLoadData = true;
      // });
    }
  }

  // ! ตรวจสอบสิทธิ์
  Future<void> checkpermisstionuser() async {
    ControllerUser _user = context.read<ControllerUser>();
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'checkPermissions?user_code=${_user.getUser.userId}&db=${db.getselectedItem.value}&branch_code=${_user.gebranchList.branchCode}');
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'checkPermissions?user_code=${_user.getUser.userId}&db=${db.getselectedItem.value}&branch_code=${_user.gebranchList.branchCode}')
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          setState(() {
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            _checkpermisionuser = (responseJson["data"] as List)
                .map((e) => CheckPermissions.fromJson(e))
                .toList();
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      throw Exception(e);
    }
  }

  // ! อัพเดทสถานะจ่าย
  Future<void> updatestatuswaitpayment(
      {required String docNo, required String userId}) async {
    setState(() {
      _statusLoadData = false;
    });
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusWaitPayment?is_print=1&doc_no=$docNo&user_id=$userId&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusWaitPayment?is_print=1&doc_no=$docNo&user_id=$userId&db=${db.getselectedItem.value}')
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
    } finally {
      setState(() {
        _statusLoadData = true;
      });
    }
  }

  // ! อัพเดทสถานะปิด

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

  // ! เมื่อเอกสารมีการแก้ไข
  Future<void> getmodelupdatepo() async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url + 'modelupdatepo?db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'modelupdatepo?db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          setState(() {
            _modeupdatepo = (responseJson["data"] as List)
                .map((e) => ModelUpdatePo.fromJson(e))
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
      // Fluttertoast.showToast(msg: e.toString());
      // Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

  // ! ตรวจสอบบิลนั้นถ้ามีการแก้ไข้
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

  // ! ตรวจสอบบิลนั้นถ้ามีกดเริ่มจัดไปแล้ว
  Future<bool?> checkisprint({required String docNo}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'checkisprint?doc_no=$docNo&db=${db.getselectedItem.value}');
    bool status = false;
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'checkisprint?doc_no=$docNo&db=${db.getselectedItem.value}')
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
      // Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
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
          // statusUpdate = true;
        } else if (response.statusCode == 400) {
          // statusUpdate = false;
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        } else {
          // statusUpdate = false;
        }
      });
    } catch (e) {
      // statusUpdate = false;
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
  }

  // ! อัพเดทสถานะไปแทบจัดเสร็จ จ่ายสินค้า
  Future<void> updatePayment(
      {required String docNo,
      required String qty,
      required String lineNumber,
      required String isConfirm,
      required String status}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updatePayment?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      var bodyFields = {
        'event_qty': qty,
        'status': status,
        'is_confirm': isConfirm
      };
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updatePayment?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}',
              body: bodyFields)
          .then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(
              msg: responseJson["msg"],
              backgroundColor: Colors.green,
              textColor: white);
          // statusUpdate = true;
        } else if (response.statusCode == 400) {
          // statusUpdate = false;
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        } else {
          // statusUpdate = false;
        }
      });
    } catch (e) {
      // statusUpdate = false;
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
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

  Future<void> updatestatuspaymentsuccessSet(
      {required String docNo,
      required String qty,
      required String lineNumber}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'updateStatusPaymentSuccessSet?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}');
    try {
      var bodyFields = {'event_qty': qty, 'status': '1', 'is_confirm': '1'};
      await RequestAssistant.putRequestHttpResponse(
              url: BaseUrl.url +
                  'updateStatusPaymentSuccessSet?line_number=$lineNumber&doc_no=$docNo&db=${db.getselectedItem.value}',
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
                  'insertsiriwmsnotset?doc_no=$docNo&ref_code=$refCode&trans_flag=$transFlag&item_code=$itemCode&line_number=$linenumber&reason_code=$reasonCode&remark=$remark&db=${db.getselectedItem.value}')
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

  Future<void> uploadImageDocument(
      {required String path,
      required String docno,
      required String createby,
      required int flag}) async {
    try {
      ControllerLoginScreen db = context.read<ControllerLoginScreen>();

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(BaseUrl.url +
              'uploadImages?doc_no=$docno&line_number=1&create_by=$createby&flag=$flag&db=${db.getselectedItem.value}'));
      request.files.add(await http.MultipartFile.fromPath('file', '$path'));
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        Fluttertoast.showToast(
            msg: "อัพโหลดรูปภาพเรียบร้อย", backgroundColor: Colors.green);
      } else {
        print(response.reasonPhrase);
        Fluttertoast.showToast(
            msg: response.reasonPhrase.toString(), backgroundColor: red);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {}
  }

// ! บันทึก Log การทำงาน
  Future<void> actionstatus({
    required String docNo,
    required String refCode,
    required int transFlag,
    required String userCode,
    required String action,
  }) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();
    print(BaseUrl.url +
        'actionstatus?doc_no=$docNo&ref_code=$refCode&user_code=$userCode&trans_flag=$transFlag&action=$action&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.postRequestHttpResponse(
              url: BaseUrl.url +
                  'actionstatus?doc_no=$docNo&ref_code=$refCode&user_code=$userCode&trans_flag=$transFlag&action=$action&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(responseJson);
          // Fluttertoast.showToast(
          //     msg: responseJson["msg"],
          //     backgroundColor: Colors.green,
          //     textColor: white);
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

// ! เช็คการเชื่อมต่อกับเซิฟเวอร์
  Future<void> checkserver() async {
    try {
      await RequestAssistant.getRequestHttpResponse(url: BaseUrl.url)
          .then((response) {
        if (response.statusCode == 200) {
          print(
              "CONNECTED TO SERVER >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WELLCOME TO PROGRAM");
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(),
              ),
              (route) => false);
        }
      });
    } catch (e) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
          (route) => false);
      throw Exception(e);
    } finally {}
  }
}
