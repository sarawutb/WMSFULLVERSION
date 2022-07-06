import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/screens/main_screen/widgets/body.dart';
import 'package:wms/screens/main_screen/widgets/menu.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/willPopScope.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
    GlobalKey<SliderMenuContainerState> _keydrawer =
        new GlobalKey<SliderMenuContainerState>();
    final ControllerUser user =
        Provider.of<ControllerUser>(context, listen: false);
    final Size size = MediaQuery.of(context).size;
    ControllerLoginScreen _controllerLoginScreen =
        Provider.of<ControllerLoginScreen>(context);
    return willPopScope(
      press: () async {
        final shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdvanceCustomAlert(
                backgroundIcon: kPrimaryColor,
                icon: FontAwesomeIcons.question,
                title: "แจ้งเตือนจากระบบ",
                content: "คุณต้องการออกจากระบบหรือไม่ ?",
                // ignore: deprecated_member_use
                rightButton: RaisedButton(
                  onPressed: () => _controllerLoginScreen.fLogout(
                      user: user.user!.userId!, context: context),
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
        key: _keydrawer,
        backgroundColor: white,
        // appBar: appbar(key: _key),
        body: SliderMenuContainer(
          appBarColor: white,
          drawerIcon: Icon(
            Icons.abc,
            size: 0,
          ),
          key: _key,
          title: Text(""),
          sliderMenuOpenSize: 200,
          sliderMenu: true ? SizedBox() : menu(context: context),
          sliderMain: body(context: context, size: size, user: user),
        ),
      ),
    );
  }
}
