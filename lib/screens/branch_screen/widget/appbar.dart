import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

AppBar appbar({required BuildContext context}) {
  return AppBar(
    backgroundColor: white,
    centerTitle: true,
    elevation: 0,
    title: Text(
      "เลือกสาขา",
      style: Theme.of(context).textTheme.headline6,
    ),
  );
}
