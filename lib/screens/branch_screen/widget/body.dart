import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/screens/branch_screen/widget/card_title.dart';

Widget body({required ControllerUser user}) {
  return Center(
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: user.user!.branchList!.length,
      itemBuilder: (context, index) {
        List<BranchList>? list = user.user!.branchList!;
        return card(list: list[index], context: context);
      },
    ),
  );
}
