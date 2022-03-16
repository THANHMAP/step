import 'dart:convert';
import 'package:step_bank/compoment/dialog_nomal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {
  static showAlertDialogOneButton(BuildContext context, String message) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Thoát"),
      onPressed: () {
        Navigator.pop(context);
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

  static showError(String error, BuildContext context) {
    var statuscode = error.toString();
    if (statuscode.contains("Unauthorised:")) {
      var unauthorised = "Unauthorised:";
      var test = statuscode.substring(unauthorised.length, statuscode.length);
      var response = json.decode(test.toString());
      var message = response["message"];
      Utils.showAlertDialogOneButton(context, message);
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
