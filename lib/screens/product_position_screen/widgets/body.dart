import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_product_position_screen.dart';
import 'package:wms/screens/product_position_screen/detail_location_page/detail_location_page.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/loadstatussvg.dart';
import 'package:wms/widgets/sizedbox_height.dart';
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

    return SafeArea(
      child: Consumer<ControllerProductPositionScreen>(
        builder: (context, controllerProductPositionScreen, child) => Column(
          children: [
            TextFormFeildSearch(
                context: context,
                autoFocus: true,
                node: _node,
                hintText: "ตำแหน่งจัดเก็บสินค้า",
                press: () {
                  if (textEditingControllerSearchPosition.text.isNotEmpty) {
                    controllerProductPositionScreen.fSearchProductPosition(
                        query: textEditingControllerSearchPosition.text.trim(),
                        controllerProductPositionScreen:
                            controllerProductPositionScreen,
                        context: context);
                  }
                  textEditingControllerSearchPosition.clear();
                  _node.requestFocus();

                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                keyboardType: TextInputType.text,
                onFieldSubmitted: (string) {
                  if (string.isNotEmpty) {
                    controllerProductPositionScreen.fSearchProductPosition(
                        query: string.trim(),
                        controllerProductPositionScreen:
                            controllerProductPositionScreen,
                        context: context);
                  }
                  textEditingControllerSearchPosition.clear();

                  _node.requestFocus();

                  Future.delayed(Duration(milliseconds: 300), () {
                    SystemChannels.textInput.invokeListMethod('TextInput.hide');
                  });
                },
                textEditingController: textEditingControllerSearchPosition),
            sizedBoxHeight(),
            if (controllerProductPositionScreen.getstatuspage) LoadStatusSvg(),
            if (controllerProductPositionScreen.getstatuspage) sizedBoxHeight(),
            Expanded(
              child: controllerProductPositionScreen.getlistLocation.length > 0
                  ? ListView.builder(
                      itemCount: controllerProductPositionScreen
                          .getlistLocation.length,
                      itemBuilder: (context, index) {
                        List<String> _list =
                            controllerProductPositionScreen.getlistLocation;
                        return Container(
                          decoration: kBoxDecorationStyle,
                          margin: EdgeInsets.symmetric(
                              horizontal: kdefultsize,
                              vertical: kdefultsize - 15),
                          child: ListTile(
                            onTap: () {
                              controllerProductPositionScreen
                                  .updateLocationName(location: _list[index]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DetailLocationPage()));
                            },
                            title: Text(
                              "${_list[index]}",
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                          ),
                        );
                      },
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
                            "ค้นหาตำแหน่งจัดเก็บสินค้า",
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
