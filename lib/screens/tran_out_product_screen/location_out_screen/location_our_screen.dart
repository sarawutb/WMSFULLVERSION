import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/models/locations.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:wms/services/url.dart';
import 'package:wms/themes/colors.dart';

class LocationOutScreen extends StatefulWidget {
  const LocationOutScreen(
      {Key? key,
      required this.itemCode,
      required this.zoneCode,
      required this.whCode})
      : super(key: key);
  final String itemCode;
  final String zoneCode;
  final String whCode;

  @override
  _LocationOutScreenState createState() => _LocationOutScreenState();
}

class _LocationOutScreenState extends State<LocationOutScreen> {
  @override
  void initState() {
    fecthData(
        itemCode: widget.itemCode,
        zoneCode: widget.zoneCode,
        whCode: widget.whCode);
    super.initState();
  }

  List<Locations> list_locations = [];
  bool status_load_data = false;

  Future<void> fecthData(
      {required String itemCode,
      required String zoneCode,
      required String whCode}) async {
    ControllerLoginScreen db = context.read<ControllerLoginScreen>();

    print(BaseUrl.url +
        'searchLocation?item_code=$itemCode&zone_code=$zoneCode&wh_code=$whCode&db=${db.getselectedItem.value}');
    try {
      await RequestAssistant.getRequestHttpResponse(
              url: BaseUrl.url +
                  'searchLocation?item_code=$itemCode&zone_code=$zoneCode&wh_code=$whCode&db=${db.getselectedItem.value}')
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          print(response.body);
          setState(() {
            list_locations = (responseJson["data"] as List)
                .map((e) => Locations.fromJson(e))
                .toList();
          });
        } else if (response.statusCode == 400) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));
          Fluttertoast.showToast(msg: responseJson["msg"]);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Fluttertoast.showToast(msg: "ทำรายการไม่สำเร็จ");
      throw Exception(e);
    } finally {
      setState(() {
        status_load_data = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: white,
              fontSize: 10,
            );
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => {
              Navigator.pop(context),
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              size: kdefultsize,
              color: black,
            ),
          ),
          elevation: 0,
          centerTitle: true,
          title: Text("ตำแหน่งสินค้า"),
        ),
        body: status_load_data
            ? SizedBox(
                width: double.infinity,
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text(
                        'ลำดับ',
                        style: _textStyle.copyWith(color: black, fontSize: 12),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'ตำแหน่ง',
                        style: _textStyle.copyWith(color: black, fontSize: 12),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      list_locations.length,
                      (int index) => DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                              // All rows will have the same selected color.
                              // if (states.contains(MaterialState.selected)) {
                              //   return Theme.of(context)
                              //       .colorScheme
                              //       .primary
                              //       .withOpacity(0.08);
                              // }
                              // Even rows will have a grey color.
                              if (index.isEven) {
                                return Colors.green.shade50;
                              } else {
                                return Colors.green.shade100;
                              }
                              // Use default value for other states and odd rows.
                            }),
                            cells: <DataCell>[
                              DataCell(Text('${index + 1}')),
                              DataCell(Text(
                                '${list_locations[index].location}',
                                style: _textStyle.copyWith(color: black),
                              )),
                            ],
                          )),
                ),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "กำลังโหลดข้อมูล..",
                      style: _textStyle.copyWith(color: black, fontSize: 12),
                    )
                  ],
                ),
              ));
  }
}
