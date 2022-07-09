import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

Widget menuWidget(
    {required BuildContext context,
    IconData? icon,
    required String imagepath,
    required String title,
    required VoidCallback press}) {
  final Size _size = MediaQuery.of(context).size;
  return GestureDetector(
    onTap: press,
    child: Container(
      width: 100,
      height: 100,
      decoration: kBoxDecorationStyle,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Image.asset(
              imagepath,
              height: 80,
              width: 80,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$title",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontSize: 12, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget listTitleWidget(
    {required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback press}) {
  return ListTile(
    onTap: press,
    minLeadingWidth: kdefultsize - 10,
    leading: Icon(
      icon,
      color: white,
      size: kdefultsize,
    ),
    title: Text(
      "$title",
      textAlign: TextAlign.left,
      style: subtitleStyle,
    ),
  );
}
