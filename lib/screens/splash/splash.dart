import 'dart:ffi';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../constants.dart';
import '../../service/local_notification_service.dart';
import '../../service/new_version.dart';
import '../../themes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  var versionFireBase = "";
  var versionLocal = "";
  final RemoteConfig _remoteConfig = RemoteConfig.instance;
  Future<void> _initConfig() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 1), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
          10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();
  }

  // Fetching, caching, and activating remote config
  void _fetchConfig() async {
    await _remoteConfig.fetchAndActivate();
    versionFireBase = _remoteConfig.getString('version');
    print("test firebase version ${versionFireBase}");
  }

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // _initFirebaseMessaging() {
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) {
  //       print('AppPushs onMessage : $message');
  //       return;
  //     },
  //     onBackgroundMessage: Platform.isIOS ? null : myBackgroundMessageHandler,
  //     onResume: (Map<String, dynamic> message) {
  //       print('AppPushs onResume : $message');
  //       return;
  //     },
  //     onLaunch: (Map<String, dynamic> message) {
  //       print('AppPushs onLaunch : $message');
  //       return;
  //     },
  //   );
  // }

  @override
  void initState() {
    _initConfig();

    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   print(message);
    //   // if(message != null){
    //   //   Get.offAllNamed("/order");
    //   // }
    // });
    // FirebaseMessaging.onMessage.listen((event) {
    //   print('AppPushs onMessage : $event');
    //   if (event.notification != null) {
    //     print(event.notification!.body);
    //     print(event.notification!.title);
    //   }
    //   print(event);
    //   LocalNotificationService.display(event);
    // });


    final newVersion = NewVersion(
      iOSId: 'com.step.bank.step',
      androidId: 'com.step.bank.step_bank',
    );

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   final router = event.data["router"];
    //   print(router);
    // });

    getVersionLocal(newVersion);

    Future.delayed(const Duration(seconds: 2), () {
      advancedStatusCheck(newVersion);
    });

    super.initState();

  }

  getVersionLocal(NewVersion newVersion) async {
    versionLocal = await newVersion.getVersionLocal() ?? "";
    setState(() {
      versionLocal;
    });
  }

  advancedStatusCheck(NewVersion newVersion) async {
    try {
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
              allowDismissal: true,
              dismissButtonText: "Thoát",
              dismissAction: () {
                load();
              },
              updateButtonText: "Cập nhật",
              action: () {
                load();
              },
          );
        } else {
          load();
        }
        print("app version on Device " + "${status.localVersion}");
        print("app version on store " + "${status.storeVersion}");
      }
    } catch (e) {
      try {
        final status = await newVersion.getFirebaseVersion(versionFireBase);
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
                allowDismissal: true,
                dismissButtonText: "Thoát",
                dismissAction: () {
                  load();
                },
                updateButtonText: "Cập nhật");
          } else {
            load();
          }
          print("app version on Device " + "${status.localVersion}");
          print("app version on store " + "${status.storeVersion}");
        }
      } catch (e) {
        load();
      }
    }
  }

  void load() async {
    var isLoginFirst = await SPref.instance.getBoolValuesSF("loginFirst");
    if (isLoginFirst == null || isLoginFirst) {
      Constants.statusShowTutorial = true;
    } else {
      Constants.statusShowTutorial = false;
    }
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
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SvgPicture.asset("assets/svg/ic_logo.svg"),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, bottom: 10),
                    child: Text("V $versionLocal",
                      style: TextStyle(
                        fontSize: 15,),
                      ),
                  ),

                )
              ],
            ),
            // child: SvgPicture.asset("assets/svg/ic_logo.svg"),
          ), /* add child content here */
        ),
      ),
    );
  }
}
