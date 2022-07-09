import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/screens/branch_screen/widget/body.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/willPopScope.dart';

class BranchScreen extends StatelessWidget {
  const BranchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ControllerUser user =
        Provider.of<ControllerUser>(context, listen: false);
    return willPopScope(
      press: () async {
        final shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdvanceCustomAlert(
                backgroundIcon: kPrimaryColor,
                icon: FontAwesomeIcons.question,
                title: "แจ้งเตือนจากระบบ",
                content: "คุณต้องการออกจากแอพพลิเคชั่นหรือไม่ ?",
                // ignore: deprecated_member_use
                rightButton: RaisedButton(
                  onPressed: () {
                    Future.delayed(Duration(seconds: 1), () => exit(0));
                  },
                  color: red,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // ignore: deprecated_member_use
                leftButton: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: blue,
                  child: Text(
                    'ไม่',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            });

        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: white,
        // appBar: appbar(context: context),
        body: body(user: user),
      ),
    );
  }
}
