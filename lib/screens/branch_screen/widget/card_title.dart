import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';

Widget card({required BranchList list, required BuildContext context}) {
  final ControllerUser user =
      Provider.of<ControllerUser>(context, listen: false);
  return Container(
    decoration: kBoxDecorationStyle,
    margin: EdgeInsets.symmetric(
        horizontal: kdefultsize, vertical: kdefultsize - 16),
    child: ListTile(
        onTap: () {
          user.updateBranchList(list: list);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.routeNameMainScreen, (route) => false);
        },

        // leading: Container(
        //   padding: EdgeInsets.only(right: 12.0),
        //   decoration: new BoxDecoration(
        //       border: new Border(
        //           right: new BorderSide(width: 1.0, color: Colors.black))),
        //   child: Icon(
        //     Icons.autorenew,
        //     color: white,
        //     size: kdefultsize + 10,
        //   ),
        // ),
        title: Text(
          "สาขา ${list.branchname}",
          style: Theme.of(context).textTheme.subtitle2,
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            // Icon(Icons.linear_scale, color: kmainPrimaryColor),
            Text(
              " รหัสสาขา ${list.branchCode}",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
        trailing: Icon(Icons.keyboard_arrow_right, color: black, size: 30.0)),
  );
}
