import 'package:flutter/material.dart';

//color text and button
Color black = const Color(0xFF353B48);
Color lightBlack = const Color(0xFF596379);
Color red = const Color(0xFFF15B40);
Color white = const Color(0xFFFFFFFF);
Color lightGray = const Color(0xFFD1D5DD);
Color blue = const Color(0xFF046FDB);
Color gray = const Color(0xFF8395A7);
Color btnFb = const Color(0xFF3B5998);
Color btnGp = const Color(0xFFDD4B39);
Color pink = const Color(0xFFFE4365);

// color border text field
Color lightBlue = const Color(0xFFDFEFFE);

//color background
Color colorBg = const Color(0xFFF2F2F2);
Color colorDivider = const Color(0xFFEFF0F3);

//color header calendar
Color headerCalendar = const Color(0xFFF7F8FA);

//color label
Color labelOne = const Color(0xFFFDC066);
Color labelTwo = const Color(0xFFF15B40);
Color labelThree = const Color(0xFF3B5998);
Color labelFour = const Color(0xFF7ED321);
Color labelFive = const Color(0xFF24DCB3);

//color background popup menu
Color bgPopup = const Color(0xFFDADADA);

//color unRate
Color unRate = const Color(0xFFF1F1F1);
// * FontSizeApp

const double kFontPageTitles = 30.00;
const double kFontParagraphText = 28.00;
const double kFontListTitle = 28.00;
const double kFontListItem = 32.00;
const double kFontSecondary = 28.00;
const double kFontButtons = 28.00;
const double kFontTextInput = 32.00;

// size height width screen padding margin
const double kdefultsize = 20.00;

const kTileHeight = 50.0;
const inProgressColor = Colors.black87;
const todoColor = Color(0xffd1d2d7);

// color primary app
Color kPrimaryColor = Color(0xFF472d6c);
Color kTextPrimaryColor = Color(0xFF457B9D);
Color kDisabledPrimaryColor = Color(0xFFA8DADC);
Color kPrimaryLightColor = Color(0xFFA8DADC);
Color kBackgroundColor = Color(0xFFF5F5F8);
Color kFontTitleColor = Color(0xFFff6633);
Color kBranchSelectColor = Color(0xFFEF476F);

Color kmainPrimaryColor = Color(0xFF464b5f);
Color kmainSecondColor = Color(0xFFebf0f3);

TextStyle titleStyle = TextStyle(
    fontSize: kdefultsize - 5,
    fontWeight: FontWeight.bold,
    color: Colors.white);
TextStyle subtitleStyle = TextStyle(
    fontSize: kdefultsize - 8,
    fontWeight: FontWeight.normal,
    color: Colors.white);

final kHintTextStyle =
    TextStyle(color: kPrimaryColor.withOpacity(0.5), fontSize: kdefultsize - 5);

final kLabelStyle = TextStyle(
    color: kPrimaryColor,
    fontWeight: FontWeight.bold,
    fontSize: kdefultsize - 10);

final kBoxDecorationStyle = BoxDecoration(
  // color: Color(0xFFffc100),
  color: white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

final kBoxDecorationStyleSearch = BoxDecoration(
  color: kmainPrimaryColor.withOpacity(0.2),
  borderRadius: BorderRadius.circular(10.0),
);

final kInputDecorationStyle = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
);

String? validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

OutlineInputBorder outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
  borderRadius: BorderRadius.circular(kdefultsize),
);

TextStyle hintStyle =
    TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor);
