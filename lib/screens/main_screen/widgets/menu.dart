import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/get_po_screen/menu.dart';
import 'package:wms/screens/main_screen/widgets/menu_widget.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';

import '../../monitor_printer/moniter_printer.dart';
// import 'package:wms/widgets/advance_dialog.dart';

Widget menu({required BuildContext context}) {
  ControllerLoginScreen _controllerLoginScreen =
      Provider.of<ControllerLoginScreen>(context);
  ControllerUser _controllerUser = Provider.of<ControllerUser>(context);
  return Container(
    padding: EdgeInsets.zero,
    color: kmainPrimaryColor,
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text(
                //   "W M S",
                //   style: titleStyle,
                // ),
              ],
            ),
          ),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.qrcode,
              title: "เช็คสินค้า",
              press: () => Navigator.pushNamed(
                  context, RouteName.routeNameCheckProductScreen)),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.cubes,
              title: "ผูกตำแหน่งสินค้า",
              press: () => Navigator.pushNamed(
                  context, RouteName.routeNameProductPositionScreen)),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.exclamationTriangle,
              title: "แจ้งปัญหาสินค้า",
              press: () => Navigator.pushNamed(
                  context, RouteName.routeNameTranOutProductScreen)),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.cube,
              title: "รับสินค้า",
              press: () => null
              //  Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => MenuScreen(),
              //     )
              //     ),
              ),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.plusCircle,
              title: "เก็บสินค้า",
              press: () => null),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.exchangeAlt,
              title: "โอนสินค้า",
              press: () => null),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.print,
              title: "พิมพ์ป้ายสินค้า",
              press: () => null),
          // listTitleWidget(
          //     context: context,
          //     icon: FontAwesomeIcons.sitemap,
          //     title: "จัดสินค้า",
          //     press: () => null),
          listTitleWidget(
            context: context,
            icon: FontAwesomeIcons.warehouse,
            title: "ตรวจสอบสถานะเครื่องพิมพ์",
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectPrinterMoniterPrinter(),
              ),
            ),
          ),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.upload,
              title: "จัด จ่ายสินค้า",
              press: () => Navigator.pushNamed(
                  context, RouteName.routeNameTranOutProductScreen)),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.retweet,
              title: "นับสต็อคสินค้า",
              press: () => null),
          listTitleWidget(
              context: context,
              icon: FontAwesomeIcons.signOutAlt,
              title: "ออกจากระบบ",
              press: () => showDialog<void>(
                    context: context,
                    barrierDismissible: false, // user must tap button!
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                            child: Text(
                          'คุณต้องการออกจากระบบหรือไม่ ?',
                          style: TextStyle(color: black, fontSize: 15),
                        )),
                        // content: SingleChildScrollView(
                        //   child: ListBody(
                        //     children: const <Widget>[
                        //       Text('This is a demo alert dialog.'),
                        //     ],
                        //   ),
                        // ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('ยกเลิก'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text(
                              'ตกลง',
                              style: TextStyle(color: red),
                            ),
                            onPressed: () {
                              _controllerLoginScreen.fLogout(
                                  user: _controllerUser.user!.userId!,
                                  context: context);
                              // Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  )

              // showDialog(
              //   context: context,
              //   builder: (BuildContext context) {
              //     return AdvanceCustomAlert(
              //       backgroundIcon: kPrimaryColor,
              //       icon: FontAwesomeIcons.question,
              //       title: "แจ้งเตือนจากระบบ",
              //       content: "คุณต้องการออกจากระบบหรือไม่ ?",
              //       // ignore: deprecated_member_use
              //       rightButton: RaisedButton(
              //         onPressed: () => _controllerLoginScreen.fLogout(
              //             user: _controllerUser.user!.userId!, context: context),
              //         color: red,
              //         child: Text(
              //           'ตกลง',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //       // ignore: deprecated_member_use
              //       leftButton: RaisedButton(
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         },
              //         color: blue,
              //         child: Text(
              //           'ไม่',
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     );
              //   },
              // ),
              ),
        ],
      ),
    ),
  );
}

// ! เช็คการเชื่อมต่อกับเซิฟเวอร์
Future<bool> checkserver({required BuildContext context}) async {
  bool _status = false;
  try {
    await RequestAssistant.getRequestHttpResponse(url: BaseUrl.url)
        .then((response) {
      if (response.statusCode == 200) {
        print(
            "CONNECTED TO SERVER >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> WELLCOME TO PROGRAM");
        _status = true;
      }
    });
  } catch (e) {
    _status = false;
    throw Exception(e);
  }

  return _status;
}
