import 'package:flutter/material.dart';
import 'package:wms/themes/colors.dart';

class ReportStatusScreen extends StatefulWidget {
  const ReportStatusScreen({Key? key}) : super(key: key);

  @override
  _ReportStatusScreenState createState() => _ReportStatusScreenState();
}

class _ReportStatusScreenState extends State<ReportStatusScreen> {
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
            "อยู่ระหว่างพัฒนา",
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    );
  }
}
