import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/widgets/dialogbox.dart';
import 'package:wms/widgets/snack.dart';
import 'package:provider/provider.dart';

class ControllerProductToShopScreen with ChangeNotifier {
  bool statusPage = false;
  bool cancelPo = false;
  DateTime newnow = DateTime.now();
  bool get getStatusPage => statusPage;
  bool get getCancelPo => cancelPo;
  DateTime get getnewnow => newnow;

  updateStatePage({required bool status}) {
    statusPage = status;
    notifyListeners();
  }

  updatenewnow({required DateTime date}) {
    newnow = date;
    notifyListeners();
  }

  updategetCancelPo({required bool status}) {
    cancelPo = status;
    notifyListeners();
  }

  // ! แสกนรับ PO
  Future<void> pickPo(
      {required String query,
      required BuildContext context,
      required String scan}) async {
    ControllerUser controllerUser = context.read<ControllerUser>();
    ControllerProductToShopScreen _controllerProductToShopScreen =
        context.read<ControllerProductToShopScreen>();
    ControllerLoginScreen _controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    User _user = controllerUser.user!;
    var headers = {'Authorization': 'Bearer ${_user.token}'};
    try {
      _controllerProductToShopScreen.updateStatePage(status: true);
      RequestAssistant.postRequestHttpResponse(
              headers: headers,
              url:
                  "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/ReciveDate/?dbid=${_controllerLoginScreen.getselectedItem.value}&branch=${controllerUser.gebranchList.branchCode}&po=${query.trim()}&isscan=$scan")
          .then((response) {
        switch (response.statusCode) {
          case 200:
            _controllerProductToShopScreen.updateStatePage(status: false);

            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            print(responsejson);
            dialogBox(
                context: context,
                title: "ข้อความจากระบบ",
                subtitle: "${responsejson["massage"]}");
            break;
          case 401:
            _controllerProductToShopScreen.updateStatePage(status: false);

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
            _controllerProductToShopScreen.updateStatePage(status: false);

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
            _controllerProductToShopScreen.updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            _controllerProductToShopScreen.updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      }).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          _controllerProductToShopScreen.updateStatePage(status: false);

          return null;
        },
      );
    } catch (e) {
      _controllerProductToShopScreen.updateStatePage(status: false);
      throw Exception("error $e");
    }
  }

  // ! แสกนรับ PO
  Future<void> mNoRecive(
      {required String query,
      required BuildContext context,
      required String scan}) async {
    ControllerUser controllerUser = context.read<ControllerUser>();
    ControllerProductToShopScreen _controllerProductToShopScreen =
        context.read<ControllerProductToShopScreen>();
    ControllerLoginScreen _controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    User _user = controllerUser.user!;
    var headers = {'Authorization': 'Bearer ${_user.token}'};
    try {
      _controllerProductToShopScreen.updateStatePage(status: true);
      RequestAssistant.getRequestHttpResponse(
              headers: headers,
              url:
                  "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/NoRecive/?dbid=${_controllerLoginScreen.getselectedItem.value}&branch=${controllerUser.gebranchList.branchCode}&s=${query.trim()}")
          .then((response) async {
        switch (response.statusCode) {
          case 200:
            _controllerProductToShopScreen.updateStatePage(status: false);
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            if (responsejson["data"] == null) {
              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "${responsejson["massage"]}",
                  color: Colors.green.shade300);
            } else {
              await pickPo(query: query, context: context, scan: scan);
            }
            break;
          case 401:
            _controllerProductToShopScreen.updateStatePage(status: false);

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
            _controllerProductToShopScreen.updateStatePage(status: false);

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
            _controllerProductToShopScreen.updateStatePage(status: false);

            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            break;
          default:
            _controllerProductToShopScreen.updateStatePage(status: false);
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
        }
      }).timeout(
        Duration(seconds: 5),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          _controllerProductToShopScreen.updateStatePage(status: false);

          return null;
        },
      );
    } catch (e) {
      _controllerProductToShopScreen.updateStatePage(status: false);
      throw Exception("error $e");
    }
  }

  // ! ยกเลิก PO
  Future<void> cancel(
      {required String query,
      required BuildContext context,
      required String scan,
      required GlobalKey<FormState> formKey,
      required String reason}) async {
    ControllerUser controllerUser = context.read<ControllerUser>();
    ControllerProductToShopScreen _controllerProductToShopScreen =
        context.read<ControllerProductToShopScreen>();
    ControllerLoginScreen _controllerLoginScreen =
        context.read<ControllerLoginScreen>();
    User _user = controllerUser.user!;
    var headers = {'Authorization': 'Bearer ${_user.token}'};

    if (formKey.currentState!.validate()) {
      try {
        _controllerProductToShopScreen.updateStatePage(status: true);
        RequestAssistant.postRequestHttpResponse(
                headers: headers,
                url:
                    "https://localapi.homeone.co.th/erp/v1/wms/WmsPoRecive/ReciveDate/?dbid=${_controllerLoginScreen.getselectedItem.value}&branch=${controllerUser.gebranchList.branchCode}&po=${query.trim()}&iscancel=1&reason=$reason")
            .then((response) {
          switch (response.statusCode) {
            case 200:
              _controllerProductToShopScreen.updateStatePage(status: false);
              var responsejson = json.decode(utf8.decode(response.bodyBytes));
              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "${responsejson["massage"]}",
                  color: Colors.green.shade300);

              // dialogBox(
              //     context: context,
              //     title: "ข้อความจากระบบ",
              //     subtitle: "${responsejson["massage"]}");
              break;
            case 401:
              _controllerProductToShopScreen.updateStatePage(status: false);

              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "sesion หมดอายุ",
                  color: Colors.red.shade300);
              Future.delayed(
                  Duration(seconds: 2),
                  () => Navigator.pushNamedAndRemoveUntil(context,
                      RouteName.routeNameLoginScreen, (route) => false));
              break;
            case 405:
              _controllerProductToShopScreen.updateStatePage(status: false);

              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "sesion หมดอายุ",
                  color: Colors.red.shade300);
              Future.delayed(
                  Duration(seconds: 2),
                  () => Navigator.pushNamedAndRemoveUntil(context,
                      RouteName.routeNameLoginScreen, (route) => false));
              break;
            case 500:
              _controllerProductToShopScreen.updateStatePage(status: false);

              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                  color: Colors.red.shade300);
              break;
            default:
              _controllerProductToShopScreen.updateStatePage(status: false);

              showInfoFlushbar(
                  context: context,
                  title: "ข้อความจากระบบ",
                  message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                  color: Colors.red.shade300);
          }
        }).timeout(
          Duration(seconds: 5),
          onTimeout: () {
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
                color: Colors.red.shade300);
            _controllerProductToShopScreen.updateStatePage(status: false);

            return null;
          },
        );
      } catch (e) {
        _controllerProductToShopScreen.updateStatePage(status: false);
        throw Exception("error $e");
      }
    }
  }
}
