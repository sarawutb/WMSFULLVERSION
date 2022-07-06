import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/loadstatussvg.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Consumer<ControllerProductPositionScreen>(
      builder: (context, controllerProductPositionScreen, child) =>
          !controllerProductPositionScreen.getstatuspageGetltemLocation
              ? controllerProductPositionScreen.getltemLocation.length > 0
                  ? ReorderableListView(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      children: List.generate(
                        controllerProductPositionScreen.getltemLocation.length,
                        (index) => Slidable(
                          key: Key('Key$index'),
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: kmainPrimaryColor,
                                  child: Text('${index + 1}'),
                                  foregroundColor: Colors.white,
                                ),
                                title: Text(
                                  '${controllerProductPositionScreen.getltemLocation[index].itemName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2!
                                      .copyWith(
                                          fontSize: kdefultsize - 8,
                                          fontWeight: FontWeight.bold),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${controllerProductPositionScreen.getltemLocation[index].itemCode}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(fontSize: kdefultsize - 10),
                                    ),
                                    Text(
                                      '${controllerProductPositionScreen.getltemLocation[index].unitCode}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              fontSize: kdefultsize - 8,
                                              color: red),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          actions: <Widget>[
                            IconSlideAction(
                                caption: 'เลือกตำแหน่ง',
                                color: Colors.blue,
                                icon: Icons.archive,
                                onTap: () => showDialog<void>(
                                      context: context,
                                      barrierDismissible:
                                          true, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                              child: const Text(
                                                  'เลือกตำแหน่งจัดเก็บสินค้า')),
                                          content: SingleChildScrollView(
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: DropdownButton<int>(
                                                  hint: Text(
                                                      "เลือกที่เก็บตำแหน่งสินค้า"),
                                                  // value: providerItemLocation.select,
                                                  items: List.generate(
                                                    controllerProductPositionScreen
                                                        .getltemLocation.length,
                                                    (x) => DropdownMenuItem(
                                                      child: Container(
                                                          width:
                                                              size.width * 0.5,
                                                          child: Center(
                                                            child: Text(
                                                                "ตำแหน่งที่ ${x + 1}"),
                                                          )),
                                                      value: x,
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    controllerProductPositionScreen
                                                        .foninsert(
                                                            index, value!);
                                                    print(value);
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          ),
                                        );
                                      },
                                    )),
                          ],
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'ลบ',
                              color: Colors.red,
                              icon: Icons.delete,
                              onTap: () => showDialog<void>(
                                  context: context,
                                  barrierDismissible:
                                      true, // user must tap button!
                                  builder: (BuildContext context) {
                                    return AdvanceCustomAlert(
                                      title: "แจ้งเตือนจากระบบ",
                                      content:
                                          "คุณต้องการลบสินค้าในตำแหน่งนี้หรือไม่",
                                      // ignore: deprecated_member_use
                                      rightButton: RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          controllerProductPositionScreen
                                              .fonDelete(index);
                                        },
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
                                  }),
                              // controllerProductPositionScreen.fonDelete(index),
                            ),
                          ],
                        ),
                      ),
                      onReorder: controllerProductPositionScreen.fonReorder,
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.list_sharp,
                            size: kdefultsize,
                            color: black,
                          ),
                          Text(
                            "ไม่มีรายการสินค้าในตำแหน่งนี้",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    )
              : Column(
                  children: [
                    Expanded(child: LoadStatusSvg()),
                  ],
                ),
    );
  }
}
