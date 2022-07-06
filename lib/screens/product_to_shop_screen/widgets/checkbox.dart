import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_product_to_shop_screen.dart';
import 'package:wms/themes/colors.dart';

Padding checkBoxMethod(BuildContext context,
    ControllerProductToShopScreen controllerProductToShopScreen) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: kdefultsize - 20),
    child: Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: controllerProductToShopScreen.getCancelPo,
            activeColor: kmainPrimaryColor,
            onChanged: (status) {
              controllerProductToShopScreen.updategetCancelPo(status: status!);
            },
          ),
          Text(
            "ขอยกเลิกบันทึกวันที่สินค้าถึงร้าน",
            style: Theme.of(context).textTheme.bodyText2,
          )
        ],
      ),
    ),
  );
}
