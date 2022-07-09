import 'package:flutter/material.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/main_screen/main_screen.dart';
import 'package:wms/themes/colors.dart';

import 'get_po_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final TextStyle _styleText = Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(fontSize: 12, color: black);

    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => MainScreen()), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (route) => false),
            icon: Icon(
              Icons.arrow_back_outlined,
              size: kdefultsize,
              color: black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text("รับสินค้า"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kdefultsize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  // Navigator.pushNamed(
                  //     context, RouteName.routeNameProductToShopScreen);
                },
                child: Text(
                  "1.บันทึกวันที่สินค้าถึงร้าน",
                  style: _styleText.copyWith(color: black),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GetPoScreen()));
                },
                child: Text(
                  "2.บันทึกรับสินค้าเข้าระบบ",
                  style: _styleText.copyWith(color: black),
                ),
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: SizedBox(
              //         height: 50,
              //         child: ElevatedButton(
              //           // style: ButtonStyle(
              //           //   backgroundColor:
              //           //       MaterialStateProperty.all(black.withOpacity(0.8)),
              //           //   elevation: MaterialStateProperty.all(0),
              //           //   shape:
              //           //       MaterialStateProperty.all<RoundedRectangleBorder>(
              //           //     RoundedRectangleBorder(
              //           //       borderRadius: BorderRadius.circular(10),
              //           //       side: BorderSide(color: Colors.red, width: 2),
              //           //     ),
              //           //   ),
              //           // ),
              //           onPressed: () {
              //             Navigator.pushNamed(
              //                 context, RouteName.routeNameProductToShopScreen);
              //           },
              //           child: Text(
              //             "1.บันทึกวันที่สินค้าถึงร้าน",
              //             style: _styleText.copyWith(color: black),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: SizedBox(
              //         height: 50,
              //         child: ElevatedButton(
              //           style: ButtonStyle(
              //             backgroundColor:
              //                 MaterialStateProperty.all(black.withOpacity(0.8)),
              //             elevation: MaterialStateProperty.all(0),
              //             shape:
              //                 MaterialStateProperty.all<RoundedRectangleBorder>(
              //               RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(10),
              //                 side: BorderSide(color: Colors.red, width: 2),
              //               ),
              //             ),
              //           ),
              //           onPressed: () {
              //             Navigator.push(context,
              //                 MaterialPageRoute(builder: (_) => GetPoScreen()));
              //           },
              //           child: Text(
              //             "2.บันทึกรับสินค้าเข้าระบบ",
              //             style: _styleText.copyWith(color: white),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // Row(
              //   children: [
              //     Expanded(
              //       child: ElevatedButton(
              //         style: ButtonStyle(
              //           backgroundColor: MaterialStateProperty.all(Colors.white),
              //           elevation: MaterialStateProperty.all(0),
              //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //               borderRadius: BorderRadius.zero,
              //               side: BorderSide(color: Colors.red),
              //             ),
              //           ),
              //         ),
              //         onPressed: () {
              //           Navigator.push(context,
              //               MaterialPageRoute(builder: (_) => GetPoScreen()));
              //         },
              //         child: Text(
              //           "2.บันทึกรับสินค้าเข้าระบบ",
              //           style: _styleText,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
