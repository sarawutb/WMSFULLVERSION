import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms/config/config.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/date_count_model.dart';
import 'package:wms/models/detaillog_model.dart';
import 'package:wms/models/getlog_model.dart';
import 'package:wms/models/product.countstock.model.dart';
import 'package:provider/provider.dart';
import 'package:wms/screens/couting_stock_screen/detail_log_screen/detail_log_screen.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/dialogbox.dart';
import 'package:wms/widgets/snack.dart';

class ControllerCountingStockScreen extends ChangeNotifier {
  // DEFUALT
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("dd-MM-yyyy");

  // SET INIT VALUE
  bool statuspage = true;
  bool statusnetwork = true;
  bool btnSave = false;
  bool btnLocation = false;
  bool btnProduct = false;
  double currentValue = 0;
  ProductsCountStock? productsCountStock;
  DateCount? datecount;
  // GET VALUE
  bool get getstatuspage => statuspage;
  bool get getstatusnetwork => statusnetwork;
  bool get getbtnSave => btnSave;
  bool get getbtnLocation => btnLocation;
  bool get getbtnProduct => btnProduct;
  double get getcurrentValue => currentValue;
  ProductsCountStock get getproductsCountStock =>
      productsCountStock ?? ProductsCountStock();
  DateCount get getdatecount => datecount ?? DateCount();

  // UPDATE VALUE
  updatestatuspage({required bool status}) {
    print("UPDATE STATUS STATE $status");
    statuspage = status;
    notifyListeners();
  }

  updatestatusnetwork({required bool status}) {
    print("UPDATE STATUS NETWORK $status");
    statusnetwork = status;
    notifyListeners();
  }

  updatebtnLocation({required bool status}) {
    print("UPDATE STATUS btnLocation $status");
    btnLocation = status;
    notifyListeners();
  }

  updatebtnProduct({required bool status}) {
    print("UPDATE STATUS btnProduct $status");
    btnProduct = status;
    notifyListeners();
  }

  updatecurrentValue({required double number}) {
    print("UPDATE NUMBER $number");
    currentValue = number;
    notifyListeners();
  }

  updateProductsCountStock({required ProductsCountStock product}) {
    print("UPDATE PRODUCT");
    productsCountStock = product;
    notifyListeners();
  }

  updatedatecount({required DateCount dateTime}) {
    print("UPDATE datecount");
    datecount = dateTime;
    dateTime.data!.forEach((element) {
      print(element.startdate);
    });
    notifyListeners();
  }

  updatestatusBtnSave({required bool status}) {
    print("UPDATE STATUS BUTTON");
    btnSave = status;
    notifyListeners();
  }

  // REMOVE VALUE
  clearProductsCountStock() {
    print("SET NULL PRODUCT");
    productsCountStock = new ProductsCountStock();
    notifyListeners();
  }

  // ! ดึงข้อมูลสินค้า
  fFetchDataProductCountStock(
      {required String query,
      required BuildContext context,
      required String location}) async {
    try {
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();
      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      this.updatestatuspage(status: true);
      await RequestAssistant.getRequestHttpResponse(
              url:
                  "https://localapi.homeone.co.th/erp/v1/stk/StockCount/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&s=${query.trim()}&location=${location.trim()}",
              headers: headers)
          .then((response) {
        print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            if (responsejson["success"]) {
              ProductsCountStock _productsCountStock =
                  ProductsCountStock.fromJson(responsejson["data"]);
              updateProductsCountStock(product: _productsCountStock);
            } else {
              GetLog _getlog = GetLog.fromJson(responsejson["data"]);
              dialogWidget(
                  context: context,
                  height: 300,
                  title: "แจ้งเตือนจากระบบ",
                  subtitle: "${responsejson["massage"]}",
                  leftBtn: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "ตกลง",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: red),
                      )),
                  rightBtn: TextButton(
                      onPressed: () async {
                        this.updatestatuspage(status: true);
                        List<DetailLog> _list = [];
                        try {
                          await RequestAssistant.getRequestHttpResponse(
                                  url:
                                      "https://localapi.homeone.co.th/erp/v1/stk/StockCount/CountLog/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&item=${_getlog.itemCode}&location=${_getlog.location}&count_step=${_getlog.countStep}",
                                  headers: headers)
                              .then((response) async {
                            print(response.statusCode);
                            switch (response.statusCode) {
                              case 200:
                                var responsejson = json
                                    .decode(utf8.decode(response.bodyBytes));
                                print(responsejson["data"]);
                                if (responsejson["success"]) {
                                  _list = (responsejson["data"] as List)
                                      .map((e) => DetailLog.fromJson(e))
                                      .toList();
                                  _list.forEach((element) {
                                    print(element.location);
                                  });
                                  var res = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetalGetLogScreen(list: _list)));
                                  if (res != "OK") {
                                    Navigator.of(context).pop();
                                  }
                                } else {
                                  Navigator.of(context).pop();
                                }
                                break;
                              case 401:
                                showInfoFlushbar(
                                    context: context,
                                    title: "ข้อความจากระบบ",
                                    message: "${response.statusCode}",
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
                                    message:
                                        "มีข้อผิดพลาดไม่ทราบสาเหตุ${response.statusCode}",
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
                          throw e;
                        } finally {
                          this.updatestatuspage(status: false);

                          // Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        "ประวัติการนับ",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(color: Colors.green),
                      )));

              // showInfoFlushbar(
              //     context: context,
              //     title: "ข้อความจากระบบ",
              //     message: "${responsejson["massage"]}",
              //     color: Colors.red.shade300);
            }

            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "${response.statusCode}",
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
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ${response.statusCode}",
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
      Future.delayed(Duration(milliseconds: 200),
          () => this.updatestatuspage(status: false));
    }
  }

  // ! ดึงเวลานับสต๊อก
  fFetchDateCount({required BuildContext context}) async {
    try {
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();
      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {'Authorization': 'Bearer ${_user.user!.token}'};
      updatestatuspage(status: true);
      await RequestAssistant.getRequestHttpResponse(
              url:
                  "https://localapi.homeone.co.th/erp/v1/stk/StockCount/CountDate/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}",
              headers: headers)
          .then((response) {
        print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            updatedatecount(dateTime: DateCount.fromJson(responsejson));
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "${response.statusCode}",
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
    } finally {
      updatestatuspage(status: false);
    }
  }

  fSaveStock({
    required BuildContext context,
    required String location,
  }) async {
    updatestatusBtnSave(status: true);
    print(this.currentValue);
    ProductsCountStock _productsUpload = ProductsCountStock();
    _productsUpload = this.getproductsCountStock;
    _productsUpload.matchQty = this.currentValue.toString();
    var body = jsonEncode(_productsUpload);
    print(body);
    try {
      ControllerLoginScreen controllerLoginScreen =
          context.read<ControllerLoginScreen>();
      final ControllerUser _user =
          Provider.of<ControllerUser>(context, listen: false);
      var headers = {
        'Authorization': 'Bearer ${_user.user!.token}',
        'Content-Type': 'application/json',
      };
      this.updatestatuspage(status: true);
      await RequestAssistant.postRequestHttpResponse(
              url:
                  "https://localapi.homeone.co.th/erp/v1/stk/StockCount/?dbid=${controllerLoginScreen.getselectedItem.value}&branch=${_user.branchList!.branchCode}&location=$location&app=android_stock_count${InfoApp.nameApp}}",
              headers: headers)
          .then((response) {
        print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "${responsejson["massage"]}",
                color: Colors.red.shade300);
            clearProductsCountStock();
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "${response.statusCode}",
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
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ${response.statusCode}",
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
      updatestatusBtnSave(status: false);
      Future.delayed(Duration(milliseconds: 200),
          () => this.updatestatuspage(status: false));
    }
  }
}
