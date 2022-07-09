import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/controllers/controller_check_product.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/models/product_model.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/snack.dart';

class ListViewProductsSelect extends StatelessWidget {
  const ListViewProductsSelect({
    Key? key,
    required this.controllerCheckProduct,
    required this.controllerProductPositionScreen,
  }) : super(key: key);

  final ControllerCheckProduct controllerCheckProduct;
  final ControllerProductPositionScreen controllerProductPositionScreen;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          List<Product> _list = controllerCheckProduct.getlistProducts;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: kdefultsize),
            child: Container(
              decoration: kBoxDecorationStyle,
              child: ListTile(
                onTap: () => null,
                minLeadingWidth: kdefultsize - 10,
                isThreeLine: true,
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        "${_list[index].itemname ?? "ไม่พบชื่อ"}",
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${_list[index].itemcode}",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Spacer(),
                        Text(
                          "${_list[index].unitStandardName}",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.qr_code_2, color: red),
                        Text(
                          " ${_list[index].barcode ?? "ไม่มีบาร์โค้ด"}",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Spacer(),
                        Text(
                          "${_list[index].unitStandard}",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(FontAwesomeIcons.plusCircle,
                      color: Colors.green, size: kdefultsize + 10),
                  onPressed: () {
                    // ignore: unused_local_variable
                    bool _check = true;
                    // if (controllerProductPositionScreen.getltemLocations
                    //     .any((e) => e.itemCode == _list[index].itemcode)) {
                    //   _check = false;
                    // }
                    if (controllerProductPositionScreen.getltemLocations
                            .any((e) => e.itemCode == _list[index].itemcode) ||
                        controllerProductPositionScreen.addListProducts
                            .any((e) => e.itemcode == _list[index].itemcode)) {
                      _check = false;
                    }

                    if (!_check) {
                      showInfoFlushbar(
                          context: context,
                          title: "แจ้งเตือนจากระบบ",
                          message: "สินค้านี้มีอยู่ในรายการแล้ว",
                          color: red);
                    } else {
                      controllerProductPositionScreen.addProductToList(
                          product: _list[index]);
                      controllerCheckProduct.fRemoveAtIndex(index: index);
                    }
                  },
                ),
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: kdefultsize),
              child: SizedBox(
                height: kdefultsize - 10,
              ),
            ),
        itemCount: controllerCheckProduct.getlistProducts.length);
  }
}
