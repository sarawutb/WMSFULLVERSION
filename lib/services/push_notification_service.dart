import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:wms/routes/routes.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            // android: AndroidInitializationSettings("@mipmap/ic_launcher"));
            android: AndroidInitializationSettings("logowms"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.of(context).pushNamed(RouteName.routeNameLoginScreen);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final Int64List vibrationPattern = Int64List(4);
      vibrationPattern[0] = 0;
      // vibrationPattern[1] = 500;
      // vibrationPattern[2] = 2000;
      // vibrationPattern[3] = 5000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
              "WAREHOUSE MANAGEMENT SYSTEM V18", "แจ้งเตือนเอกสาร",
              channelDescription: "",
              playSound: true,
              ticker: 'ticker',
              // vibrationPattern:,
              vibrationPattern: vibrationPattern,
              largeIcon: DrawableResourceAndroidBitmap('logowms'),
              sound: RawResourceAndroidNotificationSound('sound'),
              importance: Importance.max,
              priority: Priority.high,
              color: const Color.fromARGB(255, 255, 255, 255),
              ledColor: const Color.fromARGB(0, 0, 0, 0),
              ledOnMs: 1000,
              timeoutAfter: 60000,
              autoCancel: true,
              ledOffMs: 500));

      await _notificationsPlugin.show(
        id,
        '${message.notification!.title}',
        message.notification!.body,
        notificationDetails,
        payload: message.data["route"],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}


// class PushNotificationService {
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   Future initialise() async {
//     if (Platform.isIOS) {
//       _fcm.requestNotificationPermissions(IosNotificationSettings());
//     }

//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }
// }