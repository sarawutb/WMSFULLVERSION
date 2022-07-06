import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/productcheckoffline_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:provider/provider.dart';

import 'controller_couting_scock_scrren.dart';

class ControllerOfflineScreen extends ChangeNotifier {
  // SET VALUE
  List<ProductCheckOffline> productCheckOffline = [];
  bool statusBtnSave = false;
  // GET VALUE
  List<ProductCheckOffline> get kGetofflineProduct => productCheckOffline;
  bool get getstatusBtnSave => statusBtnSave;

  updateproductCheckOffline({required List<ProductCheckOffline> list}) {
    productCheckOffline = list;
    notifyListeners();
  }

  //UPDATE
  updatestatusBtnSave({required bool status}) {
    statusBtnSave = status;
    notifyListeners();
  }

  // ! เขียนไฟล์ลงในเครื่อง
  Future<File> writeFilesToCustomDevicePath(
      List<ProductCheckOffline> product) async {
    // Retrieve "External Storage Directory" for Android and "NSApplicationSupportDirectory" for iOS
    Directory? directory = await getExternalStorageDirectory();

    // Create a new file. You can create any kind of file like txt, doc , json etc.
    File file = await File("${directory!.path}/ubonjsondb.json").create();
    print(file);
    // Convert json object to String data using json.encode() method
    String fileContent = json.encode(product);

    // You can write to file using writeAsString. This method takes string argument
    // To write to text file we can use like file.writeAsString("Toastguyz file content");
    return await file.writeAsString(fileContent);
  }

  // ! โหลดข้อมูลจาก API สินค้าที่นับในวันนนั้น
  Future<void> loadData({required BuildContext context}) async {
    productCheckOffline.clear();
    ControllerCountingStockScreen controllerCountingStockScreen =
        context.read<ControllerCountingStockScreen>();
    try {
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();

      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      controllerCountingStockScreen.updatestatuspage(status: true);
      await RequestAssistant.getRequestHttpResponse(
              url:
                  "https://localapi.homeone.co.th/erp/v1/stk/StockCount/GetProduct/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}",
              headers: headers)
          .then((response) async {
        switch (response.statusCode) {
          case 200:
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            if (responseJson["success"]) {
              productCheckOffline = (responseJson["data"] as List)
                  .map((e) => ProductCheckOffline.fromJson(e))
                  .toList();

              await removeFile().whenComplete(() async =>
                  await writeFilesToCustomDevicePath(productCheckOffline));

              Fluttertoast.showToast(
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  msg: "โหลดข้อมูลโหมดออฟไลน์สำเร็จ");
            } else {
              await writeFilesToCustomDevicePath(productCheckOffline);
              Fluttertoast.showToast(
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.CENTER,
                  msg:
                      "โหลดข้อมูลโหมดออฟไลน์ล้มเหลว${responseJson["massage"]}");
            }
            // print(productCheckOffline.length);
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
        Duration(seconds: 20),
        onTimeout: () {
          Fluttertoast.showToast(
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              msg: "หมดเวลาเชื่อมต่อเซิฟเวอร์");
        },
      ).catchError((error, msg) {
        Fluttertoast.showToast(
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            msg: "โหลดข้อมูลโหมดออฟไลน์ล้มเหลว$error");
      });
    } catch (e) {
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          msg: "$e");
    } finally {
      controllerCountingStockScreen.updatestatuspage(status: false);
    }
  }

  // REMOVE
  // ! โหลดข้อมูลจาก API สินค้าที่นับในมันนั้น
  Future<bool> removeFile() async {
    Directory? directory = await getExternalStorageDirectory();
    await File("${directory!.path}/ubonjsondb.json")
        .delete()
        .then((value) => print("REMOVE >> $value"));
    return true;
  }
}
