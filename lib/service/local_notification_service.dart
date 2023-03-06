import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../screens/news/web_view_news.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _noticationPlugin =
      FlutterLocalNotificationsPlugin();
  static late BuildContext myContext;

  static Future<void> initNotification(BuildContext context) async {
    myContext = context;
    var initAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var initIOS = const IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification
    );
    var initSetting =
        InitializationSettings(android: initAndroid, iOS: initIOS);
    _noticationPlugin.initialize(initSetting,
        onSelectNotification: handleClickNotification);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print("Handling a background message: ${message.messageId}");
  }

  static Future<dynamic> handleClickNotification(message) async {
    print("handleClickNotification: ${message.toString()}");
    var result = message.toString().contains(":::");
    if (result) {
      var data = message.toString().split(":::");
      var type = data[0].toString();
      var id = data[1].toString();
      if (type == "NEWS") {
        Get.toNamed('/notificationNewsScreen',
            arguments: id);
      } else if (type == "LESSONS_UPDATE") {
        Get.toNamed('/educationTopic',
            arguments: id);
      } else if (type == "REMIND_SAVING_TOOL") {
        Get.toNamed("/manageSaveToolScreen",
            arguments: id);
      } else if (type == "REMIND_COMPLETE_LESSON") {
        Get.toNamed('/educationTopic',
            arguments: id);
      }
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
      print("payload");
  }

  static void handelClickOpenApp(RemoteMessage message) {
    var type = message.data["type"];
    if (type == "NEWS") {
      type = type + ":::${message.data["id"]}";
    } else if (type == "LESSONS_UPDATE") {
      type = type + ":::${message.data["id"]}";
    } else if (type == "REMIND_SAVING_TOOL") {
      type = type + ":::${message.data["id"]}";
    } else if (type == "REMIND_COMPLETE_LESSON") {
      type = type + ":::${message.data["id"]}";
    }
    handleClickNotification(type);
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails("appdrug", "appdrug channel",
              importance: Importance.max, priority: Priority.high),
        iOS: IOSNotificationDetails(),
      );
      var type = message.data["type"];
      if (type == "NEWS") {
        type = type + ":::${message.data["id"]}";
      } else if (type == "LESSONS_UPDATE") {
        type = type + ":::${message.data["id"]}";
      } else if (type == "REMIND_SAVING_TOOL") {
        type = type + ":::${message.data["id"]}";
      } else if (type == "REMIND_COMPLETE_LESSON") {
        type = type + ":::${message.data["id"]}";
      }

      await _noticationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetails,
          payload: type); //, payload: message.data["type"]
    } on Exception catch (e) {
      print(e);
    }
  }

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
