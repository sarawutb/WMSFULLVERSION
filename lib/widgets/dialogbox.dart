import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/sizedbox_height.dart';

void dialogBox(
    {required BuildContext context,
    required String title,
    required String subtitle}) {
  showGeneralDialog(
    barrierLabel: "$title",
    barrierDismissible: true,
    barrierColor: black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(kdefultsize - 15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.comments,
                  size: kdefultsize + 10,
                ),
                SizedBox(
                  height: kdefultsize - 10,
                ),
                Text(
                  "$title",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "$subtitle",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                sizedBoxHeight(),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("ตกลง"))
              ],
            ),
          ),
        ),
      );
    },
  );
}

void dialogBoxCancel({
  required BuildContext context,
  required String title,
  required String subtitle,
  required Widget widget,
  required VoidCallback press,
  required GlobalKey<FormState> formKey,
}) {
  showGeneralDialog(
    barrierLabel: "$title",
    barrierDismissible: true,
    barrierColor: black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 400,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(kdefultsize - 15),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.comments,
                      size: kdefultsize + 10,
                    ),
                    SizedBox(
                      height: kdefultsize - 10,
                    ),
                    Text(
                      "$title",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      "$subtitle",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    widget,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                press();
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text("ตกลง")),
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              "ยกเลิก",
                              style: TextStyle(color: red),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void dialogWidget(
    {required BuildContext context,
    required String title,
    String? subtitle,
    Widget? widget,
    Widget? rightBtn,
    Widget? leftBtn,
    VoidCallback? press,
    GlobalKey<FormState>? formKey,
    double? height}) {
  showGeneralDialog(
    barrierLabel: "$title",
    barrierDismissible: true,
    barrierColor: black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (context, anim1, anim2) {
      return Container();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height ?? 400,
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(kdefultsize - 15),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.comments,
                      size: kdefultsize + 10,
                    ),
                    SizedBox(
                      height: kdefultsize - 10,
                    ),
                    Text(
                      "$title",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Text(
                      "$subtitle",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    if (widget != null) widget,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (leftBtn != null) leftBtn,
                        if (rightBtn != null) rightBtn,
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
