import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wms/controllers/controller_couting_scock_scrren.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/themes/colors.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy");
//ไม่อยู่ในช่วงนับสต๊อก
AppBar appBar(
    {required ControllerUser user,
    required BuildContext context,
    required ControllerCountingStockScreen controllerCountingStockScreen,
    required VoidCallback press}) {
  return AppBar(
    backgroundColor: white,
    title: Column(
      children: [
        Text(
          "นับสต๊อกสาขา ${user.gebranchList.branchname}",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        Text(
          "${controllerCountingStockScreen.datecount == null ? "ไม่ได้อยู่ในช่วงนับสต๊อก" : controllerCountingStockScreen.datecount!.success! ? "${dateFormat.format(controllerCountingStockScreen.datecount!.data![0].startdate!)} - ${dateFormat.format(controllerCountingStockScreen.datecount!.data![0].enddate!)}" : "ไม่ได้อยู่ในช่วงนับสต๊อก"}",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                color: red,
                fontSize: kdefultsize - 12,
              ),
        ),
      ],
    ),
    elevation: 0,
    leading: IconButton(
      onPressed: () => null,
      icon: Icon(
        Icons.arrow_back_ios_new_outlined,
        color: white,
        size: kdefultsize - 19,
      ),
    ),
    actions: [
      TextButton.icon(
          onPressed: press, icon: Icon(Icons.refresh), label: Text("รีเซต"))
    ],
  );
}
