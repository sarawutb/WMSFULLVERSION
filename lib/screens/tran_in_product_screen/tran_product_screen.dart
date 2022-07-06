import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class TranProductScreen extends StatefulWidget {
  const TranProductScreen({Key? key}) : super(key: key);

  @override
  _TranProductScreenState createState() => _TranProductScreenState();
}

class _TranProductScreenState extends State<TranProductScreen> {
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
            "อยู่ระหว่างพัฒนา โอนสินค้า",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
