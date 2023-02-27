import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _noticationPlugin =
      FlutterLocalNotificationsPlugin();
  static late BuildContext myContext;

  static Future<void> initNotification() async {
    var initAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);
    _noticationPlugin.initialize(initSetting);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print("Handling a background message: ${message.messageId}");
  }

  static Future<dynamic> handleClickNotification(message) async {
    print("handleClickNotification: ${message.toString()}");
    var result = message.toString().contains(":");
    if (result) {
      var data = message.toString().split(":");
      var type = data[0].toString();
      var id = data[1].toString();
      if (type == "NEWS") {
      } else if (type == "LESSONS_UPDATE") {
      } else if (type == "REMIND_SAVING_TOOL") {}
    } else {
      var type = message.toString();
      if (type == "REMIND_LOGIN") {
      } else if (type == "UPDATE_ACCOUNT") {
        Get.toNamed('/editProfile');
      }
    }
  }

  static Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    showDialog(
        context: myContext,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title!),
              content: Text(body!),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("OK"),
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: true).pop(),
                )
              ],
            ));
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("StepAppChannel", "StepAppChannel",
              importance: Importance.max, priority: Priority.high));
      var type = message.data["type"];
      if (type == "NEWS") {
        type = type + ":${message.data["new_id"]}";
      } else if (type == "LESSONS_UPDATE") {
        type = type + ":${message.data["course_id"]}";
      } else if (type == "REMIND_SAVING_TOOL") {
        type = type + ":${message.data["user_tool_id"]}";
      }

      await _noticationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: type); //, payload: message.data["type"]
    } on Exception catch (e) {
      print(e);
    }
  }

  // static void createanddisplaynotification(RemoteMessage message) async {
  //   try {
  //     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //     const NotificationDetails notificationDetails = NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         "pushnotificationapp",
  //         "pushnotificationappchannel",
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     );
  //
  //     await _notificationsPlugin.show(
  //       id,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //       payload: message.data['_id'],
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }

  String getTypeNotify(RemoteMessage message) {
    var type = message.data["type"];
    if (type == "NEWS") {
      return type + ":${message.data["new_id"]}";
    } else if (type == "REMIND_LOGIN") {
      return type;
    } else if (type == "UPDATE_ACCOUNT") {
      return type;
    } else if (type == "LESSONS_UPDATE") {
      return type + ":${message.data["course_id"]}";
    } else if (type == "REMIND_SAVING_TOOL") {
      return type + ":${message.data["user_tool_id"]}";
    }
    return type;
  }
}
