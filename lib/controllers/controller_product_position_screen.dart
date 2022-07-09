import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/get_item_location_model.dart';
import 'package:wms/models/product_model.dart';
import 'package:wms/screens/product_position_screen/detail_location_page/detail_location_page.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:provider/provider.dart';
import 'package:wms/widgets/snack.dart';

class ControllerProductPositionScreen with ChangeNotifier {
//SET
  bool statuspage = false;
  bool statuspageGetltemLocation = false;
  List<String> listLocation = [];
  List<GetltemLocation> getltemLocation = [];
  List<GetltemLocation> getCheckltemLocation = [];
  List<Product> addListProducts = [];
  int select = 0;
  String? locationName;

//GET
  bool get getstatuspage =>
      statuspage; // ! สถานะโหลดข้อมูลหน้าในหน้าแสกนหาตำแหน่ง
  bool get getstatuspageGetltemLocation =>
      statuspageGetltemLocation; // ! สถานะโหลดข้อมูลหน้าจอหลัก
  List<String> get getlistLocation =>
      listLocation; // ! รายตำแหน่งในหน้าแสกนหาตำแหน่ง
  List<GetltemLocation> get getltemLocations =>
      getltemLocation; // ! รายการที่แสดงในจอหลัก
  int get kGetselect => select;
  String get kGetLocationname => locationName ?? "";

  List<Product> get getAddListProducts =>
      addListProducts; // ! list รายการเพิ่มสินค้าเข้าสู่ตำแหน่ง
//UPDATE
  void updatestatuspage({required bool status}) {
    print("STATUS UPDATE SCREEN");
    statuspage = status;
    notifyListeners();
  }

  void updatestatuspageGetltemLocation({required bool status}) {
    print("STATUS UPDATE GETLOCATION");
    statuspageGetltemLocation = status;
    notifyListeners();
  }

  void updatelistLocatione({required List<String> list}) {
    print("List UPDATE SCREEN");
    listLocation = list;
    notifyListeners();
  }

  void updategetltemLocations({required List<GetltemLocation> item}) {
    getCheckltemLocation = item;
    print("LIST GETLOCATION UPDATE");
    item.forEach((eitem) {
      if (!getltemLocation.any((e) => e.itemCode == eitem.itemCode)) {
        getltemLocation.add(eitem);
      }
    });

    notifyListeners();
  }

  void updateLocationName({required String location}) {
    print("UPDATE LOCATION IS $location");
    locationName = location;
    notifyListeners();
  }

  // ignore: todo
  // TODO Position
  void fSearchProductPosition(
      {required String query,
      required ControllerProductPositionScreen controllerProductPositionScreen,
      required BuildContext context}) async {
    try {
      controllerProductPositionScreen.updatestatuspage(status: true);
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();

      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      String _url = context.read<ControllerUser>().getendPoint;
      await RequestAssistant.getRequestHttpResponse(
              url: _url +
                  "/ItemLocation/List/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&location=${query.toUpperCase()}",
              headers: headers)
          .then((response) {
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            updatelistLocatione(
                list: List<String>.from(responsejson["data"].map((x) => x)));
            if (listLocation.length == 1) {
              updateLocationName(
                  location: listLocation[0].isEmpty ? "" : listLocation[0]);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailLocationPage()));
            }

            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
                color: Colors.red.shade300);
            break;
          case 204:
            fClearListLocation();
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่พบตำแหน่งจัดเก็บนี้",
                color: Colors.red.shade300);
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      }).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          return null;
        },
      );
    } finally {
      Future.delayed(
          Duration(milliseconds: 200),
          () =>
              controllerProductPositionScreen.updatestatuspage(status: false));
    }
  }

  void fdetailproductposition(
      {required String query, required BuildContext context}) async {
    ControllerLoginScreen controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
    String _url = context.read<ControllerUser>().getendPoint;

    try {
      await RequestAssistant.getRequestHttpResponse(
              url: _url +
                  "/ItemLocation/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&location=$query",
              headers: headers)
          .then((response) {
        print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));

            List<GetltemLocation> item = (responsejson["data"] as List)
                .map((e) => GetltemLocation.fromJson(e))
                .toList();

            updategetltemLocations(item: item);
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
                color: Colors.red.shade300);
            break;
          case 204:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่พบตำแหน่งจัดเก็บนี้",
                color: Colors.red.shade300);
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      });
    } finally {
      updatestatuspageGetltemLocation(status: false);
    }
  }

  // ignore: todo
  // TODO REORDER
  void addProductToList({required Product product}) {
    addListProducts.add(product);
    notifyListeners();
  }

  // ignore: todo
  // TODO REORDER
  void fonDelete(newIndex) {
    getltemLocation.removeAt(newIndex);
    notifyListeners();
  }

  void fonReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    GetltemLocation item = getltemLocation.removeAt(oldIndex);
    getltemLocation.insert(newIndex, item);
    notifyListeners();
  }

  void foninsert(int oldIndex, int newIndex) {
    GetltemLocation item = getltemLocation.removeAt(oldIndex);
    getltemLocation.insert(newIndex, item);
    notifyListeners();
  }

  void isSelected(int newItem) {
    select = newItem;
    notifyListeners();
  }

//REMOVE
  void fClearList() {
    getltemLocation.clear();
    notifyListeners();
  }

  // รายการในหน้าค้นหาตำแหน่ง
  void fClearListLocation() {
    print("ลบรายการในหน้าค้นหาตำแหน่งทั้งหมด");
    listLocation.clear();
    notifyListeners();
  }

  void fClearAddListProducts() {
    addListProducts.clear();
    notifyListeners();
  }

  void fRemoveAtIndex({required int index}) {
    addListProducts.removeAt(index);
    notifyListeners();
  }

// ! INSERT DATA TO LIST
  void fInsertToListgetltemLocation(
      {required List<Product> item, required String locationName}) {
    // ignore: todo
    // TODO Add Product To List getltemLocation
    item.asMap().forEach((index, product) {
      getltemLocation.add(GetltemLocation(
          itemCode: product.itemcode ?? null,
          unitCode: product.unitStandard ?? null,
          locationName: locationName,
          itemName: product.itemname ?? null));
    });
    addListProducts.clear();
    notifyListeners();
  }

// * POST บันทึกสินค้าเข้าตำแหน่ง
  Future fPostProductPosition(
      {required List<GetltemLocation> list,
      required ControllerProductPositionScreen controllerProductPositionScreen,
      required BuildContext context}) async {
    try {
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();

      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {
        'Authorization': 'Bearer ${_user.user!.token}',
        'Content-Type': 'application/json',
      };
      String _url = context.read<ControllerUser>().getendPoint;
      var body = getltemLocationToJson(list);
      print(body);
      print(headers);
      print(_url +
          "/ItemLocation/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.gebranchList.branchCode}&location=$locationName");
      await RequestAssistant.postRequestHttpResponse(
              url: _url +
                  "/ItemLocation/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.gebranchList.branchCode}&location=$locationName",
              headers: headers,
              body: body)
          .then((response) {
        print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            if (responsejson["success"]) {
              getCheckltemLocation = getltemLocation;
              Fluttertoast.showToast(msg: "บันทึกสำเร็จ");
            } else {
              Fluttertoast.showToast(msg: "บันทึกไม่สำเร็จ");
            }
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "401 กรุณาเข้าสู่ระบบใหม่",
                color: Colors.red.shade300);
            break;
          case 405:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "405 กรุณาเข้าสู่ระบบใหม่",
                color: Colors.red.shade300);
            break;
          case 204:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "204",
                color: Colors.red.shade300);
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      }).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          return null;
        },
      );
    } catch (e) {
      showInfoFlushbar(
          context: context,
          title: "ข้อความจากระบบ",
          message: "$e",
          color: Colors.red.shade300);
    } finally {}
  }
}
