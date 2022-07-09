import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/themes/colors.dart';

AppBar appbar(BuildContext context,
    ControllerProductPositionScreen controllerProductPositionScreen) {
  return AppBar(
    elevation: 0,
    backgroundColor: white,
    leading: IconButton(
      icon: Icon(
        Icons.arrow_back_ios_new,
        size: kdefultsize,
        color: kmainPrimaryColor,
      ),
      onPressed: () => Navigator.pop(context),
    ),
    title: Text(
      "รายการที่เลือก ${controllerProductPositionScreen.getAddListProducts.length} รายการ",
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(fontSize: kdefultsize - 8, color: kmainPrimaryColor),
    ),
  );
}
