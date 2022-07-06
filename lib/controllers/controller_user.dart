import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/widgets/snack.dart';

class ControllerUser with ChangeNotifier {
  // * VARIABLE
  User? user;
  String? endPoint;
  BranchList? branchList;

  // * FUNCTION GET VARIABLE
  User get getUser => user ?? User();
  String get getendPoint => endPoint ?? "";
  BranchList get gebranchList => branchList ?? BranchList();

  initUrl({required BuildContext context}) async {
    await RequestAssistant.getRequestHttpResponse(
            url: "http://192.168.64.26/getapiurl/icapp")
        .then((response) {
      switch (response.statusCode) {
        case 200:
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(responseJson["data"]["url"]);
          endPoint = responseJson["data"]["url"];
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
  }

  // ! อัพเดทข้อมูล User
  updateUser({required User u}) {
    user = u;
    notifyListeners();
  }

  // ! อัพเดทข้อมูล BranchList
  updateBranchList({required BranchList list}) {
    print("branchList is Update");
    branchList = list;
    notifyListeners();
  }
}
