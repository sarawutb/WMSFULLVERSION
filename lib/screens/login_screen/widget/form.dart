import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wms/config/config.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/button_defualt.dart';

Widget textFormUserFeildTF(
    {required TextEditingController textEditingControllerUser}) {
  TextEditingController();
  return TextFormField(
    controller: textEditingControllerUser,
    validator: (value) => value!.isEmpty ? "กรุณากรอกรหัสพนักงาน" : null,
    decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'รหัสพนักงาน',
        hintText: 'กรุณากรอกรหัสพนักงาน'),
  );
}

Widget textFormPasswordFeildTF(
    {required TextEditingController textEditingControllerPassword}) {
  return Consumer<ControllerLoginScreen>(
    builder: (context, _controllerLoginScreen, child) => TextFormField(
      controller: textEditingControllerPassword,
      validator: (value) => value!.isEmpty ? "กรุณากรอกรหัสผ่าน" : null,
      obscureText: _controllerLoginScreen.getshowPassword,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            onPressed: () => _controllerLoginScreen.fUpdateShowPaswword(),
            icon: Icon(_controllerLoginScreen.getshowPassword
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined),
          ),
          labelText: 'รหัสผ่าน',
          hintText: 'กรุณากรอกรหัสพนักงาน'),
    ),
  );
}

Widget buttonLogin(
    {required BuildContext context,
    required GlobalKey<FormState> formKey,
    required TextEditingController textEditingControllerUser,
    required TextEditingController textEditingControllerPassword}) {
  return Consumer<ControllerLoginScreen>(
    builder: (context, _controllerLoginScreen, child) {
      return buttonDefualt(
          press: () {
            if (formKey.currentState!.validate()) {
              _controllerLoginScreen.fLogin(
                user: textEditingControllerUser.text,
                password: textEditingControllerPassword.text,
                context: context,
              );
            }
          },
          colorBtn: kmainPrimaryColor,
          colorBtnTx: white,
          check: _controllerLoginScreen.statusButton,
          titlebutton: "เข้าสู่ระบบ");
    },
  );
}

Widget headerText({required BuildContext context}) {
  return Text(
    "เข้าสู่ระบบ",
    style: Theme.of(context).textTheme.headline4,
  );
}

Widget subText({required BuildContext context}) {
  return Text(
    "ยินดีตอนรับเข้าสู่ Warehouse Management System",
    style: Theme.of(context).textTheme.bodyText1,
    textAlign: TextAlign.center,
  );
}

Widget dropdown() {
  return Consumer<ControllerLoginScreen>(
    builder: (context, _controllerLoginScreen, child) => Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: kPrimaryColor),
          borderRadius: BorderRadius.circular(10)),
      child: DropdownButton<ListItem>(
        underline: Container(),
        value: _controllerLoginScreen.getselectedItem,
        items: _controllerLoginScreen.dropdownMenuItems,
        style: TextStyle(color: white),
        isExpanded: true,
        onChanged: (item) =>
            _controllerLoginScreen.fUpdateselectedItem(item: item!),
      ),
    ),
  );
}

Widget versionAppText({required BuildContext context}) {
  return Center(
    child: Column(
      children: [
        Text(
          "Version ${InfoApp.versionApp}",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "${InfoApp.versionApp == Provider.of<ControllerLoginScreen>(context).appVersion ? '' : '*เวอร์ชั่นแอพพลิเคชั่นของคุณไม่ตรงกับระบบ*'}",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: red, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        )
      ],
    ),
  );
}

Widget iconapp({required BuildContext context}) {
  return Container(
    alignment: Alignment.center,
    height: 60,
    width: 60,
    child: Row(
      children: [
        FaIcon(
          FontAwesomeIcons.cube,
          color: kmainPrimaryColor,
          size: 45,
        ),
        // Expanded(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Homeone โฮมวัน",
        //         style: Theme.of(context).textTheme.bodyText1,
        //       ),
        //       Text(
        //         "Warehouse Management System",
        //         style: Theme.of(context).textTheme.bodyText1,
        //       ),
        //     ],
        //   ),
        // )
      ],
    ),
  );
}
