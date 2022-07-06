import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:wms/widgets/snack.dart';

class ControllerLoginScreen with ChangeNotifier {
  List<DropdownMenuItem<ListItem>> dropdownMenuItems = [];
  ListItem? _selectedItem;
  String appVersion = '';
  List<ListItem> _dropdownItems = [
    ListItem(value: "0", name: "UBON1 ศิริมหาชัย (โฮมวัน)"),
    ListItem(value: "6", name: "TRADING บริษัท ศิริมหาชัย เทรดดิ้ง จำกัด"),
    ListItem(value: "1", name: "PGL บริษัท พีจีเอล เทรดดิ้ง จำกัด"),
    ListItem(value: "2", name: "KCV บริษัท เคซีวี จำกัด"),

    // ListItem(value: "0", name: "UBON1 (บริษัท ศิริมหาชัย อุบลราชธานี จำกัด)"),
    // ListItem("1", "KCV (บริษัท เคซีวี จำกัด)"),
    // ListItem("2", "pgl (บริษัท พีจีแอล เทรดดิ้ง จำกัด)"),
    // ListItem("3", "PGLX1 (PGLX CO,LTD)"),
    // ListItem("4", "UBONTEST (บริษัท ศิริมหาชัย อุบลราชธานี จำกัด)"),
  ];

  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = [];
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kdefultsize - 10),
            child: Text(
              listItem.name!,
              style: TextStyle(
                fontSize: kdefultsize - 8,
                color: kPrimaryColor,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          value: listItem,
        ),
      );
    }
    return items;
  }

  bool statusButton = false, showPassword = true;

  bool get getstatusButton => statusButton;
  bool get getshowPassword => showPassword;
  ListItem get getselectedItem => _selectedItem ?? _dropdownItems[0];

  initstateDropItem() {
    dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
  }

  // * ~ เข้าสู่ระบบ
  fLogin(
      {required String user,
      required String password,
      required BuildContext context}) async {
    statusButton = true;
    notifyListeners();
    String _url = context.read<ControllerUser>().getendPoint;
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {'userid': '$user', 'password': '$password'};
    try {
      await RequestAssistant.postRequestHttpResponse(
              url: _url +
                  "/user/login?dbid=${getselectedItem.value}&app_name=wms",
              body: body,
              headers: headers)
          .then((response) async {
        switch (response.statusCode) {
          case 200:
            var responsejson = json.decode(utf8.decode(response.bodyBytes));
            User user = User.fromJson(responsejson["data"]);
            print(">>>>>>>>>>>>>>>>>>>>>USER<<<<<<<<<<<<<<<<<<<<<");
            print(user.toJson());
            context.read<ControllerUser>().updateUser(u: user);
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ยินดีตอนรับคุณ ${user.fullName}",
                color: Colors.green.shade300);
            statusButton = false;
            if (user.branchList!.length > 1) {
              // await FirebaseMessaging.instance.unsubscribeFromTopic('');
              await FirebaseMessaging.instance
                  .subscribeToTopic('${_user.user!.userId}')
                  .then((value) => print("subcript"));
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.routeNameBranchScreen, (route) => false);
            } else {
              _user.updateBranchList(list: user.branchList![0]);
              // await FirebaseMessaging.instance.deleteToken();
              await FirebaseMessaging.instance
                  .subscribeToTopic('${_user.user!.userId}')
                  .then((value) => print("subcript"));
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteName.routeNameMainScreen, (route) => false);
            }
            break;
          case 401:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
                color: Colors.red.shade300);
            statusButton = false;
            break;
          case 500:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้",
                color: Colors.red.shade300);
            statusButton = false;
            break;
          default:
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "มีข้อผิดพลาดไม่ทราบสาเหตุ",
                color: Colors.red.shade300);
            statusButton = false;
        }
      }).timeout(
        Duration(seconds: 25),
        onTimeout: () {
          showInfoFlushbar(
              context: context,
              title: "ข้อความจากระบบ",
              message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
              color: Colors.red.shade300);
          statusButton = false;
          return null;
        },
      );
      notifyListeners();
    } finally {
      statusButton = false;
      notifyListeners();
    }
  }

  fLogout({required String user, required BuildContext context}) async {
    String _url = context.read<ControllerUser>().getendPoint;
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var body = {'userid': '$user'};
    await RequestAssistant.postRequestHttpResponse(
            url: _url + "/user/logout", body: body, headers: headers)
        .then((response) async {
      switch (response.statusCode) {
        case 200:
          var responsejson = json.decode(utf8.decode(response.bodyBytes));
          if (responsejson["success"]) {
            await FirebaseMessaging.instance
                .unsubscribeFromTopic(user)
                .then((value) => print("unsubscribeFromTopic $user"));
            showInfoFlushbar(
                context: context,
                title: "ข้อความจากระบบ",
                message: "ออกจากระบบ",
                color: Colors.green.shade300);
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.routeNameLoginScreen, (route) => false);
          }

          break;
        // case 401:
        //   showInfoFlushbar(
        //       context: context,
        //       title: "ข้อความจากระบบ",
        //       message: "ชื่อผู่ใช้หรือรหัสผ่านไม่ถูกต้อง",
        //       color: Colors.red.shade300);
        //   break;
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
      Duration(seconds: 5),
      onTimeout: () {
        showInfoFlushbar(
            context: context,
            title: "ข้อความจากระบบ",
            message: "กรุณาเชื่อมต่อเน็ตเวิร์คภายใน",
            color: Colors.red.shade300);
        return null;
      },
    );
    notifyListeners();
  }

  // * ~ แสดงรหัสผ่านใน TextFormFeild

  fUpdateShowPaswword() {
    showPassword = !showPassword;
    notifyListeners();
  }

  // * ~ อัพเดทบริษัที่เลือก

  fUpdateselectedItem({required ListItem item}) {
    _selectedItem = item;
    notifyListeners();
  }

  void getCurrentVersion() async {
    var response = await RequestAssistant.getRequestHttpResponse(
        url: "https://api-wms.homeone.co.th/appversion");
    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      appVersion = responseJson['data'].toString();
      print("APP VERISON");
    }
  }
}
