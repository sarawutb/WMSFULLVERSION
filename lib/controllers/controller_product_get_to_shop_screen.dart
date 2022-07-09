import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/po_model.dart';
import 'package:wms/models/product_po_model.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/widgets/snack.dart';
import 'package:provider/provider.dart';
// import 'package:collection/collection.dart';

class ControllerProductGetToShopScreen with ChangeNotifier {
  bool statusPage = false;
  DateTime newnow = DateTime.now();
  // List<Po> po = [];
  List<ProductPo> listProductpo = [];
  List<ProductPo> listSearProductpo = [];

  bool get getStatusPage => statusPage;
  DateTime get getnewnow => newnow;
  // List<Po> get getpo => po;

  ProductPo po = new ProductPo();

  // ! UPDATE PO START GET FROM INDEX
  updatePoFromScreenGetListPo({required ProductPo po1}) {
    po = po1;
    notifyListeners();
  }

  // ! UPDATE PO
  updateListProductPo({required List<ProductPo> list}) {
    listProductpo = list;
    notifyListeners();
  }

  updateStatePage({required bool status}) {
    statusPage = status;
    notifyListeners();
  }

  updategetpo({required List<Po> p, required BuildContext context}) {
    // bool _validate = true;
    // Function eq = const ListEquality().equals;

    // po.forEach((element1) {
    //   p.forEach((element2) {
    //     if (po.contains(element2)) {
    //       p.remove(element2);
    //     }
    //   });
    // });

    // po.addAll(p);
    // if (eq(po, p)) {
    //   showInfoFlushbar(
    //       context: context,
    //       title: "ข้อความจากระบบ",
    //       message: "เลขที่ PO นี้มีอยู่ในรายการแล้ว",
    //       color: Colors.green.shade300);
    // } else {
    //   po.addAll(p);
    // }

    // if (p.length == 0) {
    //   showInfoFlushbar(
    //       context: context,
    //       title: "ข้อความจากระบบ",
    //       message: "ไม่พบเลขที่ PO นี้",
    //       color: Colors.red.shade300);
    // } else {
    //   if (po.length == 0) {
    //     po.addAll(p);
    //   } else {
    //     po.forEach((e) {
    //       p.forEach((element) {
    //         if (e.supplier!.name! == element.supplier!.name!) {
    //           // print("เจ้าหนี้ซ้ำ");
    //           if (e.poLists!.length == 0) {
    //             e.poLists!.addAll(element.poLists!);
    //           } else {
    //             e.poLists!.forEach((epoListsOld) {
    //               element.poLists!.forEach((epoListsNew) {
    //                 print(epoListsNew);
    //                 if (epoListsOld != epoListsNew) {
    //                   element.poLists!.add(epoListsNew);
    //                 } else {
    //                   _validate = false;
    //                 }
    //               });
    //             });
    //           }
    //         }
    //       });
    //     });

    //     if (_validate) {
    //       // po.addAll(p);
    //     } else {
    //       showInfoFlushbar(
    //           context: context,
    //           title: "ข้อความจากระบบ",
    //           message: "เลขที่ PO นี้มีอยู่ในรายการแล้ว",
    //           color: Colors.green.shade300);
    //     }
    //   }
    // }

    notifyListeners();
  }

  updateCheckBoxStatus({required int index}) {
    listProductpo[index].boolcheckBox = !listProductpo[index].boolcheckBox;
    debugPrint(
        "UPDATE STATUS CHECKBOX 1${listProductpo[index].boolcheckBox}$index");
    debugPrint(
        "UPDATE STATUS CHECKBOX 2${listProductpo[index].boolcheckBox}$index");
    debugPrint(
        "UPDATE STATUS CHECKBOX 3${listProductpo[index].boolcheckBox}$index");
    debugPrint(
        "UPDATE STATUS CHECKBOX 4${listProductpo[index].boolcheckBox}$index");
    debugPrint(
        "UPDATE STATUS CHECKBOX 5${listProductpo[index].boolcheckBox}$index");
    notifyListeners();
  }

  updateCheckBoxStatusAllTrue() {
    listProductpo.forEach((element) {
      element.boolcheckBox = true;
    });
    debugPrint("UPDATE STATUS CHECKBOX 1");
    debugPrint("UPDATE STATUS CHECKBOX 2");
    debugPrint("UPDATE STATUS CHECKBOX 3");
    debugPrint("UPDATE STATUS CHECKBOX 4");
    debugPrint("UPDATE STATUS CHECKBOX 5");
    notifyListeners();
  }

  updateCheckBoxStatusAllFalse() {
    listProductpo.forEach((element) {
      element.boolcheckBox = false;
    });
    debugPrint("UPDATE STATUS CHECKBOX 1");
    debugPrint("UPDATE STATUS CHECKBOX 2");
    debugPrint("UPDATE STATUS CHECKBOX 3");
    debugPrint("UPDATE STATUS CHECKBOX 4");
    debugPrint("UPDATE STATUS CHECKBOX 5");
    notifyListeners();
  }

  updatenewnow({required DateTime date}) {
    debugPrint("UPDATE DATE NOW1");
    debugPrint("UPDATE DATE NOW2");
    debugPrint("UPDATE DATE NOW3");
    debugPrint("UPDATE DATE NOW4");
    debugPrint("UPDATE DATE NOW5");
    newnow = date;
    notifyListeners();
  }

  removeAtgetpo({required int index}) {
    listProductpo.removeAt(index);
    notifyListeners();
  }

  // addgetpo({required Po p}) {
  //   po.add(p);
  //   notifyListeners();
  // }

  // addgetListpo({required String str, required int index}) {
  //   po[index].poLists!.add(str);
  //   notifyListeners();
  // }

  removeAtgetListpo({required int index, required int indexPolist}) {
    listProductpo[index].itemDetail!.removeAt(indexPolist);
    notifyListeners();
  }

  addproducttoListProductPo(
      {required ProductPo product, required BuildContext context}) {
    if (listProductpo.any((element) => element.custCode == product.custCode)) {
      showInfoFlushbar(
          context: context,
          title: "ข้อความจากระบบ",
          message: "มี ${product.arName} อยู่ในรายการแล้ว",
          color: Colors.red);
    } else {
      listProductpo.add(product);
    }
    listSearProductpo.clear();
    notifyListeners();
  }
  // clearListPo() {
  //   po.clear();
  //   notifyListeners();
  // }

  clearData() {
    listProductpo.clear();
    listSearProductpo.clear();
    newnow = DateTime.now();
    debugPrint("CLEAR DATA PRODUCT 1");
    debugPrint("CLEAR DATA PRODUCT 2");
    debugPrint("CLEAR DATA PRODUCT 3");
    debugPrint("CLEAR DATA PRODUCT 4");
    debugPrint("CLEAR DATA PRODUCT 5");
    notifyListeners();
  }

  Future<void> searchListPo(
      {required String query,
      required String date,
      required BuildContext context}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Container(
                height: 35,
                child: new Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                        width: 30,
                        height: 30,
                        child: new CircularProgressIndicator()),
                    SizedBox(
                      width: 20,
                    ),
                    new Text("กำลังโหลด"),
                  ],
                ),
              ),
            ),
          );
        },
      );

      ControllerLoginScreen db = context.read<ControllerLoginScreen>();
      print(BaseUrl.url +
          'get?query=${query.toUpperCase()}&date=$date&db=${db.getselectedItem.value}');
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'get?query=${query.toUpperCase()}&date=$date&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          // updateStatePage(status: false);
          var responsejson = json.decode(utf8.decode(response.bodyBytes));
          debugPrint("UPDATE PRODUCT1");
          debugPrint("UPDATE PRODUCT2");
          debugPrint("UPDATE PRODUCT3");
          debugPrint("UPDATE PRODUCT4");
          debugPrint("UPDATE PRODUCT5");
          print(responsejson["data"]);
          listSearProductpo = (responsejson["data"] as List)
              .map((e) => ProductPo.fromJson(e))
              .toList();
          listSearProductpo.forEach((element) {
            element.itemDetail!.asMap().forEach((index, element2) {
              if (element.itemDetail!.isNotEmpty) {
                element2.status = element.itemDetail![0].lastStatus!;
              }
            });
          });
          listSearProductpo.forEach((element) {
            print(element.toJson());
            element.itemDetail!.asMap().forEach((index, element2) {
              print(element2.status == element2.lastStatus
                  ? "Colors.green"
                  : "Colors.red");
            });
          });

          notifyListeners();
        }
        Future.delayed(
            Duration(seconds: 1),
            () => {
                  Navigator.pop(context),
                  if (listSearProductpo.length == 0)
                    {Fluttertoast.showToast(msg: "ไม่พบเลขที่ PO นี้")}
                });
      });
    } catch (e) {
      showInfoFlushbar(
          context: context,
          title: "ข้อความจากระบบ",
          message: e.toString(),
          color: Colors.red.shade300);
      Future.delayed(Duration(seconds: 1), () => Navigator.pop(context));
    }
  }

  // ! แสกนรับ PO
  Future<void> pickPoToShop(
      {required String query,
      required BuildContext context,
      required String scan}) async {
    ControllerUser controllerUser = context.read<ControllerUser>();

    ControllerLoginScreen _controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    User _user = controllerUser.user!;
    var headers = {'Authorization': 'Bearer ${_user.token}'};
    try {
      updateStatePage(status: true);
      RequestAssistant.getRequestHttpResponse(
              headers: headers,
              url:
                  "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/RemainPoList/?dbid=${_controllerLoginScreen.getselectedItem.value}&branch=${controllerUser.gebranchList.branchCode}&date=$getnewnow&s=${query.toUpperCase()}")
          .then((response) {
        // print(response.statusCode);
        switch (response.statusCode) {
          case 200:
            updateStatePage(status: false);

            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            print(responsejson);
            List<Po> _po = (responsejson["data"] as List)
                .map((e) => Po.fromJson(e))
                .toList();
            updategetpo(p: _po, context: context);
            break;
          case 401:
            updateStatePage(status: false);
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "sesion หมดอายุ",
                color: Colors.red.shade300);
            Future.delayed(
                Duration(seconds: 2),
                () => Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.routeNameLoginScreen, (route) => false));
            break;
          case 405:
            updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "sesion หมดอายุ",
                color: Colors.red.shade300);
            Future.delayed(
                Duration(seconds: 2),
                () => Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.routeNameLoginScreen, (route) => false));
            break;
          case 500:
            updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      }).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          updateStatePage(status: false);

          return null;
        },
      );
    } catch (e) {
      updateStatePage(status: false);
      throw Exception("error $e");
    }
  }
}
