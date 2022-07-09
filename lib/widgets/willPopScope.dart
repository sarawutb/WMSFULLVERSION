import 'package:flutter/material.dart';

WillPopScope willPopScope(
    {required Future<bool> Function()? press, required Widget child}) {
  return WillPopScope(
    onWillPop: press,
    child: child,
  );
}
