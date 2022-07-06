import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_couting_scock_scrren.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_offline_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/database/database.dart';
import 'package:wms/models/product_offline_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/button_defualt.dart';
import 'package:wms/widgets/dialogbox.dart';
import 'package:wms/widgets/loadstatussvg.dart';
import 'package:wms/widgets/text_form_search.dart';
import 'widgets/appbar.dart';
import 'widgets/caculator.dart';
import 'widgets/detail_product.dart';

class CountingStokScreen extends StatefulWidget {
  const CountingStokScreen({Key? key}) : super(key: key);

  @override
  _CountingStokScreenState createState() => _CountingStokScreenState();
}

class _CountingStokScreenState extends State<CountingStokScreen> {
  final TextEditingController _location = TextEditingController();
  final TextEditingController _product = TextEditingController();
  late DatabaseHandler handler;
  FocusNode _locationNode = FocusNode();
  FocusNode _productNode = FocusNode();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<ProductLocal> listproductoffine = [];

  @override
  void initState() {
    // initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
    handler
        .retrieveUsers()
        .then((value) => setState(() => listproductoffine = value))
        .whenComplete(() {
      if (listproductoffine.length > 0) {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: const Text('แจ้งเตือนจากระบบ')),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('มีสินค้าอยู่ในรายการคุณต้องการบันทึกหรือไม่'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      child: const Text('ตกลง'),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context,
                            RouteName.routeNameUploadOfflineModeScreen);
                        // var res = await Navigator.pushNamed(
                        //     context, PosrLocalScreen.routeName);
                        // if (res == "OK") {
                        //   Navigator.of(context).pop();
                        // }
                      },
                    ),
                    TextButton(
                      child: const Text('ไม่'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _location.dispose();
    _product.dispose();
    _locationNode.dispose();
    _productNode.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    ControllerCountingStockScreen _controllerCountingStockScreen =
        context.read<ControllerCountingStockScreen>();
    switch (result) {
      case ConnectivityResult.wifi:
        context.read<ControllerUser>().initUrl(context: context);
        _controllerCountingStockScreen.updatestatusnetwork(status: true);

        //!โหลดข้อมูลออฟไลน์
        dialogWidget(
            context: context,
            height: 200,
            title: "แจ้งเตือนจากระบบ",
            subtitle: "คุณต้องการโหลดข้อมูลออฟไลน์หรือไม่",
            leftBtn: TextButton(
                onPressed: () {
                  context
                      .read<ControllerCountingStockScreen>()
                      .fFetchDateCount(context: context);
                  Navigator.of(context).pop();
                  _locationNode.requestFocus();
                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                child: Text(
                  "ไม่",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: red),
                )),
            rightBtn: TextButton(
                onPressed: () => context
                        .read<ControllerOfflineScreen>()
                        .loadData(context: context)
                        .whenComplete(() async {
                      await context
                          .read<ControllerCountingStockScreen>()
                          .fFetchDateCount(context: context);
                      Navigator.of(context).pop();
                      _locationNode.requestFocus();
                      Future.delayed(Duration(milliseconds: 300), () {
                        SystemChannels.textInput
                            .invokeListMethod('TextInput.hide');
                      });
                    }),
                child: Text(
                  "ตกลง",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.green),
                )));

        break;
      case ConnectivityResult.mobile:
        context.read<ControllerUser>().initUrl(context: context);
        _controllerCountingStockScreen.updatestatusnetwork(status: true);
        print("mobile");
        //!โหลดข้อมูลออฟไลน์
        // context
        //     .read<ControllerOfflineScreen>()
        //     .loadData(context: context)
        //     .whenComplete(() => context
        //         .read<ControllerCountingStockScreen>()
        //         .fFetchDateCount(context: context));
        dialogWidget(
            context: context,
            height: 200,
            title: "แจ้งเตือนจากระบบ",
            subtitle: "คุณต้องการโหลดข้อมูลออฟไลน์หรือไม่",
            leftBtn: TextButton(
                onPressed: () {
                  context
                      .read<ControllerCountingStockScreen>()
                      .fFetchDateCount(context: context);
                  Navigator.of(context).pop();
                  _locationNode.requestFocus();
                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                child: Text(
                  "ไม่",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: red),
                )),
            rightBtn: TextButton(
                onPressed: () => context
                        .read<ControllerOfflineScreen>()
                        .loadData(context: context)
                        .whenComplete(() async {
                      await context
                          .read<ControllerCountingStockScreen>()
                          .fFetchDateCount(context: context);
                      Navigator.of(context).pop();
                      _locationNode.requestFocus();
                      Future.delayed(Duration(milliseconds: 300), () {
                        SystemChannels.textInput
                            .invokeListMethod('TextInput.hide');
                      });
                    }),
                child: Text(
                  "ตกลง",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.green),
                )));

        break;
      case ConnectivityResult.none:
        _controllerCountingStockScreen.updatestatusnetwork(status: false);

        break;
      default:
        _controllerCountingStockScreen.updatestatusnetwork(status: true);

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ControllerCountingStockScreen controllerCountingStockScreen =
        context.read<ControllerCountingStockScreen>();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    return Scaffold(
      backgroundColor: white,
      appBar: appBar(
          context: context,
          controllerCountingStockScreen: controllerCountingStockScreen,
          user: _user,
          press: () => clearAll(
              controllerCountingStockScreen: controllerCountingStockScreen)),
      body: Consumer<ControllerCountingStockScreen>(
        builder: (context, _controllerCountingStockScreen, child) =>
            !controllerCountingStockScreen.getstatuspage
                ? GestureDetector(
                    onTap: () => SystemChannels.textInput
                        .invokeListMethod('TextInput.hide'),
                    child: Form(
                      key: _key,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (!_controllerCountingStockScreen
                                .getstatusnetwork)
                              Container(
                                width: size.width,
                                height: size.height * 0.1,
                                alignment: Alignment.center,
                                color: red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "ขาดการเชื่อมต่อจากอินเทอร์เน็ต",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(color: white),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context,
                                          RouteName
                                              .routeNameCountStockOfflineScreen),
                                      child: Text(
                                        "โหมดออฟไลน์",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2!
                                            .copyWith(
                                              color: white,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            // ตำแหน่งสินค้า
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: kdefultsize - 10),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: kdefultsize - 10),
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      decoration: kBoxDecorationStyle,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "ตำแหน่ง",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontSize: kdefultsize - 10),
                                          ),
                                          GestureDetector(
                                            onTap: () => _controllerCountingStockScreen
                                                    .getstatusnetwork
                                                ? _controllerCountingStockScreen
                                                        .getbtnLocation
                                                    ? checkLocation(
                                                        controllerCountingStockScreen:
                                                            controllerCountingStockScreen)
                                                    : null
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "ขาดการเชื่อมต่อจากอินเทอร์เน็ต"),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    _controllerCountingStockScreen
                                                            .getstatusnetwork
                                                        ? red
                                                        : gray,
                                              ),
                                              padding: EdgeInsets.all(
                                                  kdefultsize - 15),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: kdefultsize - 15),
                                              child: Text(
                                                "ตรวจสอบ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        fontSize:
                                                            kdefultsize - 10,
                                                        color: white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: TextFormFeildSearch(
                                      isMagin: 10,
                                      disable: _controllerCountingStockScreen
                                          .getstatusnetwork,
                                      size: size,
                                      textInputAction: TextInputAction.done,
                                      node: _locationNode,
                                      icon: Icons.close,
                                      context: context,
                                      autoFocus: false,
                                      hintText: "ตำแหน่งจัดกับสินค้า",
                                      press: () {
                                        _location.clear();
                                        Future.delayed(
                                            Duration(milliseconds: 300), () {
                                          SystemChannels.textInput
                                              .invokeListMethod(
                                                  'TextInput.hide');
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (string) {
                                        _productNode.requestFocus();
                                        Future.delayed(
                                            Duration(milliseconds: 300), () {
                                          SystemChannels.textInput
                                              .invokeListMethod(
                                                  'TextInput.hide');
                                        });
                                      },
                                      textEditingController: _location),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: kdefultsize - 10),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: kdefultsize - 10),
                                      height: size.height * 0.08,
                                      alignment: Alignment.center,
                                      decoration: kBoxDecorationStyle,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "บาร์โค้ด",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2!
                                                .copyWith(
                                                    fontSize: kdefultsize - 10),
                                          ),
                                          GestureDetector(
                                            onTap: () =>
                                                _controllerCountingStockScreen
                                                        .getstatusnetwork
                                                    ? null
                                                    : Fluttertoast.showToast(
                                                        msg:
                                                            "ขาดการเชื่อมต่อจากอินเทอร์เน็ต"),
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    _controllerCountingStockScreen
                                                            .getstatusnetwork
                                                        ? red
                                                        : gray,
                                              ),
                                              padding: EdgeInsets.all(
                                                  kdefultsize - 15),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: kdefultsize - 15),
                                              child: Text(
                                                "ตรวจสอบ",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        fontSize:
                                                            kdefultsize - 10,
                                                        color: white),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 3,
                                  child: TextFormFeildSearch(
                                      isMagin: 10,
                                      size: size,
                                      textInputAction: TextInputAction.done,
                                      node: _productNode,
                                      icon: Icons.close,
                                      context: context,
                                      autoFocus: false,
                                      disable: _controllerCountingStockScreen
                                          .getstatusnetwork,
                                      hintText: "บาร์โค้ด",
                                      press: () {
                                        _product.clear();
                                        Future.delayed(
                                            Duration(milliseconds: 300), () {
                                          SystemChannels.textInput
                                              .invokeListMethod(
                                                  'TextInput.hide');
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      onFieldSubmitted: (string) {
                                        if (_location.text.isNotEmpty &&
                                            _product.text.isNotEmpty) {
                                          if (_controllerCountingStockScreen
                                              .getstatusnetwork) {
                                            _controllerCountingStockScreen
                                                .fFetchDataProductCountStock(
                                                    query: string.toUpperCase(),
                                                    context: context,
                                                    location: _location.text);
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "ขาดการเชื่อมต่อจากอินเทอร์เน็ต");
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "กุรุณาทำรายการให้ถูกต้อง",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                          );
                                        }
                                      },
                                      textEditingController: _product),
                                ),
                              ],
                            ),
                            DetailProduct(size: size),
                            CalcButton(),
                            // Container(
                            //   decoration: kBoxDecorationStyle,
                            //   margin: EdgeInsets.symmetric(
                            //       horizontal: kdefultsize - 10,
                            //       vertical: kdefultsize - 10),
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: kdefultsize - 10),
                            //   child: CalculatorTextField(
                            //     initialValue:
                            //         _controllerCountingStockScreen.currentValue,
                            //     textAlign: TextAlign.center,
                            //     onSubmitted: (value) {
                            //       _controllerCountingStockScreen
                            //           .updatecurrentValue(number: value ?? 0);
                            //     },
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: kdefultsize - 10),
                              child: buttonDefualt(
                                  check:
                                      controllerCountingStockScreen.getbtnSave,
                                  press: () => _controllerCountingStockScreen
                                          .getstatusnetwork
                                      ? controllerCountingStockScreen.getbtnSave
                                          ? null
                                          : controllerCountingStockScreen
                                              .fSaveStock(
                                                  context: context,
                                                  location:
                                                      _location.text.trim())
                                      : Fluttertoast.showToast(
                                          msg:
                                              "ขาดการเชื่อมต่อจากอินเทอร์เน็ต"),
                                  colorBtn: _controllerCountingStockScreen
                                          .getstatusnetwork
                                      ? blue
                                      : gray,
                                  colorBtnTx: white,
                                  fontsize: kdefultsize,
                                  titlebutton: "บันทึก"),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(child: LoadStatusSvg()),
      ),
    );
  }

  void clearAll(
      {required ControllerCountingStockScreen controllerCountingStockScreen}) {
    controllerCountingStockScreen.updatecurrentValue(number: 0);
    controllerCountingStockScreen.clearProductsCountStock();
    controllerCountingStockScreen.updatestatusBtnSave(status: false);
    setState(() {
      _location.clear();
      _product.clear();
    });
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
    _locationNode.requestFocus();
  }

  void showDialogBoxList(dynamic s) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var msg = s["massage"] ?? "";
        List<dynamic> data = s["data"] ?? [];
        print(data.length);
        return AlertDialog(
          title: Center(child: const Text('แจ้งเตือนจากระบบ')),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text(
                    "$msg",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Table(
                    border: TableBorder.all(),
                    // columnWidths: const <int, TableColumnWidth>{
                    //   0: IntrinsicColumnWidth(),
                    // },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: List.generate(
                      data.length,
                      (index) => TableRow(
                        children: <Widget>[
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.top,
                            child: Container(
                              height: 32,
                              width: 32,
                              padding: EdgeInsets.all(5),
                              color: Colors.white,
                              child: Text(
                                "${data[index]}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: Container(
                      color: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: const Text(
                        'ตกลง',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void checkLocation(
      {required ControllerCountingStockScreen
          controllerCountingStockScreen}) async {
    ControllerLoginScreen controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
    try {
      if (_location.text.isNotEmpty) {
        controllerCountingStockScreen.updatebtnLocation(status: true);
        await RequestAssistant.getRequestHttpResponse(
                url:
                    "https://localapi.homeone.co.th/erp/v1/stk/StockCount/RemainCountItem/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&location=${_location.text.trim()}",
                headers: headers)
            .then((response) {
          if (response.statusCode == 200) {
            // final dataJson = response.body;
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            showDialogBoxList(responseJson);
            // print(responseJson);
          } else if (response.statusCode == 401) {
            Fluttertoast.showToast(msg: "${response.statusCode}");
          } else if (response.statusCode == 500) {
            Fluttertoast.showToast(msg: "ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้");
          }
        }).timeout(
          Duration(seconds: 20),
          onTimeout: () {
            Fluttertoast.showToast(msg: "หมดเวลาเชื่อมต่อกับเซิฟเวอร์");
          },
        );
      } else {
        Fluttertoast.showToast(msg: "กรุณากรอกตำแหน่งที่ต้องการตรวจสอบ");
      }
    } on Exception catch (e) {
      throw Exception("$e");
    } finally {
      controllerCountingStockScreen.updatebtnLocation(status: false);
    }
  }

  void checkProduct(
      {required ControllerCountingStockScreen
          controllerCountingStockScreen}) async {
    ControllerLoginScreen controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${_user.user!.token}'};

    try {
      if (_product.text.isNotEmpty) {
        controllerCountingStockScreen.updatebtnProduct(status: true);

        await RequestAssistant.getRequestHttpResponse(
                url:
                    "https://localapi.homeone.co.th/erp/v1/stk/StockCount/RemainCountSlot/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&s=${_product.text.trim()}",
                headers: headers)
            .then((response) {
          if (response.statusCode == 200) {
            // final dataJson = response.body;
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            showDialogBoxList(responseJson);
            // print(responseJson);
          } else if (response.statusCode == 401) {
            Fluttertoast.showToast(msg: "${response.statusCode}");
          } else if (response.statusCode == 500) {
            Fluttertoast.showToast(msg: "ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้");
          }
        }).timeout(
          Duration(seconds: 20),
          onTimeout: () {
            Fluttertoast.showToast(msg: "หมดเวลาเชื่อมต่อกับเซิฟเวอร์");
          },
        );
      } else {
        Fluttertoast.showToast(msg: "กรุณากรอกสินค้าที่ต้องการตรวจสอบ");
      }
    } on Exception catch (e) {
      throw e;
    } finally {
      controllerCountingStockScreen.updatebtnProduct(status: false);
    }
  }
}
