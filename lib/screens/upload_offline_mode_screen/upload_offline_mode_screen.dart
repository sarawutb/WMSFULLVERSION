import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wms/config/config.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/database/database.dart';
import 'package:wms/models/product_offline_model.dart';
import 'package:wms/models/product_save_offline.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';

class UploadOfflineModeScreen extends StatefulWidget {
  const UploadOfflineModeScreen({Key? key}) : super(key: key);

  @override
  _UploadOfflineModeScreenState createState() =>
      _UploadOfflineModeScreenState();
}

class _UploadOfflineModeScreenState extends State<UploadOfflineModeScreen> {
  List<ProductLocal> listproductoffine = [];
  late DatabaseHandler handler;
  DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");
  @override
  void initState() {
    this.handler = DatabaseHandler();
    this.handler.initializeDB();
    handler
        .retrieveUsers()
        .then((value) => setState(() => listproductoffine = value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: Text(
          "นับสต๊อกสินค้าออฟไลน์~${_user.branchList!.branchname}",
          style: Theme.of(context)
              .textTheme
              .bodyText2!
              .copyWith(fontSize: kdefultsize - 5),
        ),
        elevation: 0,
        leading: Icon(
          Icons.arrow_back,
          size: 1,
          color: white,
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (listproductoffine.length > 0)
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AdvanceCustomAlert(
                        backgroundIcon: kPrimaryColor,
                        title: "แจ้งเตือนจากระบบ",
                        content: "คุณต้องการบันทึกรายการทั้งหมดหรือไหม ?",
                        // ignore: deprecated_member_use
                        rightButton: RaisedButton(
                          onPressed: () {
                            listproductoffine
                                .asMap()
                                .forEach((index, values) async {
                              await save(values.id!, values, false)
                                  .then((value) async {
                                print(value.itemName);
                                await savepost(
                                    index: values.id!,
                                    saveStocks: value,
                                    s: values,
                                    msg: false);
                              });
                            });
                            Navigator.of(context).pop();
                          },
                          color: red,
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
                          color: blue,
                          child: Text(
                            'ไม่',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    });
            },
            icon: Icon(
              Icons.upload,
              color: blue,
              size: kdefultsize - 5,
            ),
            label: Text(
              "บันทึกทั้งหมด",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: kdefultsize - 5, color: blue),
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: listproductoffine.length,
        itemBuilder: (context, index) => Container(
          margin: EdgeInsets.symmetric(
              horizontal: kdefultsize - 10, vertical: kdefultsize - 15),
          padding: EdgeInsets.symmetric(
              horizontal: kdefultsize - 10, vertical: kdefultsize - 15),
          decoration: kBoxDecorationStyle,
          child: Slidable(
            key: Key("${listproductoffine[index].id}"),
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: ListTile(
                isThreeLine: true,
                leading: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                  child: Text('${listproductoffine[index].id}'),
                  foregroundColor: Colors.white,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ตำแหน่ง ${listproductoffine[index].location}'),
                    Text(
                        'บาร์โค้ดสินค้า ${listproductoffine[index].productcode}'),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('จำนวน ${listproductoffine[index].count}'),
                    Text(
                        'วันเวลาที่สแกน ${dateFormat.format(listproductoffine[index].createCurrent!)}'),
                  ],
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'SAVE',
                color: Colors.green,
                icon: Icons.save_alt,
                onTap: () async => await save(listproductoffine[index].id!,
                        listproductoffine[index], null)
                    .then((value) async => await savepost(
                        index: listproductoffine[index].id!,
                        saveStocks: value,
                        s: listproductoffine[index])),
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => removeIndex(listproductoffine[index].id!),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void removeIndex(int index) {
    handler.deleteUser(index);
    handler
        .retrieveUsers()
        .then((value) => setState(() => listproductoffine = value));
  }

  Future<ProductsSaveOffline> save(
      int index, ProductLocal localProduct, bool? bool) async {
    ControllerLoginScreen controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    ProductsSaveOffline productsSaveOffline = new ProductsSaveOffline();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
    await RequestAssistant.getRequestHttpResponse(
      url:
          "https://localapi.homeone.co.th/erp/v1/stk/StockCount/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&s=${localProduct.productcode}&location=${localProduct.location}",
      headers: headers,
    ).then((response) {
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(utf8.decode(response.bodyBytes));

          if (responseJson["success"]) {
            ProductsSaveOffline products =
                ProductsSaveOffline.fromJson(responseJson["data"]);
            productsSaveOffline.itemCode = products.itemCode;
            productsSaveOffline.itemName = products.itemName;
            productsSaveOffline.unitStandard = products.unitStandard;
            productsSaveOffline.unitStandardName = products.unitStandardName;
            productsSaveOffline.currentCountStep = products.currentCountStep;
            productsSaveOffline.matchQty = localProduct.count;
            productsSaveOffline.stock = products.stock;
            productsSaveOffline.location = products.location;

            // print(productsSaveOffline.itemCode);
            // print(productsSaveOffline.itemName);
            // print(productsSaveOffline.unitStandardName);
            // print("currentCountStep==>> ${productsSaveOffline.currentCountStep}");
            // print(productsSaveOffline.unitStandard);
            // print(productsSaveOffline.matchQty);
            // print(productsSaveOffline.stock?.length);
            // print(productsSaveOffline.location?.length);

          } else {
            // Fluttertoast.showToast(msg: responseJson["massage"]);
            if (bool ?? true) showDialogBox(responseJson["massage"]);
          }

          break;
        case 401:
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              msg: "${response.statusCode}");
          break;
        case 500:
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              msg: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
          break;
        default:
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              msg: "มีข้อผิดพลาดไม่ทราบสาเหตุ");
      }
    }).timeout(
      Duration(seconds: 5),
      onTimeout: () {},
    );
    return productsSaveOffline;
  }

  Future<void> savepost(
      {required ProductsSaveOffline saveStocks,
      required int index,
      ProductLocal? s,
      bool? msg}) async {
    ControllerLoginScreen controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {
      'Authorization': 'Bearer ${_user.user!.token}',
      'Content-Type': 'application/json',
    };

    print(saveStocks.itemCode);
    if (saveStocks.itemCode != null) {
      var body = jsonEncode(saveStocks);
      await RequestAssistant.postRequestHttpResponse(
              url:
                  "https://localapi.homeone.co.th/erp/v1/stk/StockCount/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&location=${s?.location}&mode=offline&app=${InfoApp.nameApp}",
              headers: headers,
              body: body)
          .then((response) {
        switch (response.statusCode) {
          case 200:
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            if (responseJson["success"]) {
              if (msg ?? true)
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
                                child: Text(
                                  '${responseJson["massage"]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: const Text(
                                    'ตกลง',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
              removeIndex(index);
            } else {
              if (msg ?? true)
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
                                child: Text(
                                  '${responseJson["massage"]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: const Text(
                                    'ตกลง',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
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
            break;
          case 401:
            Fluttertoast.showToast(
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                msg: "${response.statusCode}");
            break;
          case 500:
            Fluttertoast.showToast(
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                msg: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");
            break;
          default:
            Fluttertoast.showToast(
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                msg: "มีข้อผิดพลาดไม่ทราบสาเหตุ");
        }
      });
    }
  }

  void showDialogBox(String s) {
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
}
