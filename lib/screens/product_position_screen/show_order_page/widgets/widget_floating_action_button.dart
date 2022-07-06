import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/routes/routes.dart';

class WidgetFloatingActionButton extends StatelessWidget {
  const WidgetFloatingActionButton({
    Key? key,
    required this.controllerProductPositionScreen,
    required this.controllerCheckProduct,
  }) : super(key: key);
  final ControllerProductPositionScreen controllerProductPositionScreen;
  final ControllerCheckProduct controllerCheckProduct;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        controllerCheckProduct.fClearProductList();
        controllerProductPositionScreen.fInsertToListgetltemLocation(
            item: controllerProductPositionScreen.addListProducts,
            locationName: controllerProductPositionScreen.kGetLocationname);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.routeNameDetailLocationPage, (route) => false);
      },
      child: Icon(Icons.download),
      backgroundColor: Colors.green,
    );
  }
}
