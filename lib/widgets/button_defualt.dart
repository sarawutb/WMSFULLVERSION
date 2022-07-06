import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

Widget buttonDefualt(
    {String? titlebutton,
    VoidCallback? press,
    Color? colorBtn,
    Color? colorBtnTx,
    bool? check,
    double? fontsize}) {
  return GestureDetector(
    onTap: press ?? null,
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        // color: Color(0xFFffc100),
        color: colorBtn ?? Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      height: 60.0,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${titlebutton ?? "ปุ่ม"}',
            style: TextStyle(
              color: colorBtnTx ?? Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: fontsize ?? kdefultsize - 5,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            width: check ?? false ? kdefultsize - 10 : 0,
          ),
          if (check != null)
            if (check)
              SizedBox(
                height: kdefultsize - 10,
                width: kdefultsize - 10,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
        ],
      ),
    ),
  );
}
