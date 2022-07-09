import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

AppBar appbar({required GlobalKey<ScaffoldState> key}) {
  return AppBar(
    backgroundColor: white,
    elevation: 0,
    leading: IconButton(
      icon: Icon(
        Icons.menu,
        color: kmainPrimaryColor,
      ),
      onPressed: () {
        key.currentState!.openDrawer();
      },
    ),
  );
}
