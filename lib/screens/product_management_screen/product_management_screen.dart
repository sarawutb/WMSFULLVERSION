import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({Key? key}) : super(key: key);

  @override
  _ProductManagementScreenState createState() =>
      _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
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
            "อยู่ระหว่างพัฒนา จัดสินค้า",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
