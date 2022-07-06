import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:provider/provider.dart';

class SelectReasonScreenMain extends StatefulWidget {
  const SelectReasonScreenMain({Key? key}) : super(key: key);

  @override
  _SelectReasonScreenMainState createState() => _SelectReasonScreenMainState();
}

class _SelectReasonScreenMainState extends State<SelectReasonScreenMain> {
  @override
  void initState() {
    reason(flag: "1");
    super.initState();
  }

  List<ListItem> listReason1 = [];
  List<TextEditingController> listRemark1 = [];

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason({required String flag}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url + 'reason?db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
        url: BaseUrl.url + 'reason?db=${db.getselectedItem.value}',
      ).then((response) {
        if (response.statusCode == 200) {
          print(response.body);
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${responseJson["data"]}");
          setState(() {
            listReason1 = (responseJson["data"] as List)
                .map((e) => ListItem.fromJson(e))
                .toList();
            List.generate(listReason1.length,
                (index) => {listRemark1.add(TextEditingController(text: ""))});
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
