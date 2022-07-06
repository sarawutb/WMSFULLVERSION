import 'package:flutter/material.dart';
import 'package:wms/screens/product_to_shop_screen/product_to_shop_screen.dart';
import 'package:wms/themes/colors.dart';

import '../screens/getPoToShopScreen/getPoToShopScreen.dart';
import '../screens/get_po_screen/get_po_screen.dart';

class ShowDialogSelectMenu extends StatelessWidget {
  const ShowDialogSelectMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => GetPoToShopScreen()),
                      (route) => false);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  height: 40,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Text(
                          "1",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "บันทึกวันที่สินค้าถึงร้าน",
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => GetPoScreen()),
                      (route) => false);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(6.0)),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(6.0)),
                        child: Text(
                          "2",
                          style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "บันทึกรับสินค้าเข้าระบบ",
                        style: TextStyle(color: white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
