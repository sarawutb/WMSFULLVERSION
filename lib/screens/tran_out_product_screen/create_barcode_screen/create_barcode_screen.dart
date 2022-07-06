// ignore_for_file: unused_import

import 'dart:io';
import 'dart:typed_data';

import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException, rootBundle;
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' show Document;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wms/controllers/controller_tran_out_product.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/models/page_view_model.dart';
import 'package:provider/provider.dart';
import 'package:wms/models/user_model.dart';
import 'package:wms/screens/tran_out_product_screen/create_barcode_screen/select_printer.dart';
import 'package:wms/themes/colors.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' show get;
import 'dart:async';

// ! เปลี่ยนวันที่ send เป็น recive
class CreateBarCode extends StatefulWidget {
  const CreateBarCode(
      {Key? key,
      required this.head,
      required this.arName,
      this.stringname = 'ใบเตรียมจ่ายสินค้า',
      required this.eventdate})
      : super(key: key);
  final Head head;
  final String arName;
  final String stringname;
  final DateTime eventdate;
  @override
  _CreateBarCodeState createState() => _CreateBarCodeState();
}

class _CreateBarCodeState extends State<CreateBarCode> {
  Directory? _downloadsDirectory;
  String? fileremovepath;
  var data;
  // String? filepathSendPrinter;

//https://media.homeone.co.th/images/wms/X01.png
//https://media.homeone.co.th/images/wms/X02.png
//https://media.homeone.co.th/images/wms/X03.png

  Future<void> initDownloadsDirectoryState() async {
    Directory? downloadsDirectory;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });
  }

  Future<String?> checkpermissionCreatefile() async {
    String? path;
    var createfile = await Permission.storage.status;
    if (!createfile.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      if (_downloadsDirectory != null) {
        path = await writeFile(_downloadsDirectory!.path);
      }
    }
    print(">>>>>>>>>>>>>>>>>>$path");
    return path;
  }

  Future<String?> checkpermissionCreatefile2() async {
    String? path;
    var createfile = await Permission.storage.status;
    if (!createfile.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      if (_downloadsDirectory != null) {
        path = await writeFile2(_downloadsDirectory!.path);
      }
    }
    print(">>>>>>>>>>>>>>>>>>$path");
    return path;
  }

  Future<void> removefile({required String filepath}) async {
    var createfile = await Permission.storage.status;
    if (!createfile.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      File _file = File(filepath);
      await _file
          .delete()
          .then((value) => print(">>REMOVE FILE FROM PATH $filepath<<"));
    }
  }

  Future<String> shareFile({required String file}) async {
    await FlutterShare.shareFile(
      title: '${widget.head.docNo}',
      text: 'QRCODE',
      filePath: file,
    );
    return file;
  }

  Future<void> download() async {
    final ControllerUser user = context.read<ControllerUser>();

    var url =
        "https://media.homeone.co.th/images/wms/${(widget.head.detail!.isEmpty ? 'X01' : widget.head.detail![0].whCode)}.png";

    var response = await get(Uri.parse(url));
    data = response.bodyBytes;
  }

  Future<String> writeFile(String path) async {
    final ControllerUser user = context.read<ControllerUser>();
    final roboto = await rootBundle.load('assets/fonts/rsufont/RSU_BOLD.ttf');
    var robotoF = pw.Font.ttf(roboto);
    var pdf = Document(
      deflate: zlib.encode,
    );
    var pageFormat = PdfPageFormat(77 * PdfPageFormat.mm, double.infinity,
        marginAll: 5 * PdfPageFormat.mm);
    var imageData = await rootBundle.load('assets/icons/delivery.png');
    pdf.addPage(
      pw.Page(
          pageFormat: pageFormat,
          theme: pw.ThemeData.withFont(
            base: robotoF,
          ),
          build: (context) => pw.Column(children: [
                ...List.generate(
                  int.parse(folderController.text),
                  (i) => pw.Column(
                    children: List.generate(
                      1,
                      (index) => pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                                pw.Text(
                                    "${i + 1} / ${int.parse(folderController.text)}",
                                    style: pw.TextStyle(
                                        fontSize: 12,
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.Text("ลูกค้า :${widget.arName}",
                              style: pw.TextStyle(
                                fontSize: 18,
                              )),
                          pw.Text(
                            "ประเภทการส่ง : ${widget.head.sendType}}",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            "ใบจัดสินค้าเลขที่ : ${widget.head.detail![index].docNo}",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                              "ที่เก็บ : ${widget.head.detail![index].shelfCode} ${widget.head.detail![index].nameShlfCode}",
                              style: pw.TextStyle(
                                fontSize: 10,
                              )),
                          pw.Text("ผู้จัดสินค้า : ${user.user!.fullName}",
                              style: pw.TextStyle(
                                fontSize: 10,
                              )),

                          pw.Text(
                            "พนักงานขาย : ${widget.head.saleName ?? ''} ${widget.head.createDateTime ?? ''}",
                            style: pw.TextStyle(
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            "เอกสารอ้างอิง : ${widget.head.detail![index].refDocNo ?? '-'}",
                            style: pw.TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          // pw.Text(
                          //     "ใบจัดสินค้าเลขที่ : ${widget.head.detail![i].docNo}",
                          //     style: pw.TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: pw.FontWeight.normal)),
                          // pw.Text(
                          //     "ที่เก็บ : ${widget.head.detail![i].shelfCode}",
                          //     style: pw.TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: pw.FontWeight.normal)),
                          // pw.Text("${widget.head.detail![i].nameShlfCode}",
                          //     style: pw.TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: pw.FontWeight.normal)),
                          // pw.Text("ผู้จัดสินค้า : ${user.user?.fullName ?? ''}",
                          //     style: pw.TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: pw.FontWeight.normal)),
                          // pw.Text("ลูกค้า :${widget.arName}",
                          //     style: pw.TextStyle(
                          //         fontSize: 10,
                          //         fontWeight: pw.FontWeight.normal)),
                          pw.Container(
                              height: 30,
                              width: 30,
                              child: pw.BarcodeWidget(
                                color: PdfColor.fromHex("#000000"),
                                barcode: pw.Barcode.qrCode(),
                                data:
                                    "${widget.head.detail![index].docNo ?? ''}",
                              )),
                          pw.Divider(),
                          pw.SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                )
              ])),
    );

    File _file = File(
        '$path/${user.user!.userId}_${widget.arName}_${widget.head.docNo ?? 'barcode'}.pdf');
    await _file
        .writeAsBytes(await pdf.save())
        .then((value) => print(value.path))
        .catchError((e) {
      print(e.toString());
    });

    // print(_file.path + "*******");
    return _file.path;
  }

  Future<String> writeFile2(String path) async {
    final ControllerUser user = context.read<ControllerUser>();
    final roboto = await rootBundle.load('assets/fonts/rsufont/RSU_BOLD.ttf');
    var robotoF = pw.Font.ttf(roboto);
    var pdf = Document(
      deflate: zlib.encode,
    );
    var imageData = await rootBundle.load('assets/icons/delivery.png');
    String str = 'ใบเตรียมจ่ายสินค้า';
    final f_resive = new DateFormat('dd/M/yyyy', 'th');
    final resive_event = new DateFormat('dd-M-yyyy H:mm', 'th');
    // var pageFormat = PdfPageFormat(77 * PdfPageFormat.mm, double.infinity,
    //     marginAll: 5 * PdfPageFormat.mm);
//Load image data into PDF bitmap object

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a5,
      orientation: pw.PageOrientation.landscape,
      margin: pw.EdgeInsets.all(15),
      theme: pw.ThemeData.withFont(
        base: robotoF,
      ),
      build: (context) => List.generate(
          int.parse(folderController.text),
          (i) => pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: List.generate(
                  1,
                  (index) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Expanded(
                              child: pw.Text("${widget.stringname}",
                                  style: pw.TextStyle(
                                    fontSize: 26,
                                  ),
                                  textAlign: pw.TextAlign.center),
                            ),
                            pw.Text(
                              "${i + 1} / ${int.parse(folderController.text)}",
                              style: pw.TextStyle(
                                  fontSize: 26, fontWeight: pw.FontWeight.bold),
                            ),
                          ]),
                      pw.Text("ลูกค้า :${widget.arName}",
                          style: pw.TextStyle(
                            fontSize: 26,
                          )),
                      pw.Row(
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Container(
                              // color: Colors.green,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    "ประเภทการส่ง : ${widget.head.sendType}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  pw.Text(
                                    "วันที่รับ/ส่งสินค้า : ${f_resive.format(widget.head.receiveDate!)}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  pw.Text(
                                    "ใบจัดสินค้าเลขที่ : ${widget.head.detail![index].docNo}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  pw.Text(
                                      "ที่เก็บ : ${widget.head.detail![index].shelfCode} ${widget.head.detail![index].nameShlfCode}",
                                      style: pw.TextStyle(
                                        fontSize: 18,
                                      )),
                                  pw.Text(
                                      "ผู้จัดสินค้า : ${user.user!.fullName} ${resive_event.format(widget.eventdate)}",
                                      style: pw.TextStyle(
                                        fontSize: 18,
                                      )),
                                  pw.Text(
                                    "พนักงานขาย : ${widget.head.saleName ?? ''} ${widget.head.createDateTime ?? ''}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  pw.Text(
                                    "เบอร์โทรภายใน : ${widget.head.localMobile ?? '-'}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  pw.Text(
                                    "เอกสารอ้างอิง : ${widget.head.detail![index].refDocNo ?? '-'}",
                                    style: pw.TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              height: 102,
                              alignment: pw.Alignment.topCenter,
                              // color: red,
                              child: pw.Column(
                                mainAxisSize: pw.MainAxisSize.max,
                                crossAxisAlignment: pw.CrossAxisAlignment.end,
                                mainAxisAlignment: pw.MainAxisAlignment.start,
                                children: [
                                  pw.Container(
                                      height: 45,
                                      child: pw.BarcodeWidget(
                                        color: PdfColor.fromHex("#000000"),
                                        barcode: pw.Barcode.qrCode(),
                                        data:
                                            "${widget.head.detail![index].docNo ?? ''}",
                                      )),
                                  if (widget.head.sendType == 'ส่งให้')
                                    pw.Container(
                                      height: 55,
                                      child: pw.Container(
                                        height: 22,
                                        // width: 50,
                                        decoration: pw.BoxDecoration(
                                          image: pw.DecorationImage(
                                              image: pw.MemoryImage(imageData
                                                  .buffer
                                                  .asUint8List()),
                                              fit: pw.BoxFit.contain),
                                        ),
                                      ),
                                    )
                                  // Image.network("src")
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      pw.Divider(
                        height: 2,
                      ),
                      // pw.SizedBox(height: 5),
                      //https://media.homeone.co.th/images/wms/X01.png
                      //https://media.homeone.co.th/images/wms/X02.png
                      //https://media.homeone.co.th/images/wms/X03.png

                      pw.SizedBox(
                        height: 80,
                        width: double.infinity,
                        child: pw.Row(children: [
                          pw.Expanded(
                            flex: 1,
                            child: pw.Container(
                              // height: 16,
                              // width: 50,
                              decoration: pw.BoxDecoration(
                                image: pw.DecorationImage(
                                    image: pw.MemoryImage(data),
                                    fit: pw.BoxFit.contain),
                              ),
                            ),
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              )),
    ));

    File _file = File(
        '$path/${user.user!.userId}_${user.user!.fullName}_${widget.arName}_${widget.head.docNo ?? 'barcode'}.pdf');
    await _file
        .writeAsBytes(await pdf.save())
        .then((value) => print(value.path))
        .catchError((e) {
      print(e.toString());
    });

    // print(_file.path + "*******");
    return _file.path;
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  final folderController = TextEditingController(text: "1");

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'สำเนา',
            textAlign: TextAlign.left,
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: folderController,
                autofocus: true,
                decoration: InputDecoration(hintText: 'กรอกจำนวนสำเนา'),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              color: Colors.blue,
              child: Text(
                'ตกลง',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (folderController.text.isNotEmpty) {
                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
            FlatButton(
              color: Colors.redAccent,
              child: Text(
                'ปิด',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    initDownloadsDirectoryState();
    download();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ControllerTranOutProduct controllerTranOutProduct =
        context.read<ControllerTranOutProduct>();
    final ControllerUser _user = context.read<ControllerUser>();
    final TextStyle _textStyle =
        Theme.of(context).textTheme.subtitle2!.copyWith(
              fontWeight: FontWeight.bold,
              color: black,
              fontSize: 10,
            );
    // final f_resive = new DateFormat('dd/M/yyyy เวลา H ชั่วโมง mm นาที', 'th');
    final f_resive = new DateFormat('dd/M/yyyy', 'th');
    final resive_event = new DateFormat('dd-M-yyyy H:mm', 'th');
    return WillPopScope(
      onWillPop: () async {
        if (fileremovepath != null) {
          await removefile(filepath: fileremovepath!);
        }
        Navigator.pop(context, "OK");
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: Text('QR-CODE'),
          leading: GestureDetector(
            onTap: () => _showMyDialog(),
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              color: Colors.blue.shade400,
              child: Stack(
                children: [
                  Icon(
                    Icons.file_copy_sharp,
                    color: white,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      alignment: Alignment.center,
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${folderController.text}",
                        style: _textStyle.copyWith(
                            fontSize: 5,
                            fontWeight: FontWeight.bold,
                            color: white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          elevation: 3,
          actions: [
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () async {
                      String? _path = await checkpermissionCreatefile2();
                      print(_path ?? '');
                      if (_path != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectPrinter(
                              filepath: _path,
                              head: widget.head,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 50,
                      // height: 40,
                      height: double.infinity,
                      color: Colors.red.shade400,
                      child: Icon(
                        Icons.local_print_shop_rounded,
                        color: white,
                        size: 30,
                      ),
                    )),
              ],
            )
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(int.parse(folderController.text), (index) {
                    List<Detail> _detail = widget.head.detail!;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "ใบเตรียมจ่ายสินค้า",
                                        style: _textStyle.copyWith(
                                          fontSize: 18,
                                          fontFamily: 'RSU',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      "${index + 1} / ${int.parse(folderController.text)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Text("ลูกค้า :${widget.arName}",
                                    style: _textStyle.copyWith(
                                        fontSize: 18, fontFamily: 'RSU')),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        // color: Colors.green,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                "ประเภทการส่ง : ${widget.head.sendType}",
                                                style: _textStyle.copyWith(
                                                    fontSize: 12,
                                                    fontFamily: 'RSU')),
                                            if (widget.head.receiveDate != null)
                                              Text(
                                                  "วันที่รับ/ส่งสินค้า : ${f_resive.format(widget.head.receiveDate!)}",
                                                  style: _textStyle.copyWith(
                                                      fontSize: 12,
                                                      fontFamily: 'RSU')),
                                            if (widget.head.receiveDate == null)
                                              Text(
                                                  "วันที่รับ/ส่งสินค้า : ไม่ได้ระบุ",
                                                  style: _textStyle.copyWith(
                                                      fontSize: 12,
                                                      fontFamily: 'RSU')),
                                            Text(
                                              "ใบจัดสินค้าเลขที่ : ${_detail[0].docNo}",
                                              style: _textStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: 'RSU'),
                                            ),
                                            Text(
                                                "ที่เก็บ : ${_detail[0].shelfCode} ${_detail[0].nameShlfCode}",
                                                style: _textStyle.copyWith(
                                                    fontSize: 12,
                                                    fontFamily: 'RSU')),
                                            Text(
                                                "ผู้จัดสินค้า : ${_user.user!.fullName} ${resive_event.format(widget.eventdate)}",
                                                style: _textStyle.copyWith(
                                                    fontSize: 12,
                                                    fontFamily: 'RSU')),
                                            Text(
                                              "พนักงานขาย : ${widget.head.saleName ?? ''} ${widget.head.createDateTime ?? ''}",
                                              style: _textStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: 'RSU'),
                                            ),
                                            Text(
                                              "เบอร์โทรภายใน : ${widget.head.localMobile ?? '-'}",
                                              style: _textStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: 'RSU'),
                                            ),
                                            Text(
                                              "เอกสารอ้างอิง : ${_detail[0].refDocNo ?? '-'}",
                                              style: _textStyle.copyWith(
                                                  fontSize: 12,
                                                  fontFamily: 'RSU'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        height: 102,
                                        alignment: Alignment.topCenter,
                                        // color: red,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            QrImage(
                                              data: _detail.isNotEmpty
                                                  ? _detail[0].docNo ??
                                                      'ไม่พบข้อมูล'
                                                  : 'ไม่พบข้อมูล',
                                              size: 45,
                                              version: QrVersions.auto,
                                              // embeddedImage: AssetImage('images/logo.png'),
                                              // embeddedImageStyle:
                                              //     QrEmbeddedImageStyle(size: Size(60, 60)),
                                            ),
                                            if (widget.head.sendType ==
                                                'ส่งให้')
                                              Container(
                                                height: 55,
                                                child: Image.asset(
                                                    'assets/icons/delivery.png'),
                                              )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                //https://media.homeone.co.th/images/wms/X01.png
                                //https://media.homeone.co.th/images/wms/X02.png
                                //https://media.homeone.co.th/images/wms/X03.png
                                Divider(
                                  color: black,
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Image.network(
                                          "https://media.homeone.co.th/images/wms/${(widget.head.detail!.isEmpty ? 'X01' : widget.head.detail![0].whCode)}.png"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  if (widget.head.detail!.isEmpty) Text("ไม่พบข้อมูล"),
                  SizedBox(
                    height: 20,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.pushAndRemoveUntil(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) => TranOutProductScreen()),
                  //           (route) => false);
                  //     },
                  //     child: Text("เสร็จ"))
                ],
              ),
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     SizedBox(
            //       height: 60,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: ElevatedButton.icon(
            //                 icon: Icon(
            //                   Icons.print,
            //                   color: Colors.white,
            //                 ),
            //                 label: Text("พิมพ์"),
            //                 style: ButtonStyle(
            //                   backgroundColor: MaterialStateProperty.all(
            //                       Colors.blue.shade600),
            //                 ),
            //                 onPressed: () async {
            //                   String? _path = await checkpermissionCreatefile();
            //                   if (_path != null) {
            //                     await shareFile(file: _path).then((value) {
            //                       fileremovepath = value;
            //                     });
            //                   } else {
            //                     Fluttertoast.showToast(
            //                         msg: "สร้างไฟล์ไม่สำเร็จ",
            //                         backgroundColor: red);
            //                   }
            //                   // Navigator.pop(context, "OK");
            //                 },
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: ElevatedButton.icon(
            //                 icon: Icon(
            //                   Icons.check,
            //                   color: Colors.white,
            //                 ),
            //                 label: Text("เสร็จสิ้น"),
            //                 style: ButtonStyle(
            //                   backgroundColor: MaterialStateProperty.all(
            //                       Colors.green.shade600),
            //                 ),
            //                 onPressed: () async {
            //                   if (fileremovepath != null) {
            //                     await removefile(filepath: fileremovepath!);
            //                   }
            //                   Navigator.pop(context, "OK");
            //                 },
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     )
            //   ],
            // )
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context, "OK");
            // Add your onPressed code here!
          },
          label: const Text('เสร็จสิ้น'),
          icon: const Icon(Icons.check),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
