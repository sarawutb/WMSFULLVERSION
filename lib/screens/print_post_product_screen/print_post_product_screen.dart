import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class PrintPostProductScreen extends StatefulWidget {
  const PrintPostProductScreen({Key? key}) : super(key: key);

  @override
  _PrintPostProductScreenState createState() => _PrintPostProductScreenState();
}

class _PrintPostProductScreenState extends State<PrintPostProductScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: Text(
            "อยู่ระหว่างพัฒนา พิมพ์ป้าย\nสินค้า",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
