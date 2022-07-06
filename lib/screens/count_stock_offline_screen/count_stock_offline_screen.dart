import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wms/controllers/controller_offline_screen.dart';
import 'package:wms/database/database.dart';
import 'package:wms/models/product_offline_model.dart';
import 'package:wms/models/productcheckoffline_model.dart';
import 'package:provider/provider.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/button_defualt.dart';
import 'package:wms/widgets/text_form_search.dart';

class CountStockOfflineScreen extends StatefulWidget {
  const CountStockOfflineScreen({Key? key}) : super(key: key);

  @override
  _CountStockOfflineScreenState createState() =>
      _CountStockOfflineScreenState();
}

class _CountStockOfflineScreenState extends State<CountStockOfflineScreen> {
  late DatabaseHandler handler;
  List<ProductLocal> listproductoffline = [];
  List<ProductLocal> list = [];

  final TextEditingController _location = TextEditingController();
  final TextEditingController _product = TextEditingController();
  final TextEditingController _count = TextEditingController();
  FocusNode _locationNode = FocusNode();
  FocusNode _productNode = FocusNode();
  FocusNode _countNode = FocusNode();
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
    handler
        .retrieveUsers()
        .then((value) => setState(() => listproductoffline = value))
        .whenComplete(() => readFilesFromCustomDevicePath());
    _locationNode.requestFocus();
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
    super.initState();
  }

  readFilesFromCustomDevicePath() async {
    // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
    Directory? directory = await getExternalStorageDirectory();
    List<ProductCheckOffline> _productCheckOffline = [];
    ControllerOfflineScreen controllerOfflineScreen =
        context.read<ControllerOfflineScreen>();
    // Create a new file. You can create any kind of file like txt, doc , json etc.
    File file = await File("${directory!.path}/ubonjsondb.json").create();
    print(file);
    // Read the file content
    String fileContent = await file.readAsString();
    final data = await json.decode(fileContent);

    _productCheckOffline =
        (data as List).map((e) => ProductCheckOffline.fromJson(e)).toList();
    controllerOfflineScreen.updateproductCheckOffline(
        list: _productCheckOffline);
  }

  void addproduct(
      {required ProductLocal product,
      required ControllerOfflineScreen controllerOfflineScreen}) async {
    bool _checkproduct = false;
    if (_product.text.isNotEmpty) {
      if (controllerOfflineScreen.kGetofflineProduct.any(
              (element) => element.location == _location.text.toUpperCase()) &&
          controllerOfflineScreen.kGetofflineProduct
              .any((element) => element.itemCode == _product.text)) {
        _checkproduct = true;
      }
      if (_checkproduct) {
        bool _check = false;
        if ((listproductoffline
                .any((element) => element.location == product.location)) &&
            (listproductoffline.any(
                (element) => element.productcode == product.productcode)) &&
            (listproductoffline
                .any((element) => element.count == product.count))) {
          _check = true;
        }

        if (_check) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AdvanceCustomAlert(
                  backgroundIcon: kPrimaryColor,
                  title: "แจ้งเตือนจากระบบ",
                  content:
                      "รายการนี้มีการนับเข้ามาแล้ว\nต้องการนับซ้ำหรือไม่ ?",
                  // ignore: deprecated_member_use
                  rightButton: RaisedButton(
                    onPressed: () {
                      controllerOfflineScreen.kGetofflineProduct
                          .forEach((element) {
                        if (product.productcode == element.barcode) {
                          product.productname = element.itemName;
                        }
                      });
                      setState(() {
                        list.clear();

                        list.insert(0, product);
                      });
                      handler.insertProduct(list);
                      handler.retrieveUsers().then((value) =>
                          setState(() => listproductoffline = value));
                      clearallAll();
                      Navigator.of(context).pop();
                    },
                    color: Colors.red,
                    child: Text(
                      'ตกลง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  leftButton: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.blue,
                    child: Text(
                      'ไม่',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              });
        } else {
          controllerOfflineScreen.kGetofflineProduct.forEach((element) {
            if (product.productcode == element.barcode) {
              product.productname = element.itemName;
            }
          });
          setState(() {
            list.clear();

            list.insert(0, product);
          });
          handler.insertProduct(list);
          handler
              .retrieveUsers()
              .then((value) => setState(() => listproductoffline = value));
          clearallAll();
        }
      } else {
        SystemChannels.textInput.invokeListMethod('TextInput.hide');
        _showDialogBox("ไม่พบสินค้าในตำแหน่งนี้");
      }
    } else {
      _locationNode.requestFocus();
      Future.delayed(Duration(milliseconds: 300), () {
        SystemChannels.textInput.invokeListMethod('TextInput.hide');
      });
    }
  }

  void removeIndex(int index) {
    handler.deleteUser(index);
    handler
        .retrieveUsers()
        .then((value) => setState(() => listproductoffline = value));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ControllerOfflineScreen controllerOfflineScreen =
    //     context.read<ControllerOfflineScreen>();

    return Consumer<ControllerOfflineScreen>(
      builder: (context, controllerOfflineScreen, child) => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          backgroundColor: white,
          title: Column(
            children: [
              Text(
                "OFFLINE MODE",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "จำนวนรายการนับในวันนี้ ${controllerOfflineScreen.kGetofflineProduct.length}",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: red,
                      fontSize: kdefultsize - 12,
                    ),
              ),
            ],
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () => null,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: white,
              size: kdefultsize - 19,
            ),
          ),
          actions: [
            TextButton.icon(
                onPressed: () => clearallAll(),
                icon: Icon(Icons.refresh),
                label: Text("รีเซต"))
          ],
        ),
        body: controllerOfflineScreen.kGetofflineProduct.length > 0
            ? GestureDetector(
                onTap: () =>
                    SystemChannels.textInput.invokeListMethod('TextInput.hide'),
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: kdefultsize - 10),
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
                                          .copyWith(fontSize: kdefultsize - 10),
                                    ),
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
                                node: _locationNode,
                                icon: Icons.close,
                                context: context,
                                autoFocus: false,
                                hintText: "ตำแหน่งจัดกับสินค้า",
                                press: () {
                                  _location.clear();
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    SystemChannels.textInput
                                        .invokeListMethod('TextInput.hide');
                                  });
                                },
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (string) {
                                  bool _checklocation = false;
                                  if (_location.text.isNotEmpty) {
                                    if (controllerOfflineScreen
                                        .productCheckOffline
                                        .any((element) =>
                                            element.location ==
                                            _location.text)) {
                                      _checklocation = true;
                                    }
                                    if (_checklocation) {
                                      SystemChannels.textInput
                                          .invokeListMethod('TextInput.hide');
                                      _productNode.requestFocus();
                                    } else {
                                      SystemChannels.textInput
                                          .invokeListMethod('TextInput.hide');
                                      _showDialogBox("ไม่พบตำแหน่งนี้");
                                    }
                                  }

                                  // _productNode.requestFocus();
                                  // Future.delayed(Duration(milliseconds: 300),
                                  //     () {
                                  //   SystemChannels.textInput
                                  //       .invokeListMethod('TextInput.hide');
                                  // });
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
                              padding: EdgeInsets.only(left: kdefultsize - 10),
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
                                          .copyWith(fontSize: kdefultsize - 10),
                                    ),
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
                                hintText: "บาร์โค้ด",
                                press: () {
                                  _product.clear();
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    SystemChannels.textInput
                                        .invokeListMethod('TextInput.hide');
                                  });
                                },
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (string) {
                                  bool _checkproduct = false;
                                  if (_product.text.isNotEmpty) {
                                    if (controllerOfflineScreen
                                            .productCheckOffline
                                            .any((element) =>
                                                element.location ==
                                                _location.text.toUpperCase()) &&
                                        controllerOfflineScreen
                                            .productCheckOffline
                                            .any((element) =>
                                                element.itemCode ==
                                                _product.text)) {
                                      _checkproduct = true;
                                    }
                                    if (_checkproduct) {
                                      SystemChannels.textInput
                                          .invokeListMethod('TextInput.hide');
                                      _countNode.requestFocus();
                                    } else {
                                      SystemChannels.textInput
                                          .invokeListMethod('TextInput.hide');
                                      _showDialogBox("ไม่พบสินค้าในตำแหน่งนี้");
                                    }
                                  }
                                },
                                textEditingController: _product),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: kdefultsize - 10),
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
                                      "จำนวน",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(fontSize: kdefultsize - 10),
                                    ),
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
                                node: _countNode,
                                icon: Icons.close,
                                context: context,
                                autoFocus: false,
                                hintText: "จำนวนที่นับได้",
                                press: () {
                                  _count.clear();
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    SystemChannels.textInput
                                        .invokeListMethod('TextInput.hide');
                                  });
                                },
                                keyboardType: TextInputType.text,
                                onFieldSubmitted: (string) {},
                                textEditingController: _count),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kdefultsize - 10,
                            vertical: kdefultsize - 10),
                        child: buttonDefualt(
                            check: controllerOfflineScreen.getstatusBtnSave,
                            press: () => controllerOfflineScreen
                                        .productCheckOffline.length >
                                    0
                                ? addproduct(
                                    product: ProductLocal(
                                        count: _count.text,
                                        createCurrent: DateTime.now(),
                                        location: _location.text,
                                        productcode: _product.text),
                                    controllerOfflineScreen:
                                        controllerOfflineScreen)
                                : Fluttertoast.showToast(
                                    msg: "ไม่มีรายการนับวันนี้"),
                            colorBtn: blue,
                            colorBtnTx: white,
                            fontsize: kdefultsize,
                            titlebutton: "บันทึก"),
                      ),
                      Expanded(
                        child: Container(
                          color: white,
                          child: listproductoffline.length > 0
                              ? ListView.builder(
                                  itemCount: listproductoffline.length,
                                  itemBuilder: (context, index) => Card(
                                    color: index.isOdd
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Slidable(
                                        key: Key(
                                            "${listproductoffline[index].id}"),
                                        actionPane: SlidableDrawerActionPane(),
                                        actionExtentRatio: 0.25,
                                        child: Container(
                                          color: Colors.white,
                                          child: ListTile(
                                            isThreeLine: true,
                                            leading: CircleAvatar(
                                              backgroundColor:
                                                  Colors.indigoAccent,
                                              child: Text(
                                                  '${listproductoffline[index].id}'),
                                              foregroundColor: Colors.white,
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ตำแหน่ง ${listproductoffline[index].location}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          fontSize:
                                                              kdefultsize - 8),
                                                ),
                                                Text(
                                                  'บาร์โค้ดสินค้า ${listproductoffline[index].productcode}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          fontSize:
                                                              kdefultsize - 10),
                                                ),
                                              ],
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'ชื่อสินค้า ${listproductoffline[index].productname}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          fontSize:
                                                              kdefultsize - 10),
                                                ),
                                                Text(
                                                  'จำนวน ${listproductoffline[index].count}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2!
                                                      .copyWith(
                                                          fontSize:
                                                              kdefultsize - 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        secondaryActions: <Widget>[
                                          IconSlideAction(
                                            caption: 'Delete',
                                            color: Colors.red,
                                            icon: Icons.delete,
                                            onTap: () => removeIndex(
                                                listproductoffline[index].id!),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: kdefultsize,
                                        color: black,
                                      ),
                                      Text(
                                        "ไม่มีรายการในโหมดออฟไลน์",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2,
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "***ไม่มีรายการที่นับในวันนี้ หากมีการนับให้ไปโหลดรายการจากหน้าออนไลน์",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: Colors.red),
                  ),
                ),
              ),
      ),
    );
  }

  void _showDialogBox(String s) {
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
                    child: Text('$s'),
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

  void clearallAll() {
    _location.clear();
    _product.clear();
    _count.clear();
    _locationNode.requestFocus();
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
  }
}
