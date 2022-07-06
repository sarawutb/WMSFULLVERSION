import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/detail_product_model.dart';
import 'package:wms/models/product_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/widgets/snack.dart';
import 'package:provider/provider.dart';

class ControllerCheckProduct with ChangeNotifier {
  bool statusPage = false;
  List<Product> listProducts = [];
  DetailProduct? detailProduct;
  // Product? product;

  bool get getStatusPage => statusPage;
  List<Product> get getlistProducts => listProducts;
  DetailProduct? get getDetailProduct => detailProduct;
  // Product get getproduct => product ?? Product();

  fRemoveAll(
      {required int index,
      required Product product,
      required BuildContext context}) async {
    listProducts.removeWhere((element) =>
        !element.itemcode!.contains(listProducts[index].itemcode!));
    notifyListeners();
    this.fGetDetailProduct(product: product, context: context);
  }

  fSearch(
      {required String query,
      required BuildContext context,
      ScrollController? controller}) async {
    try {
      String _url = context.read<ControllerUser>().getendPoint;
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();
      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      statusPage = true;
      notifyListeners();

      await RequestAssistant.getRequestHttpResponse(
              url: _url +
                  "/ProductSearch/?dbid=${controllerLoginScreen.getselectedItem.value}&s=$query&opt=distinct",
              headers: headers)
          .then((response) {
        print('$query=========================>>>>>' +
            response.statusCode.toString());
        switch (response.statusCode) {
          case 200:
            var responseJson = json.decode(utf8.decode(response.bodyBytes));

            listProducts = (responseJson["data"] as List)
                .map((e) => Product.fromJson(e))
                .toList();
            if (listProducts.length == 1) {
              fGetDetailProduct(product: listProducts[0], context: context);
            }
            statusPage = false;
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
                color: Colors.red.shade300);
            statusPage = false;
            break;
          case 204:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่พบข้อมูลจากระบบ",
                color: Colors.red.shade300);
            statusPage = false;
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            statusPage = false;
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
            statusPage = false;
        }
      }).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          statusPage = false;
          return null;
        },
      );
    } catch (e) {
      showInfoFlushbar(
          context: context,
          title: "ข้อความจากระบบ",
          message: "กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต",
          color: Colors.red.shade300);
      statusPage = false;
    } finally {
      if (controller != null)
        controller.animateTo(0,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
    }
    notifyListeners();
  }

  fGetDetailProduct(
      {required Product product, required BuildContext context}) async {
    try {
      String _url = context.read<ControllerUser>().getendPoint;
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();
      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      statusPage = true;
      notifyListeners();

      await RequestAssistant.getRequestHttpResponse(
              url: _url +
                  "/ProductDetail/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.gebranchList.branchCode}&id=${product.itemcode}&type=${product.itemType}&unit=${product.unitStandard}&rawscandata=${product.gotoItem ?? product.itemcode}",
              headers: headers)
          .then((response) {
        switch (response.statusCode) {
          case 200:
            var responseJson = json.decode(utf8.decode(response.bodyBytes));
            // print(responseJson["data"]);
            detailProduct = DetailProduct.fromJson(responseJson["data"]);
            if (detailProduct!.price != null) {
              if (detailProduct!.price!.length > 0) {
                if (detailProduct!.price![0].priceMatch!) {
                  print(detailProduct!.price![0].priceMatch!);
                } else {
                  Vibration.vibrate(duration: 1000);
                  print(detailProduct!.price![0].priceMatch!);
                }
              }
            }

            statusPage = false;
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
                color: Colors.red.shade300);
            statusPage = false;
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            statusPage = false;
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
            statusPage = false;
        }
      }).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          statusPage = false;
          return null;
        },
      );
    } catch (e) {
      showInfoFlushbar(
          context: context,
          title: "ข้อความจากระบบ",
          message: "กรุณาตรวจสอบการเชื่อมต่ออินเทอร์เน็ต",
          color: Colors.red.shade300);
      statusPage = false;
    }
    notifyListeners();
  }

  void fRemoveAtIndex({required int index}) {
    listProducts.removeAt(index);
    notifyListeners();
  }

  void fClearProductList() {
    print("CLEAR LISTPRODUCT");
    listProducts.clear();
    notifyListeners();
  }
}
