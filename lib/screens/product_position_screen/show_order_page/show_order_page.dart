import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/themes/colors.dart';
import 'package:provider/provider.dart';

import 'widgets/appbar.dart';
import 'widgets/body.dart';
import 'widgets/widget_floating_action_button.dart';

class ShowOrderPage extends StatefulWidget {
  const ShowOrderPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowOrderPageState createState() => _ShowOrderPageState();
}

class _ShowOrderPageState extends State<ShowOrderPage> {
  @override
  Widget build(BuildContext context) {
    // final ControllerProductPositionScreen controllerProductPositionScreen =
    //     context.read<ControllerProductPositionScreen>();
    final ControllerCheckProduct _controllerCheckProduct =
        context.read<ControllerCheckProduct>();
    Size size = MediaQuery.of(context).size;
    return Consumer<ControllerProductPositionScreen>(
      builder: (context, controllerProductPositionScreen, child) => Scaffold(
        backgroundColor: white,
        appBar: appbar(context, controllerProductPositionScreen),
        body: Body(
            size: size,
            controllerProductPositionScreen: controllerProductPositionScreen),
        floatingActionButton: WidgetFloatingActionButton(
          controllerProductPositionScreen: controllerProductPositionScreen,
          controllerCheckProduct: _controllerCheckProduct,
        ),
      ),
    );
  }
}
