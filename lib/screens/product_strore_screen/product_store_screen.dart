import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class ProductStoreScreen extends StatefulWidget {
  const ProductStoreScreen({Key? key}) : super(key: key);

  @override
  _ProductStoreScreenState createState() => _ProductStoreScreenState();
}

class _ProductStoreScreenState extends State<ProductStoreScreen> {
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
            "อยู่ระหว่างพัฒนา เก็บสินค้า",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
