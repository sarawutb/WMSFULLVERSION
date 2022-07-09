import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/willPopScope.dart';
import 'package:provider/provider.dart';
import 'widgets/body.dart';

class ProductPositionScreen extends StatefulWidget {
  const ProductPositionScreen({Key? key}) : super(key: key);

  @override
  _ProductPositionScreenState createState() => _ProductPositionScreenState();
}

class _ProductPositionScreenState extends State<ProductPositionScreen> {
  final TextEditingController textEditingControllerSearchPosition =
      TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 300),
        () => SystemChannels.textInput.invokeListMethod('TextInput.hide'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ControllerProductPositionScreen _controllerProductPositionScreen =
        context.read<ControllerProductPositionScreen>();
    return willPopScope(
        press: () async {
          _controllerProductPositionScreen.fClearListLocation();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.routeNameMainScreen, (route) => false);
          return await Future.value(false);
        },
        child: Scaffold(
          backgroundColor: white,
          body: Body(
            textEditingControllerSearchPosition:
                textEditingControllerSearchPosition,
          ),
        ));
  }
}
