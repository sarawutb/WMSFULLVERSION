// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

AppBar createAppBarWidget(
    {required BuildContext context,
    required double height,
    required String title,
    bool? centerTitle}) {
  return AppBar(
    brightness: Brightness.light,
    backgroundColor: white,
    leading: BackButton(
      color: black,
    ),
    title: Text(
      title,
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: black, fontSize: kdefultsize - 5),
    ),
    centerTitle: centerTitle ?? true,
    elevation: 0,
  );
}
