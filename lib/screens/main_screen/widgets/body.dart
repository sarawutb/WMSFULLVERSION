import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/get_po_screen/menu.dart';
import 'package:wms/screens/main_screen/widgets/menu_widget.dart';
import 'package:wms/screens/monitor_printer/moniter_printer.dart';
import 'package:wms/screens/test_printer/print_page.dart';
import 'package:wms/screens/test_printer/test_printer.dart';
import 'package:wms/screens/tran_out_product_screen/create_barcode_screen/select_printer.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/showDialogSelectMenu.dart';

import '../../get_po_screen/get_po_screen.dart';

Widget body(
    {required Size size,
    required BuildContext context,
    required ControllerUser user}) {
  final ControllerLoginScreen controllerLoginScreen =
      Provider.of<ControllerLoginScreen>(context, listen: false);
  // final ControllerOfflineScreen controllerOfflineScreen =
  //     Provider.of<ControllerOfflineScreen>(context, listen: false);

  return Column(
    children: [
      Container(
        height: size.height * 0.2,
        width: size.width,
        alignment: Alignment.center,
        color: white,
        child: Column(
          children: [
            Text(
              "${user.getUser.fullName}",
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              "${user.getUser.userGroupName}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              "${controllerLoginScreen.getselectedItem.name}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
            Text(
              "สาขา ${user.gebranchList.branchname}",
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
      Expanded(
        flex: 3,
        child: Container(
          width: size.width,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.horizontal,
              alignment: WrapAlignment.start,
              runSpacing: kdefultsize - 10,
              spacing: kdefultsize - 10,
              verticalDirection: VerticalDirection.down,
              children: [
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_16.gif',
                //     icon: FontAwesomeIcons.qrcode,
                //     title: "เช็คสินค้า",
                //     press: () => Navigator.pushNamed(
                //         context, RouteName.routeNameCheckProductScreen)),
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_06.gif',
                //     icon: FontAwesomeIcons.cubes,
                //     title: "ผูกตำแหน่ง\nสินค้า",
                //     press: () => Navigator.pushNamed(
                //         context, RouteName.routeNameProductPositionScreen)),
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_01.gif',
                //     icon: FontAwesomeIcons.exclamationTriangle,
                //     title: "แจ้งปัญหา\nสินค้า",
                //     press: () => Navigator.pushNamed(
                //         context, RouteName.routeNameReportStatusScreen)),
                menuWidget(
                    context: context,
                    imagepath: 'assets/icons/wmsicons/17837_15.gif',
                    icon: FontAwesomeIcons.cube,
                    title: "รับสินค้า",
                    // press: () => Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => MenuScreen(),
                    //   ),
                    // ),
                    // press: () => showDialog(
                    //     context: context,
                    //     builder: (_) => ShowDialogSelectMenu())
                    press: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => GetPoScreen()));
                    }),
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_14.gif',
                //     icon: FontAwesomeIcons.plusCircle,
                //     title: "เก็บสินค้า",
                //     press: () => Navigator.pushNamed(
                //         context, RouteName.routeNameProductStoreScreen)),
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_12.gif',
                //     icon: FontAwesomeIcons.exchangeAlt,
                //     title: "โอนสินค้า",
                //     press: () => Navigator.pushNamed(
                //         context, RouteName.routeNameTranProductScreen)),
                // menuWidget(
                //   context: context,
                //   imagepath: 'assets/icons/wmsicons/17837_03.gif',
                //   icon: FontAwesomeIcons.print,
                //   title: "พิมพ์ป้าย\nสินค้า",
                //   press: () => null,
                //   // press: () => Navigator.pushNamed(
                //   //     context, RouteName.routeNamePrintPostProductScreen)
                // ),
                menuWidget(
                    context: context,
                    imagepath: 'assets/icons/wmsicons/17837_11.gif',
                    icon: FontAwesomeIcons.upload,
                    title: "จัด\nจ่ายสินค้า",
                    press: ()

                        // {
                        //   showAlertDialog(context,
                        //       text:
                        //           "ไม่สามารถเชื่อต่อกับเซิฟเวอร์ได้\nกรุณาติดต่อเจ้าหน้าที่พัฒนาระบบ");
                        // }

                        async =>
                        await checkserver(context: context)
                            ? Navigator.pushNamed(context,
                                RouteName.routeNameTranOutProductScreen)
                            : showAlertDialog(context,
                                text:
                                    "ไม่สามารถเชื่อต่อกับเซิฟเวอร์ได้\nกรุณาติดต่อเจ้าหน้าที่พัฒนาระบบ")),
                // menuWidget(
                //     context: context,
                //     imagepath: 'assets/icons/wmsicons/17837_04.gif',
                //     icon: FontAwesomeIcons.retweet,
                //     title: "นับสต็อค\nสินค้า",
                //     // press: () => Navigator.pushNamed(
                //     //     context, RouteName.routeNameCountingStokScreen)
                //     press: () =>
                //         Fluttertoast.showToast(msg: "อยู่ระหว่างพัฒนา")),
                menuWidget(
                    context: context,
                    imagepath: 'assets/icons/wmsicons/printer.png',
                    icon: FontAwesomeIcons.sitemap,
                    title: "ตรวจสอบสถานะเครื่องพิมพ์",
                    press: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SelectPrinterMoniterPrinter()))),
              ],
            ),
          ),
        ),
      )
    ],
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

showAlertDialog(BuildContext context, {required String text}) {
  AlertDialog alert = AlertDialog(
    content: new Row(
      children: [
        Container(margin: EdgeInsets.only(left: 5), child: Text("$text")),
      ],
    ),
  );
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
