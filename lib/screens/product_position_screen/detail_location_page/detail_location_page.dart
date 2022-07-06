import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:collection/collection.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';
import 'package:provider/provider.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/willPopScope.dart';

import 'widgets/appbar.dart';
import 'widgets/body.dart';

class DetailLocationPage extends StatefulWidget {
  const DetailLocationPage({
    Key? key,
  }) : super(key: key);

  @override
  _DetailLocationPageState createState() => _DetailLocationPageState();
}

class _DetailLocationPageState extends State<DetailLocationPage> {
  @override
  void initState() {
    context.read<ControllerProductPositionScreen>().fdetailproductposition(
        query: context.read<ControllerProductPositionScreen>().kGetLocationname,
        context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ControllerProductPositionScreen controllerProductPositionScreen =
        context.read<ControllerProductPositionScreen>();
    final Size size = MediaQuery.of(context).size;
    return willPopScope(
      press: () async {
        Function eq = const ListEquality().equals;
        // ignore: unused_local_variable
        bool _check = true;
        // print(
        //     "ใหม่ ${controllerProductPositionScreen.getltemLocations.length}");
        // print(
        //     "เก่า ${controllerProductPositionScreen.getCheckltemLocation.length}");
        if ((controllerProductPositionScreen.getltemLocations.length ==
                controllerProductPositionScreen.getCheckltemLocation.length) &&
            (eq(controllerProductPositionScreen.getltemLocations,
                controllerProductPositionScreen.getCheckltemLocation))) {
          controllerProductPositionScreen.fClearList();
          Navigator.pushNamedAndRemoveUntil(context,
              RouteName.routeNameProductPositionScreen, (route) => false);
        } else {
          showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AdvanceCustomAlert(
                  justifyText: true,
                  title: "แจ้งเตือนจากระบบ",
                  content: "คุณต้องการบันทึกการเปลี่ยนแปลงหรือไม่",
                  // ignore: deprecated_member_use
                  rightButton: RaisedButton(
                    onPressed: () async {
                      // await controllerProductPositionScreen
                      //     .fPostProductPosition(
                      //         list: controllerProductPositionScreen
                      //             .getltemLocation,
                      //         controllerProductPositionScreen:
                      //             controllerProductPositionScreen,
                      //         context: context);
                      // controllerProductPositionScreen.fClearList();
                      Navigator.pop(context);
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context,
                      //     RouteName.routeNameProductPositionScreen,
                      //     (route) => false);
                    },
                    color: red,
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  leftButton: RaisedButton(
                    onPressed: () {
                      controllerProductPositionScreen.fClearList();
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouteName.routeNameProductPositionScreen,
                          (route) => false);
                    },
                    color: blue,
                    child: Text(
                      'ออก',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              });
        }

        return await Future.value(false);
      },
      child: Scaffold(
        appBar: appBar(
            context: context,
            title: "${controllerProductPositionScreen.kGetLocationname} "),
        backgroundColor: white,
        body: Body(size: size),
      ),
    );
  }
}
