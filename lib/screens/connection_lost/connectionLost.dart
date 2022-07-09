import 'package:flutter/material.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/themes/colors.dart';

class ConnectionLost extends StatefulWidget {
  const ConnectionLost({Key? key}) : super(key: key);

  @override
  _ConnectionLostState createState() => _ConnectionLostState();
}

class _ConnectionLostState extends State<ConnectionLost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/10_Connection LostThai.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.100,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 25,
                    color: Color(0xFF59618B).withOpacity(0.17),
                  ),
                ],
              ),
              // ignore: deprecated_member_use
              child: FlatButton(
                color: kmainPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, RouteName.routeNameLoginScreen);
                },
                child: Text(
                  "ลองใหม่อีกครั้ง".toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
