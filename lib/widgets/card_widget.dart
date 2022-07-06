import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

Widget cardWidget(
    {required BuildContext context,
    double? height,
    required String title,
    required VoidCallback press}) {
  return GestureDetector(
    onTap: press,
    child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: kdefultsize, vertical: kdefultsize - 10),
      height: height ?? 60,
      width: MediaQuery.of(context).size.width,
      decoration: kBoxDecorationStyle,
      child: Text(
        "$title",
        style: Theme.of(context).textTheme.subtitle1,
      ),
    ),
  );
}
