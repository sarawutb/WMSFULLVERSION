import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/detaillog_model.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/themes/colors.dart';

class DetalGetLogScreen extends StatefulWidget {
  const DetalGetLogScreen({Key? key, required this.list}) : super(key: key);
  final List<DetailLog> list;
  @override
  _DetalGetLogScreenState createState() => _DetalGetLogScreenState();
}

class _DetalGetLogScreenState extends State<DetalGetLogScreen> {
  void removeWhereIndex({required int index}) {
    setState(() {
      widget.list.removeAt(index);
    });
  }

  Future<void> delete({required int rowid, required int index}) async {
    // UserModel userModel = context.read<UserProvider>().kGetUserModel;
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    var headers = {
      'Authorization': 'Bearer ${_user.user!.token} ',
      'Content-Type': 'application/json',
    };
    await RequestAssistant.removeRequestHttpResponse(
            url:
                "https://localapi.homeone.co.th/erp/v1/stk/StockCount/CountLog/?roworder=$rowid",
            headers: headers)
        .then((response) {
      switch (response.statusCode) {
        case 200:
          print(response.body);
          var reponseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: "${reponseJson["massage"]}");
          if (reponseJson["success"]) {
            removeWhereIndex(index: index);
          }

          break;

        case 401:
          Fluttertoast.showToast(msg: "token หมดอายุ");
          break;
        case 500:
          Fluttertoast.showToast(msg: "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้");

          break;
        default:
          Fluttertoast.showToast(msg: "มีข้อผิดพลาดไม่ทราบสาเหตุ");
      }
    }).timeout(
      Duration(seconds: 20),
      onTimeout: () {
        Fluttertoast.showToast(msg: "ไม่สามารถเชื่อมต่อกับเซิฟเวอร์ได้");
      },
    ).catchError((error, msg) {
      Fluttertoast.showToast(msg: "$error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ประวัติการนับ",
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
              color: kmainPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: kdefultsize - 5),
        ),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: widget.list.length,
          itemBuilder: (_, index) => Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            child: Container(
              color: Colors.white,
              child: Card(
                child: ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                    child: Text('${widget.list[index].no}'),
                    foregroundColor: Colors.white,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'นับได้ ${widget.list[index].countQty}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: kdefultsize - 5),
                          ),
                          Spacer(),
                          Text(
                            'นับได้ ${widget.list[index].countDate}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: kdefultsize - 10),
                          ),
                        ],
                      ),
                      Text('นับโดย ${widget.list[index].userName}'),
                    ],
                  ),
                  subtitle: Text('ตำแหน่ง ${widget.list[index].location}'),
                ),
              ),
            ),
            secondaryActions: <Widget>[
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () =>
                    delete(rowid: widget.list[index].roworder!, index: index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
