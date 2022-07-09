import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/themes/colors.dart';

class TextFormFeildSearch extends StatelessWidget {
  const TextFormFeildSearch({
    Key? key,
    required this.context,
    required this.press,
    required this.keyboardType,
    required this.onFieldSubmitted,
    required this.textEditingController,
    required this.hintText,
    required this.autoFocus,
    this.textInputFormatter,
    this.textInputAction,
    this.icon,
    this.size,
    this.isMagin,
    this.node,
    this.disable,
    this.colorfont,
  }) : super(key: key);
  final BuildContext context;
  final VoidCallback press;
  final TextInputType keyboardType;
  final Function(String)? onFieldSubmitted;
  final TextEditingController textEditingController;
  final String hintText;
  final bool autoFocus;

  final TextInputFormatter? textInputFormatter;
  final TextInputAction? textInputAction;
  final IconData? icon;
  final Size? size;
  final double? isMagin;
  final FocusNode? node;
  final bool? disable;
  final Color? colorfont;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: isMagin ?? kdefultsize, vertical: kdefultsize - 10),
      height: size == null ? 60 : size!.height * 0.08,
      decoration: kBoxDecorationStyleSearch,
      child: TextFormField(
        enabled: disable,
        controller: textEditingController,
        onFieldSubmitted: onFieldSubmitted,
        cursorColor: kmainPrimaryColor,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: [
          textInputFormatter ?? FilteringTextInputFormatter.allow(RegExp(r'.*'))
        ],
        autofocus: autoFocus,
        focusNode: node,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontSize: kdefultsize - 5, color: colorfont ?? black),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: "$hintText",
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(fontSize: kdefultsize - 5, color: colorfont ?? black),
          suffixIcon: IconButton(
            onPressed: press,
            icon: Icon(
              icon ?? FontAwesomeIcons.search,
              color: kmainPrimaryColor,
            ),
          ),
          contentPadding: EdgeInsets.only(
              left: kdefultsize, bottom: 11, top: 11, right: kdefultsize),
        ),
      ),
    );
  }
}

class UpperCaseTextFormatter implements TextInputFormatter {
  const UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toUpperCase(), selection: newValue.selection);
  }
}
