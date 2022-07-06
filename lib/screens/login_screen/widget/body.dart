import 'package:flutter/material.dart';
import 'package:wms/screens/login_screen/widget/form.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/sizedbox_height.dart';

Widget body(
    {required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController textEditingControllerUser,
    required TextEditingController textEditingControllerPassword}) {
  return Padding(
    padding: EdgeInsets.symmetric(
        horizontal: kdefultsize, vertical: kdefultsize + 20),
    child: Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
          key: formKey,
          child: ListView(
            shrinkWrap: false,
            children: [
              // sizedBoxHeight(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconapp(context: context),
                ],
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     headerText(context: context),
              //   ],
              // ),
              subText(context: context),
              sizedBoxHeight(),
              textFormUserFeildTF(
                  textEditingControllerUser: textEditingControllerUser),
              sizedBoxHeight(),
              textFormPasswordFeildTF(
                  textEditingControllerPassword: textEditingControllerPassword),
              sizedBoxHeight(),
              dropdown(),
              sizedBoxHeight(),
              buttonLogin(
                  context: context,
                  formKey: formKey,
                  textEditingControllerUser: textEditingControllerUser,
                  textEditingControllerPassword: textEditingControllerPassword),
              sizedBoxHeight(),
              versionAppText(context: context)
            ],
          ),
        ),
      ),
    ),
  );
}
