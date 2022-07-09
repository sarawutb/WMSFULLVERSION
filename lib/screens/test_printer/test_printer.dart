import 'dart:io';
import 'dart:typed_data';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' show Document;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:wms/themes/colors.dart';

class TestPrinter extends StatefulWidget {
  const TestPrinter({Key? key}) : super(key: key);

  @override
  _TestPrinterState createState() => _TestPrinterState();
}

class _TestPrinterState extends State<TestPrinter> {
  Directory? _downloadsDirectory;
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

  checkpermission_createfile() async {
    var createfile = await Permission.storage.status;
    // var permissionBluetooh = await Permission.bluetooth.status;
    print(createfile);
    if (!createfile.isGranted) await Permission.storage.request();

    if (await Permission.storage.isGranted) {
      if (_downloadsDirectory != null) writeFile(_downloadsDirectory!.path);
    }
  }

  readFilesFromCustomDevicePath(
      {required Uint8List byte, required String docno}) async {
    Directory? directory = await getExternalStorageDirectory();
    final roboto =
        await rootBundle.load('assets/fonts/Mitr/Mitr-ExtraLight.ttf');
    var robotoF = pw.Font.ttf(roboto);
    var pdf = Document(deflate: zlib.encode);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Column(
          children: List.generate(
            data.length,
            (i) => pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        data[i]['title'].toString(),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.Container(
                          height: 30,
                          width: 30,
                          child: pw.BarcodeWidget(
                            color: PdfColor.fromHex("#000000"),
                            barcode: pw.Barcode.qrCode(),
                            data: "1000000",
                          ))
                    ])),
          ),
        ),
      ),
    );

    File file = await File("${directory!.path}/barcode.pdf").create();
    await file
        .writeAsBytes(await pdf.save())
        .then((value) => print(value))
        .catchError((onError) => print(onError));

    print(file.absolute.path);
  }

  Future<void> writeFile(String path) async {
    final roboto =
        await rootBundle.load('assets/fonts/Mitr/Mitr-ExtraLight.ttf');
    var robotoF = pw.Font.ttf(roboto);
    var pdf = Document(
      deflate: zlib.encode,
    );
    var pageFormat = PdfPageFormat(77 * PdfPageFormat.mm, double.infinity,
        marginAll: 5 * PdfPageFormat.mm);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Column(
          children: List.generate(
            data.length,
            (i) => pw.Padding(
                padding: pw.EdgeInsets.symmetric(vertical: 10),
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        data[i]['title'].toString(),
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.Container(
                          height: 30,
                          width: 30,
                          child: pw.BarcodeWidget(
                            color: PdfColor.fromHex("#000000"),
                            barcode: pw.Barcode.qrCode(),
                            data: "1000000",
                          ))
                    ])),
          ),
        ),
      ),
    );

    File _file = File('$path/my_file.pdf');
    await _file
        .writeAsBytes(await pdf.save())
        .then((value) => print(value.path));

    // .writeAsBytes(await pdf.save());
  }

  final List<Map<String, dynamic>> data = [
    {'title': 'Cadbury Dairy Milk', 'price': 15, 'qty': 2},
    {'title': 'Parle-G Gluco Biscut', 'price': 5, 'qty': 5},
    {'title': 'Fresh Onion - 1KG', 'price': 20, 'qty': 1},
    {'title': 'Fresh Sweet Lime', 'price': 20, 'qty': 5},
    {'title': 'Maggi', 'price': 10, 'qty': 5},
    {'title': 's', 'price': 10, 'qty': 5},
    {'title': 'a', 'price': 10, 'qty': 5},
    {'title': 'g', 'price': 10, 'qty': 5},
    {'title': 'v', 'price': 10, 'qty': 5},
  ];

  final f = NumberFormat("###,###.00", "th");

  Future<void> shareFile({required String file}) async {
    await FlutterShare.shareFile(
      title: 'QRCODE${DateTime.now().second.toString()}',
      text: 'QRCODE',
      filePath: file,
    );
  }

  @override
  void initState() {
    initDownloadsDirectoryState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _total = 0;
    _total = data.map((e) => e['price'] * e['qty']).reduce(
          (value, element) => value + element,
        );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Developing'),
      //   backgroundColor: white,
      // ),
      body: true
          ? Center(
              child: Text("อยู่ระหว่างพัฒนา"),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (c, i) {
                      return ListTile(
                        title: Text(
                          data[i]['title'].toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          "${f.format(data[i]['price'])} x ${data[i]['qty']}",
                        ),
                        trailing: Text(
                          f.format(
                            data[i]['price'] * data[i]['qty'],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Text(
                        "Total: ${f.format(_total)}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            List<int> list = '10000000'.codeUnits;
                            Uint8List bytes = Uint8List.fromList(list);
                            String string = String.fromCharCodes(bytes);
                            await readFilesFromCustomDevicePath(
                                docno: 'X01-XXX', byte: bytes);
                            // await _localPath.then((value) => print(value));

                            // await generate(
                            //         docNo: "x000011000",
                            //         fullName: "sutthianai",
                            //         byte: null)
                            //     .then((value) async {
                            //   if (value != null) {
                            //     // await shareFile(file: value);
                            //   }
                            // });
                          },
                          icon: Icon(Icons.print),
                          label: Text('Print'),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.green),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            checkpermission_createfile();
                          },
                          icon: Icon(Icons.privacy_tip),
                          label: Text('Print'),
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.red),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  openDirectory() async {
    String filePath = "";
    String? result = await FilePicker.platform.getDirectoryPath();
    // Directory? directory = await getExternalStorageDirectory();
    print(result);
    // if (directory != null && result != null) {
    //   filePath = result.files.single.path ?? '';
    if (result != null) {
      OpenResult files = await OpenFile.open('$result\\');
      print(files.type);
    }
    // }
  }
}
