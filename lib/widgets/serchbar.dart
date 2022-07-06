import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wms/themes/app_color.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(
      {Key? key,
      this.onSubmitted,
      this.onEditingComplete,
      this.controller,
      this.onChanged,
      this.title,
      this.focusNode,
      this.press,
      this.iconSize,
      this.fontSize,
      this.contentPadding,
      this.maxLines,
      this.style,
      this.preeIcon,
      this.suffixIcon,
      this.keyboardType,
      this.textAlignVertical,
      this.enabled,
      this.autovalidate = false,
      this.validator})
      : super(key: key);
  final Function(String)? onSubmitted;
  final Function()? onEditingComplete;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final String? title;
  final FocusNode? focusNode;
  final VoidCallback? press;
  final double? iconSize;
  final double? fontSize;
  final double? contentPadding;
  final int? maxLines;
  final TextStyle? style;
  final bool? preeIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextAlignVertical? textAlignVertical;
  final bool? enabled;
  final bool autovalidate;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          focusNode: focusNode,
          enabled: enabled ?? true,
          textAlignVertical: textAlignVertical ?? TextAlignVertical.bottom,
          cursorColor: AppColor.kPrimary,
          onFieldSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType ?? TextInputType.text,
          maxLines: maxLines ?? 1,
          // autovalidate: autovalidate,
          validator: validator,
          style: style ??
              Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: AppColor.kTextGrey1, fontSize: fontSize),
          decoration: InputDecoration(
            filled: true,
            isDense: true,
            fillColor: AppColor.kSerachBar,
            suffixIcon: suffixIcon ??
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black54,
                    size: iconSize,
                  ),
                  onPressed: press,
                ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(
                6,
              ),
            ),
            // ignore: prefer_const_constructors
            contentPadding: EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: contentPadding ?? 56,
            ),
            hintText: title ?? 'ค้นหา',

            hintStyle: style ??
                Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: AppColor.kTextGrey1, fontSize: fontSize),
          ),
        ),
        if (preeIcon ?? false)
          Positioned(
            top: 0,
            bottom: 0,
            left: 20,
            child: SvgPicture.asset(
              'assets/images/search.svg',
              width: iconSize,
            ),
          )
      ],
    );
  }
}
