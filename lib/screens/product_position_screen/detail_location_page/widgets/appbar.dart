import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:collection/collection.dart';

AppBar appBar({required BuildContext context, required String title}) {
  final ControllerProductPositionScreen controllerProductPositionScreen =
      context.read<ControllerProductPositionScreen>();
  // final Size size = MediaQuery.of(context).size;
  return AppBar(
    backgroundColor: white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      "$title",
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: black, fontSize: kdefultsize - 10),
    ),
    leading: IconButton(
      onPressed: () {
        // ignore: unused_local_variable
        Function eq = const ListEquality().equals;
        // // ignore: unused_local_variable
        // bool _check = true;
        // // print(
        // //     "ใหม่ ${controllerProductPositionScreen.getltemLocations.length}");
        // // print(
        // //     "เก่า ${controllerProductPositionScreen.getCheckltemLocation.length}");
        // if ((controllerProductPositionScreen.getltemLocations.length ==
        //         controllerProductPositionScreen.getCheckltemLocation.length) &&
        //     (eq(controllerProductPositionScreen.getltemLocations,
        //         controllerProductPositionScreen.getCheckltemLocation))) {
        //   controllerProductPositionScreen.fClearList();
        //   Navigator.pushNamedAndRemoveUntil(context,
        //       RouteName.routeNameProductPositionScreen, (route) => false);
        // } else {
        //   showDialog<void>(
        //       context: context,
        //       barrierDismissible: true, // user must tap button!
        //       builder: (BuildContext context) {
        //         return AdvanceCustomAlert(
        //           justifyText: true,
        //           title: "แจ้งเตือนจากระบบ",
        //           content: "คุณต้องการบันทึกการเปลี่ยนแปลงหรือไม่",
        //           // ignore: deprecated_member_use
        //           rightButton: RaisedButton(
        //             onPressed: () async {
        //               await controllerProductPositionScreen
        //                   .fPostProductPosition(
        //                       list: controllerProductPositionScreen
        //                           .getltemLocation,
        //                       controllerProductPositionScreen:
        //                           controllerProductPositionScreen,
        //                       context: context);
        //               controllerProductPositionScreen.fClearList();

        //               Navigator.pushNamedAndRemoveUntil(
        //                   context,
        //                   RouteName.routeNameProductPositionScreen,
        //                   (route) => false);
        //             },
        //             color: red,
        //             child: Text(
        //               'ตกลง',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //           ),
        //           // ignore: deprecated_member_use
        //           leftButton: RaisedButton(
        //             onPressed: () {
        //               controllerProductPositionScreen.fClearList();
        //               Navigator.pushNamedAndRemoveUntil(
        //                   context,
        //                   RouteName.routeNameProductPositionScreen,
        //                   (route) => false);
        //             },
        //             color: blue,
        //             child: Text(
        //               'ไม่',
        //               style: TextStyle(color: Colors.white),
        //             ),
        //           ),
        //         );
        //       });
        // }
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: white,
        size: 1,
      ),
    ),
    actions: [
      Container(
        color: red,
        width: MediaQuery.of(context).size.width * 0.12,
        child: IconButton(
          onPressed: () =>
              controllerProductPositionScreen.getltemLocation.length > 0
                  ? showDialog<void>(
                      context: context,
                      barrierDismissible: true, // user must tap button!
                      builder: (BuildContext context) {
                        return AdvanceCustomAlert(
                          justifyText: true,
                          title: "แจ้งเตือนจากระบบ",
                          content:
                              "คุณต้องการลบสินค้าทั้งหมดในตำแหน่งนี้หรือไม่",
                          // ignore: deprecated_member_use
                          rightButton: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              controllerProductPositionScreen.fClearList();
                            },
                            color: red,
                            child: Text(
                              'ตกลง',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          // ignore: deprecated_member_use
                          leftButton: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            color: blue,
                            child: Text(
                              'ไม่',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      })
                  : null,
          icon: FaIcon(
            FontAwesomeIcons.trashRestoreAlt,
            color: white,
            size: kdefultsize,
          ),
        ),
      ),
      Container(
        color: Colors.green,
        width: MediaQuery.of(context).size.width * 0.12,
        child: IconButton(
          onPressed: () => showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AdvanceCustomAlert(
                  title: "แจ้งเตือนจากระบบ",
                  content: "คุณต้องการบันทึกการเปลี่ยนแปลงหรือไม่",
                  // ignore: deprecated_member_use
                  rightButton: RaisedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                      await controllerProductPositionScreen
                          .fPostProductPosition(
                              list: controllerProductPositionScreen
                                  .getltemLocation,
                              controllerProductPositionScreen:
                                  controllerProductPositionScreen,
                              context: context);
                    },
                    color: red,
                    child: Text(
                      'ตกลง',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  leftButton: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: blue,
                    child: Text(
                      'ไม่',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
          icon: FaIcon(
            FontAwesomeIcons.upload,
            color: white,
            size: kdefultsize,
          ),
        ),
      ),
      Container(
        color: blue,
        width: MediaQuery.of(context).size.width * 0.12,
        child: IconButton(
          onPressed: () => Navigator.pushNamed(
              context, RouteName.routeNameAddProductToLocation),
          icon: FaIcon(
            FontAwesomeIcons.plusCircle,
            color: white,
            size: kdefultsize,
          ),
        ),
      ),
    ],
  );
}
