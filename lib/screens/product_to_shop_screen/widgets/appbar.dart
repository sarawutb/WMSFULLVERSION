import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

AppBar appBar({required BuildContext context}) {
  return AppBar(
    elevation: 0,
    backgroundColor: white,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: kmainPrimaryColor,
      ),
    ),
    title: Text(
      "บันทึกวันที่สินค้าถึงร้าน",
      style: Theme.of(context).textTheme.subtitle2,
    ),
    centerTitle: true,
  );
}
