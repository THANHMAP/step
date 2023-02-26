import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {

  static final FlutterLocalNotificationsPlugin _noticationPlugin =   FlutterLocalNotificationsPlugin();
  static late BuildContext myContext;
  static Future<void> initNotification(BuildContext context) async {
    myContext = context;
    var initAndroid = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = const IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initSetting = InitializationSettings(android: initAndroid,iOS: initIOS);
    _noticationPlugin.initialize(initSetting, onSelectNotification: handleClickNotification);
  }

  static Future<dynamic> handleClickNotification(message) async {
    print("handleClickNotification: ${message.toString()}");
    Get.toNamed("/notificationScreen");
  }

  static Future onDidReceiveLocalNotification(int? id,String? title,String? body, String? payload) async {
    showDialog(context: myContext, builder: (context) => CupertinoAlertDialog(

      title: Text(title!),
      content: Text(body!),

      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("OK"),
          onPressed:   () => Navigator.of(context,rootNavigator: true).pop(),
        )
      ],)
    );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("appdrug", "appdrug channel",
              importance: Importance.max, priority: Priority.high));

      await _noticationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails, payload: message.notification!.body); //, payload: message.data["type"]
    } on Exception catch (e) {
      print(e);
    }
  }

}