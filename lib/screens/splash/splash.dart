import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      load();
    });
  }

  void load() async {
    var isLogged = await SPref.instance.get("token");
    if (isLogged != null && isLogged.toString().isNotEmpty) {
      Get.offAndToNamed('/home');
      return;
    } else {
      Get.offAndToNamed('/login');
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: Mytheme.kYellowColor,
      body: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/img_background_splash.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: null /* add child content here */,
        ),
      ),
    );
  }
}
