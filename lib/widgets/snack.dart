import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

void showInfoFlushbar(
    {required BuildContext context,
    required String title,
    required String message,
    required Color color,
    int time = 3}) {
  Flushbar(
    title: '$title',
    message: '$message',
    titleSize: kdefultsize - 5,
    messageSize: kdefultsize - 8,
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: color,
    ),
    leftBarIndicatorColor: Colors.blue.shade300,
    duration: Duration(seconds: time),
  )..show(context);
}
