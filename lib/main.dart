import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'app/app.dart';

// void _enablePlatformOverrideForDesktop() {
//   if (!kIsWeb && (Platform.isWindows || Platppform.isLinux)) {
//     debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
//   }
// }

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future main() async {
  // _enablePlatformOverrideForDesktop();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  Intl.defaultLocale = 'th';
  runApp(MyApp());
  // initializeDateFormatting().then((_) {

  // });
}
