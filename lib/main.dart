// @dart=2.9


import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:step_bank/router/AppPages.dart';
import 'package:step_bank/router/app_router.dart';
import 'package:step_bank/screens/login/authService.dart';
import 'package:step_bank/screens/test.dart';

Future<void> backgroundHandler(RemoteMessage message) async{
  print(message.data.toString());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.getToken().then((value) {
    print("token fcm: $value");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthService>(
      create: (_) => AuthService(),
      child: GetMaterialApp(
        color: Colors.white,
        initialRoute: AppRoutes.intro,
        getPages: AppPages.listPage,
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
      ),
    );
  }
}

