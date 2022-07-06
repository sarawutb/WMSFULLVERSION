import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/models/listItem_model.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';

class SelectReasonScreen extends StatefulWidget {
  const SelectReasonScreen(
      {Key? key,
      required this.index1,
      required this.index2,
      required this.linenumber,
      required this.head})
      : super(key: key);
  final int index1, index2;
  final int linenumber;
  final Head head;
  @override
  _SelectReasonScreenState createState() => _SelectReasonScreenState();
}

class _SelectReasonScreenState extends State<SelectReasonScreen> {
  bool statusPage = false;
  List<ListItem> _list = [];
  List<TextEditingController> _listRemarks = [];
  @override
  void initState() {
    reason();
    super.initState();
  }

  // ! เหตุผลที่จัดสินค้าไม่ครบ
  Future<void> reason() async {
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
            _list = (responseJson["data"] as List)
                .map((e) => ListItem.fromJson(e))
                .toList();
            List.generate(_list.length,
                (index) => {_listRemarks.add(TextEditingController(text: ""))});
          });
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {
      setState(() {
        statusPage = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: 10,
            );
    return Consumer<ControllerTranOutProduct>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: Icon(
              Icons.arrow_back_outlined,
              size: kdefultsize,
              color: white,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "ระบุสาเหตุที่จัดสินค้าได้ครบ",
            style: TextStyle(color: white),
          ),
          backgroundColor: Colors.green[700],
        ),
        body: statusPage
            ? _list.isNotEmpty
                ? ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (c, index) => ListTile(
                      title: Text(
                        _list[index].name ?? '',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      subtitle: TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: "หมายเหตุ",
                        ),
                        style: _textStyle,
                      ),
                      onTap: () {},
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 15,
                        ),
                        onPressed: () {
                          value.updatereason(
                              index1: widget.index1,
                              index2: widget.index2,
                              linenumber: widget.linenumber,
                              reason: _list[index].name ?? '',
                              reasonCode: _list[index].value!);
                          value.updateRemark(
                              index1: widget.index1,
                              index2: widget.index2,
                              linenumber: widget.linenumber,
                              remark: _listRemarks[index].text);
                          value.updateStatusSuccess(
                              index1: widget.index1,
                              index2: widget.index2,
                              linenumber: widget.linenumber);
                          Navigator.pop(context, 'OK');
                        },
                      ),
                    ),
                  )
                : Center(
                    child: Text("ไม่พบข้อมูล"),
                  )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
