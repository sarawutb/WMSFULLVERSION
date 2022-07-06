import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:provider/provider.dart';
import 'package:wms/services/http_reponse_service.dart';
import 'package:http/http.dart' as http;
import 'package:wms/themes/colors.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../controllers/controller_cancelListPrinter.dart';
import '../../../models/CancelListPrinterModel.dart';
import '../../../models/page_view_model.dart';

class SelectPrinter extends StatefulWidget {
  const SelectPrinter({Key? key, required this.filepath, required this.head})
      : super(key: key);
  final String filepath;
  final Head head;
  @override
  _SelectPrinterState createState() => _SelectPrinterState();
}

class _SelectPrinterState extends State<SelectPrinter> {
  List<dynamic> _list = [];
  // bool statuspage = true;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future getNamePrinter() async {
    ControllerUser user = context.read<ControllerUser>();
    ControllerCancelListPrinter cPrinter =
        context.read<ControllerCancelListPrinter>();
    // showAlertDialog(context);

    String whcode = user.user!.shelf!
        .map((val) => val.shelf!.substring(0, 2).trim())
        .join(',');

    print(
        'http://printpdf.homeone.co.th/PdfPrint/GetPrinterName?branch=${user.getUser.wmsBranch}&wh=${user.getUser.wmsWh}');
    try {
      await RequestAssistant.getRequestHttpResponse(
              url:
                  "http://printpdf.homeone.co.th/PdfPrint/GetPrinterName?branch=${user.getUser.wmsBranch}&wh=${user.getUser.wmsWh}")
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));

          List<CancelListPrinterModel> list = (responseJson as List)
              .map((e) => CancelListPrinterModel.fromJson(e))
              .toList();
          cPrinter.updatelistPrinterSelectPrinter(list: list);
        }
      }).timeout(Duration(seconds: 20));
    } on TimeoutException catch (e) {
      showAlertDialogText(context, e.toString());
    }

    // http://192.168.64.201:81/PdfPrint/GetPrinterName
  }

  void _onRefresh() async {
    // monitor network fetch
    await getNamePrinter();
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await getNamePrinter();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future<bool?> printer(
      {required String file, required String printerName}) async {
    showAlertDialog(context);
    try {
      var createfile = await Permission.storage.status;

      var request = http.MultipartRequest('POST',
          Uri.parse('http://printpdf.homeone.co.th/PdfPrint?papersize=A5'));
      request.fields.addAll({'printername': printerName});
      if (!createfile.isGranted) await Permission.storage.request();

      if (await Permission.storage.isGranted) {
        request.files.add(await http.MultipartFile.fromPath('file1', file));
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
      return null;
    } finally {
      // statuspage = true;
    }
  }

  @override
  void initState() {
    print(widget.filepath);
    super.initState();
    getNamePrinter();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);
    final ControllerCancelListPrinter _controller =
        context.read<ControllerCancelListPrinter>();
    ControllerUser user = context.read<ControllerUser>();

    return WillPopScope(
      onWillPop: () {
        _controller.clearlistPrinterSelectPrinter();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: black,
              ),
              onPressed: () => {
                _controller.clearlistPrinterSelectPrinter(),
                Navigator.pop(context)
              },
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(
              "เลือกเครื่องพิมพ์",
              style: _styledefult,
            ),
          ),
          body: Consumer<ControllerCancelListPrinter>(
            builder: (context, value, child) {
              List<CancelListPrinterModel> _list =
                  value.listPrinterSelectPrinter;
              return SmartRefresher(
                enablePullDown: true,
                enablePullUp: false,
                header: WaterDropHeader(),
                controller: _refreshController,

                onRefresh: _onRefresh,
                // onLoading: _onLoading,
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) => _list[index]
                          .onlyUserGroup!
                          .isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              color: index.isOdd
                                  ? Colors.blue.shade50
                                  : Colors.white),
                          child: ListTile(
                            onTap: () async {
                              // print(widget.filepath);
                              if ((_list[index].offline == false) &&
                                  (_list[index].inError == false)) {
                                // statuspage = false;
                                await printer(
                                        file: widget.filepath,
                                        printerName: _list[index].name!)
                                    .then((value) {
                                  if (value != null) {
                                    if (value) {
                                      Fluttertoast.showToast(
                                          msg: "สำเร็จ",
                                          backgroundColor: Colors.green);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "ไม่สำเร็จ",
                                          backgroundColor: Colors.red);
                                    }
                                    Navigator.pop(context);
                                    // Navigator.pop(context, 'OK');
                                  }
                                });
                              } else {
                                showAlertDialogPrinter(context);
                              }

                              // Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: Container(
                              alignment: Alignment.center,
                              color: index.isOdd
                                  ? Colors.blue.shade50
                                  : Colors.white,
                              constraints: BoxConstraints(
                                maxHeight: 60,
                                maxWidth: 60,
                              ),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(_list[index].icon!),
                                        fit: BoxFit.cover)),
                              ),
                              // child: GestureDetector(
                              //     onTap: () async => await showDialog(
                              //         context: context,
                              //         builder: (_) => ImageDialog(
                              //               urlImage: _list[index].icon!,
                              //             )),
                              //     child: Icon(Icons.image_search_sharp)),
                              // child: Text(
                              //   (index + 1).toString(),
                              //   style: _styledefult.copyWith(
                              //       fontWeight: FontWeight.bold),
                              // ),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_list[index].name2}",
                                  style: _styledefult.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                                if ((_list[index].allProblem!).isNotEmpty)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                            _list[index].allProblem!.length,
                                            (index2) => Container(
                                                  margin:
                                                      EdgeInsets.only(right: 5),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Text(
                                                    "${(_list[index].allProblem![index2])}",
                                                    style:
                                                        _styledefult.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                ))
                                      ],
                                    ),
                                  ),
                                if ((_list[index].allProblem!).isEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      "ออนไลน์",
                                      style: _styledefult.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: white),
                                    ),
                                  )
                              ],
                            ),
                            subtitle: Text(
                              "${_list[index].branch}",
                              style: _styledefult,
                            ),
                            horizontalTitleGap: 10,
                            trailing: (_list[index].jobs!).isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        var res = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CancelListPrinter(
                                                // list: _list[index].jobs!,
                                                nameprinter: _list[index].name!,
                                                index: index,
                                                status: _list[index].offline!
                                                    ? true
                                                    : false,
                                              ),
                                            ));
                                        if (res == 'OK') {
                                          await getNamePrinter();
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          "ค้างพิมพ์ (${(_list[index].jobs!).length})",
                                          style: _styledefult.copyWith(
                                              color: white, fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ),
                        )
                      : _list[index].onlyUserGroup!.any((element) =>
                              element.contains("${user.getUser.userGroup}"))
                          ? Container(
                              decoration: BoxDecoration(
                                  color: index.isOdd
                                      ? Colors.blue.shade50
                                      : Colors.white),
                              child: ListTile(
                                onTap: () async {
                                  // print(widget.filepath);
                                  if ((_list[index].offline == false) &&
                                      (_list[index].inError == false)) {
                                    await printer(
                                            file: widget.filepath,
                                            printerName: _list[index].name!)
                                        .then((value) {
                                      if (value != null) {
                                        if (value) {
                                          Fluttertoast.showToast(
                                              msg: "สำเร็จ",
                                              backgroundColor: Colors.green);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "ไม่สำเร็จ",
                                              backgroundColor: Colors.red);
                                        }
                                        Navigator.pop(context);
                                        // Navigator.pop(context, 'OK');
                                      }
                                    });
                                  } else {
                                    showAlertDialogPrinter(context);
                                  }

                                  // Navigator.pop(context);
                                },
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  alignment: Alignment.center,
                                  color: index.isOdd
                                      ? Colors.blue.shade50
                                      : Colors.white,
                                  constraints: BoxConstraints(
                                    maxHeight: 60,
                                    maxWidth: 60,
                                  ),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                _list[index].icon!),
                                            fit: BoxFit.cover)),
                                  ),
                                  // child: GestureDetector(
                                  //     onTap: () async => await showDialog(
                                  //         context: context,
                                  //         builder: (_) => ImageDialog(
                                  //               urlImage: _list[index].icon!,
                                  //             )),
                                  //     child: Icon(Icons.image_search_sharp)),
                                  // child: Text(
                                  //   (index + 1).toString(),
                                  //   style: _styledefult.copyWith(
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_list[index].name2}",
                                      style: _styledefult.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if ((_list[index].allProblem!).isNotEmpty)
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            ...List.generate(
                                                _list[index].allProblem!.length,
                                                (index2) => Container(
                                                      margin: EdgeInsets.only(
                                                          right: 5),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5,
                                                              vertical: 2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Text(
                                                        "${(_list[index].allProblem![index2])}",
                                                        style: _styledefult
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                    ))
                                          ],
                                        ),
                                      ),
                                    if ((_list[index].allProblem!).isEmpty)
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "ออนไลน์",
                                          style: _styledefult.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: white),
                                        ),
                                      )
                                  ],
                                ),
                                subtitle: Text(
                                  "${_list[index].branch}",
                                  style: _styledefult,
                                ),
                                horizontalTitleGap: 10,
                                trailing: (_list[index].jobs!).isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () async {
                                            var res = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CancelListPrinter(
                                                    // list: _list[index].jobs!,
                                                    nameprinter:
                                                        _list[index].name!,
                                                    index: index,
                                                    status:
                                                        _list[index].offline!
                                                            ? true
                                                            : false,
                                                  ),
                                                ));
                                            if (res == 'OK') {
                                              await getNamePrinter();
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              "ค้างพิมพ์ (${(_list[index].jobs!).length})",
                                              style: _styledefult.copyWith(
                                                  color: white, fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            )
                          : SizedBox.shrink(),
                ),
              );
            },
          )),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("กำลังดำเนินการ...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogPrinter(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text("เครื่องปรื้นไม่พร้อมใช้งาน")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogText(BuildContext context, String text) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text(text)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class CancelListPrinter extends StatefulWidget {
  const CancelListPrinter(
      {Key? key,
      // required this.list,
      required this.nameprinter,
      required this.status,
      required this.index})
      : super(key: key);
  // final List<Job> list;
  final String nameprinter;
  final bool status;
  final int index;
  @override
  State<CancelListPrinter> createState() => _CancelListPrinterState();
}

class _CancelListPrinterState extends State<CancelListPrinter> {
  // bool statuspage = false;

  showAlertDialogText(BuildContext context, String text, Color? color) {
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);
    AlertDialog alert = AlertDialog(
      actions: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color ?? Colors.green,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text("ตกลง",
                style: _styledefult.copyWith(
                    color: white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
      content: Container(
        alignment: Alignment.center,
        height: 80,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              text,
              style: _styledefult,
              maxLines: 3,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future removeprinter(
      {required String name, required String jobid, required int index}) async {
    print(
        'http://printpdf.homeone.co.th/PdfPrint/CancelPrintJob?printer_name=${widget.nameprinter}&job_id=$jobid');
    ControllerUser user = context.read<ControllerUser>();
    // showAlertDialog(context);
    try {
      var request = http.Request(
          'GET',
          Uri.parse(
              'http://printpdf.homeone.co.th/PdfPrint/CancelPrintJob?printer_name=${widget.nameprinter}&job_id=$jobid'));

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        // print(await response.stream.bytesToString());
        showAlertDialogText(context, "ส่งคำสั่งลบแล้ว", Colors.green);
        setState(() {
          // value.listPrinterSelectPrinter[widget.index].jobs!.removeAt(index);
        });
      } else {
        showAlertDialogText(
            context, "ยกเลิกการพิมพ์ไฟล์ $name ไม่สำเร็จ", Colors.red);
      }
    } on TimeoutException catch (e) {
      showAlertDialogText(context, e.toString(), Colors.red);
    } finally {
      // Navigator.pop(context);
      getNamePrinter();
      setState(() {});
      // statuspage = true;
    }

    // http://192.168.64.201:81/PdfPrint/GetPrinterName
  }

  Future getNamePrinter() async {
    ControllerUser user = context.read<ControllerUser>();
    ControllerCancelListPrinter cPrinter =
        context.read<ControllerCancelListPrinter>();
    // showAlertDialog(context);

    String whcode = user.user!.shelf!
        .map((val) => val.shelf!.substring(0, 2).trim())
        .join(',');

    print(
        'http://printpdf.homeone.co.th/PdfPrint/GetPrinterName?branch=${user.getUser.wmsBranch}&wh=${user.getUser.wmsWh}');
    try {
      await RequestAssistant.getRequestHttpResponse(
              url:
                  "http://printpdf.homeone.co.th/PdfPrint/GetPrinterName?branch=${user.getUser.wmsBranch}&wh=${user.getUser.wmsWh}")
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(utf8.decode(response.bodyBytes));

          List<CancelListPrinterModel> list = (responseJson as List)
              .map((e) => CancelListPrinterModel.fromJson(e))
              .toList();
          cPrinter.updatelistPrinterSelectPrinter(list: list);
        }
      }).timeout(Duration(seconds: 20));
    } on TimeoutException catch (e) {
      showAlertDialogText(context, e.toString(), Colors.red);
    }

    // http://192.168.64.201:81/PdfPrint/GetPrinterName
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle _styledefult =
        Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 12);
    final ControllerUser _user = context.read<ControllerUser>();
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, 'OK');
        return Future.value(true);
      },
      child: Consumer<ControllerCancelListPrinter>(
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_outlined,
                color: black,
              ),
              onPressed: () => Navigator.pop(context, 'OK'),
            ),
            centerTitle: true,
            elevation: 0,
            title: Text(
              "ค้างพิมพ์ (${value.listPrinterSelectPrinter[widget.index].jobs!.length}) ${widget.status ? "ออฟไลน์" : "ออนไลน์"}",
              style: _styledefult,
            ),
          ),
          body: Container(
            child: value.listPrinterSelectPrinter[widget.index].jobs!.isNotEmpty
                ? ListView.builder(
                    itemCount: value
                        .listPrinterSelectPrinter[widget.index].jobs!.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color:
                            // (!(_user.getUser.userId ==
                            //             value.listPrinterSelectPrinter[widget.index]
                            //                 .jobs![index].userPrint) ||
                            //         _user.getUser.userGroup == 'HQDEV')
                            //     ? Colors.grey.shade200
                            //     :

                            Colors.green.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            title: Text(
                              'ชื่อไพล์ : ' +
                                  value.listPrinterSelectPrinter[widget.index]
                                      .jobs![index].name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'สถานะ : ' +
                                      value
                                          .listPrinterSelectPrinter[
                                              widget.index]
                                          .jobs![index]
                                          .status!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 10),
                                  maxLines: 2,
                                ),
                                Text(
                                  'เวลา : ' +
                                      value
                                          .listPrinterSelectPrinter[
                                              widget.index]
                                          .jobs![index]
                                          .date!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(fontSize: 10),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                            trailing: GestureDetector(
                                onTap: () {
                                  if (widget.status) {
                                    showAlertDialogText(
                                        context,
                                        "เครื่องพิมพ์ออฟไลน์ไม่สามารถยกเลิกการพิมพ์ได้",
                                        Colors.red);
                                  } else {
                                    // if (_user.getUser.userId ==
                                    //         value
                                    //             .listPrinterSelectPrinter[
                                    //                 widget.index]
                                    //             .jobs![index]
                                    //             .userPrint! ||
                                    //     _user.getUser.userGroup == 'HQDEV') {
                                    // if (statuspage)
                                    removeprinter(
                                        name: value
                                            .listPrinterSelectPrinter[
                                                widget.index]
                                            .jobs![index]
                                            .name
                                            .toString(),
                                        jobid: value
                                            .listPrinterSelectPrinter[
                                                widget.index]
                                            .jobs![index]
                                            .id
                                            .toString(),
                                        index: index);
                                    // } else {
                                    //   showAlertDialogText(context,
                                    //       "คุณไม่มีสิทธิลบไฟล์นี้", Colors.red);
                                    // }
                                  }
                                },
                                child: SvgPicture.asset(
                                    "assets/icons/Trash.svg",
                                    color:
                                        // (_user.getUser.userId ==
                                        //         value
                                        //             .listPrinterSelectPrinter[
                                        //                 widget.index]
                                        //             .jobs![index]
                                        //             .userPrint)
                                        //     ? Colors.red
                                        //     : _user.getUser.userGroup == 'HQDEV'
                                        // ?
                                        Colors.red
                                    // : Colors.grey
                                    )),
                          )),
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "ไม่มีรายการ!",
                          style: TextStyle(color: red),
                        )
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ImageDialog extends StatelessWidget {
  final String urlImage;

  const ImageDialog({Key? key, required this.urlImage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(urlImage), fit: BoxFit.cover)),
      ),
    );
  }
}
