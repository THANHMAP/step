import 'dart:ffi';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../service/local_notification_service.dart';
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
    LocalNotificationService.initNotification(context);
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message);
      // if(message != null){
      //   Get.offAllNamed("/order");
      // }
    });
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print(event.notification!.body);
        print(event.notification!.title);
      }
      print(event);
      LocalNotificationService.display(event);
      // if(event.data.containsKey("type")){
      //   var type = event.data["type"].toString();
      //   if(type == "MEDICINE"){
      //     LocalNotificationService.display(event);
      //   }
      // }
    });

    final newVersion = NewVersion(
      iOSId: 'com.step.bank.step',
      androidId: 'com.step.bank.step_bank',
    );

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      final router = event.data["router"];
      print(router);
    });

    Future.delayed(const Duration(seconds: 2), () {
      advancedStatusCheck(newVersion);
    });
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      if (status.canUpdate) {
        newVersion.showUpdateDialog(
            context: context,
            versionStatus: status,
            dialogTitle: "Cập nhật ứng dụng!!!",
            dialogText: "Vui lòng cập nhật ứng dụng từ version " +
                "${status.localVersion}" +
                " to " +
                "${status.storeVersion}",
            allowDismissal: false,
            dismissAction: () {
              SystemNavigator.pop();
            },
            updateButtonText: "Let's Update");
      } else {
        load();
      }
      print("app version on Device " + "${status.localVersion}");
      print("app version on store " + "${status.storeVersion}");
    }
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
          child: Center(
            child: SvgPicture.asset("assets/svg/ic_logo.svg"),
          ), /* add child content here */
        ),
      ),
    );
  }
}
