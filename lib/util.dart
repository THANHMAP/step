import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:step_bank/compoment/dialog_nomal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:step_bank/screens/login/authService.dart';
import 'package:step_bank/shared/SPref.dart';

class Utils {
  static showAlertDialogOneButton(BuildContext context, String message) {
    // set up the button
    BuildContext? dialogContext;
    Widget okButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(dialogContext!);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông Báo"),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        dialogContext = context;
        return alert;
      },
    );
  }

  static portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static showError(String error, BuildContext context) async {
    var statuscode = error.toString();
    if (statuscode.contains("Unauthorised:")) {
      var unauthorised = "Unauthorised:";
      var test = statuscode.substring(unauthorised.length, statuscode.length);
      var response = json.decode(test.toString());
      var statusCode = response["status_code"];
      var message = response["message"];
      if (statusCode == 500) {
        Utils.showAlertDialogOneButton(context, message);
      } else {
        await SPref.instance.set("token", "");
        await SPref.instance.set("info_login", "");
        Get.offAllNamed("/login"
            "");
      }
    } else if (statuscode.contains("Invalid_Request:")) {
      var unauthorised = "Invalid_Request:";
      var test = statuscode.substring(unauthorised.length, statuscode.length);
      var response = json.decode(test.toString());
      var message = response["message"];
      Utils.showAlertDialogOneButton(context, message);
    } else {
      print("Error == $error");
      Utils.showAlertDialogOneButton(context, error.toString());
    }
  }

  Future<void> _signOutWithGoogle(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signOut(context: context);
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  static bool isPhoneNoValid(String? check) {
    if (check == null) return false;
    final regExp = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
    return regExp.hasMatch(check);
  }

  // static showDialogNormal(BuildContext context, VoidCallback? onClicked) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //             onWillPop: () {
  //               return Future.value(false);
  //             },
  //             child: const NormalDialogBox(
  //               title: "Custom Dialog Demo",
  //               descriptions:
  //                   "Hii all this is a custom dialog in flutter and  you will be use in your flutter applications",
  //               text: "Yes",
  //             ));
  //       });
  // }
}
