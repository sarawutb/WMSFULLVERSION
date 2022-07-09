import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/themes/colors.dart';

class AdvanceCustomAlert extends StatelessWidget {
  final IconData? icon;
  final Color? backgroundIcon;
  final String? title;
  final String? content;
  final Color? backgroundButton;
  final String? nameButton;
  final Widget? rightButton;
  final Widget? leftButton;
  final bool? justifyText;
  const AdvanceCustomAlert(
      {Key? key,
      this.icon,
      this.backgroundIcon,
      this.title,
      this.content,
      this.backgroundButton,
      this.nameButton,
      this.rightButton,
      this.leftButton,
      this.justifyText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          // ignore: deprecated_member_use
          // overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${title ?? ""}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: kdefultsize),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${content ?? ""}',
                      style: TextStyle(fontSize: kdefultsize - 5),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: leftButton ??
                              // ignore: deprecated_member_use
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                color: backgroundButton ?? pink,
                                child: Text(
                                  '${nameButton ?? "ตกลง"}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: rightButton ?? Container()),
                      ],
                    )
                  ],
                ),
              ),
            ),
            if (icon != null)
              Positioned(
                  top: -60,
                  child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 60,
                    child: FaIcon(
                      icon ?? FontAwesomeIcons.wallet,
                      color: Colors.white,
                      size: 80,
                    ),
                  )),
          ],
        ));
  }
}
