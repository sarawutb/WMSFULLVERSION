// ignore_for_file: override_on_non_overriding_member

import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wms/controllers/controller_login_screen.dart';
import 'package:wms/controllers/controller_user.dart';
import 'package:wms/routes/routes.dart';
import 'package:wms/screens/login_screen/widget/body.dart';
import 'package:provider/provider.dart';
import 'package:wms/services/push_notification_service.dart';
import 'package:wms/themes/colors.dart';
import 'package:wms/widgets/advance_dialog.dart';
import 'package:wms/widgets/willPopScope.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  TextEditingController _textEditingControllerUser = TextEditingController();
  TextEditingController _textEditingControllerPassword =
      TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    context.read<ControllerLoginScreen>().initstateDropItem();
    context.read<ControllerLoginScreen>().getCurrentVersion();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });

    super.initState();
    SchedulerBinding.instance!
        .addPostFrameCallback((_) => {print('addPostFrameCallback')});
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _textEditingControllerUser.dispose();
    _textEditingControllerPassword.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final ControllerUser _user =
        Provider.of<ControllerUser>(context, listen: false);
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        print('Resumed พับจอ');
        break;
      case AppLifecycleState.inactive:
        // --
        print('Inactive เปิดกลับมาใหม่');
        break;
      case AppLifecycleState.paused:
        // --
        print('Paused ปิดจอไปเลย');
        break;
      case AppLifecycleState.detached:
        // --
        print('Detached ปิดทิ้ง');

        if (_user.user != null)
          await FirebaseMessaging.instance
              .unsubscribeFromTopic(_user.user!.userId!)
              .then((value) =>
                  print("unsubscribeFromTopic ${_user.user!.userId!}"));
        break;
    }
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //       print('กลับเข้า App มาใหม่');
  //       break;
  //     case AppLifecycleState.resumed:
  //       print('Background');
  //       break;
  //     case AppLifecycleState.paused:
  //       print('กลับเข้า App มาใหม่');
  //       break;
  //     case AppLifecycleState.detached:
  //       print('เมื่อ Page หรือ App นั้นถูกทำลาย');
  //       break;
  //   }
  // }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        context.read<ControllerUser>().initUrl(context: context);
        break;
      case ConnectivityResult.mobile:
        context.read<ControllerUser>().initUrl(context: context);
        break;
      case ConnectivityResult.none:
        Navigator.pushReplacementNamed(
            context, RouteName.routeNameConnectionLost);
        break;
      default:
        Navigator.pushReplacementNamed(
            context, RouteName.routeNameConnectionLost);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return willPopScope(
      press: () async {
        final shouldPop = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AdvanceCustomAlert(
                backgroundIcon: kPrimaryColor,
                icon: FontAwesomeIcons.exclamationCircle,
                title: "แจ้งเตือนจากระบบ",
                content: "คุณต้องการออกจากแอพพลิเคชั่นหรือไม่ ?",
                // ignore: deprecated_member_use
                rightButton: RaisedButton(
                  onPressed: () {
                    Future.delayed(Duration(seconds: 1), () => exit(0));
                  },
                  color: red,
                  child: Text(
                    'ตกลง',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                // ignore: deprecated_member_use
                leftButton: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: blue,
                  child: Text(
                    'ไม่',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            });
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: gray.withOpacity(0.3),
        body: GestureDetector(
          onTap: () =>
              SystemChannels.textInput.invokeListMethod('TextInput.hide'),
          child: body(
              context: context,
              formKey: formKey,
              textEditingControllerUser: _textEditingControllerUser,
              textEditingControllerPassword: _textEditingControllerPassword),
        ),
      ),
    );
  }
}
