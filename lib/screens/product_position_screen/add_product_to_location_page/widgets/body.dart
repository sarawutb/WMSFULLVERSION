import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/screens/product_position_screen/add_product_to_location_page/widgets/list_view_product.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/loadstatussvg.dart';
import 'package:wms/widgets/text_form_search.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.textEditingControllerSearchPosition,
  }) : super(key: key);

  final TextEditingController textEditingControllerSearchPosition;

  @override
  Widget build(BuildContext context) {
    final FocusNode _node = FocusNode();
    Future.delayed(Duration(milliseconds: 300), () {
      SystemChannels.textInput.invokeListMethod('TextInput.hide');
    });
    return SafeArea(
      child: Consumer2<ControllerProductPositionScreen, ControllerCheckProduct>(
        builder: (context, controllerProductPositionScreen,
                controllerCheckProduct, child) =>
            Column(
          children: [
            TextFormFeildSearch(
                textInputAction: TextInputAction.done,
                icon: Icons.close,
                context: context,
                autoFocus: true,
                hintText: "รหัสสินค้า ชื่อสินค้า และบาร์โค้ด",
                press: () {
                  textEditingControllerSearchPosition.clear();
                  _node.requestFocus();
                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                keyboardType: TextInputType.text,
                onFieldSubmitted: (string) {
                  if (string.isNotEmpty) {
                    controllerCheckProduct.fSearch(
                        query: string, context: context);
                  }
                  textEditingControllerSearchPosition.clear();
                  _node.requestFocus();
                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                textEditingController: textEditingControllerSearchPosition),
            if (controllerCheckProduct.getStatusPage) LoadStatusSvg(),
            Expanded(
              child: Container(
                child: controllerCheckProduct.getlistProducts.length > 0
                    ? ListViewProductsSelect(
                        controllerProductPositionScreen:
                            controllerProductPositionScreen,
                        controllerCheckProduct: controllerCheckProduct,
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: kdefultsize,
                              color: black,
                            ),
                            Text(
                              "ค้นหาสินค้า",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
