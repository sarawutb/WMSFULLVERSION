import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/models/product_model.dart';
import 'package:wms/themes/colors.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.size,
    required this.controllerProductPositionScreen,
  }) : super(key: key);

  final Size size;
  final ControllerProductPositionScreen controllerProductPositionScreen;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: List.generate(
            controllerProductPositionScreen.getAddListProducts.length, (index) {
          List<Product> _list =
              controllerProductPositionScreen.getAddListProducts;
          return Container(
              decoration: kBoxDecorationStyle,
              margin: EdgeInsets.symmetric(vertical: kdefultsize - 15),
              width: size.width,
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: index.isEven
                          ? Colors.orangeAccent
                          : Colors.indigoAccent,
                      child: Text('${index + 1}'),
                      foregroundColor: Colors.white,
                    ),
                    title: Text(
                      '${_list[index].itemname}',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: kdefultsize - 8,
                          color: kmainPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${_list[index].itemcode}',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                          fontSize: kdefultsize - 8, color: kmainPrimaryColor),
                    ),
                  ),
                ),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'ลบ',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => controllerProductPositionScreen.fRemoveAtIndex(
                        index: index),
                  ),
                ],
              ));
        }),
      ),
    );
  }
}
