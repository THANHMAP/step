// @dart=2.9


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:step_bank/router/AppPages.dart';
import 'package:step_bank/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      color: Colors.white,
      initialRoute: AppRoutes.intro,
      getPages: AppPages.listPage,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
    );
  }
}

