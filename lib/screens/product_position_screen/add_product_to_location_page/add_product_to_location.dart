import 'package:flutter/material.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:provider/provider.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/willPopScope.dart';

import 'widgets/body.dart';

class AddProductToLocation extends StatefulWidget {
  const AddProductToLocation({Key? key}) : super(key: key);

  @override
  _AddProductToLocationState createState() => _AddProductToLocationState();
}

class _AddProductToLocationState extends State<AddProductToLocation> {
  TextEditingController textEditingControllerSearchProduct =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final ControllerProductPositionScreen controllerProductPositionScreen =
    //     context.read<ControllerProductPositionScreen>();
    // final Size size = MediaQuery.of(context).size;
    return Consumer2<ControllerProductPositionScreen, ControllerCheckProduct>(
      builder: (context, controllerProductPositionScreen,
              controllerCheckProduct, child) =>
          willPopScope(
        press: () {
          controllerCheckProduct.fClearProductList();
          controllerProductPositionScreen.fClearAddListProducts();
          return Future.value(true);
        },
        child: Scaffold(
          body: Body(
            textEditingControllerSearchPosition:
                textEditingControllerSearchProduct,
          ),
          floatingActionButton:
              controllerProductPositionScreen.getAddListProducts.length > 0
                  ? FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, RouteName.routeNameShowOrderPage);
                      },
                      child: Text(
                        "${controllerProductPositionScreen.getAddListProducts.length > 100 ? "99+" : controllerProductPositionScreen.getAddListProducts.length}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(fontSize: kdefultsize - 5, color: white),
                      ),
                      backgroundColor: blue,
                    )
                  : Container(),
        ),
      ),
    );
  }
}
