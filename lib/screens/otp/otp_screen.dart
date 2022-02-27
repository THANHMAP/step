import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../themes.dart';
import '../../util.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String title = "";
  String phone = "";
  late ProgressDialog pr;
  int typeScreen = 0;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    if (Get.arguments.toString().contains("register:")) {
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_authen_phone;
      typeScreen = 0;
    } else {
      typeScreen = 1;
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_restore_password;
    }
    _phoneController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.kBackgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppbarWidget(
                      text: title,
                      onClicked: () => Get.back(),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 24, right: 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                StringText.text_code_otp,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorTextSubTitle,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-Semibold",
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                              // di chuyen item tối cuối
                              const Spacer(),
                              TextButton(
                                  onPressed: () {
                                    getOtpAgain(phone);
                                  },
                                  child: const Text(
                                    StringText.text_get_code_otp_again,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Mytheme.colorBgButtonLogin,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "OpenSans-Regular",
                                      decoration: TextDecoration.underline,
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: TextFieldWidget(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                hintText: StringText.text_input_code_otp,
                                // labelText: "Phone number",
                                // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                suffixIcon: Icons.close,
                                clickSuffixIcon: () => _phoneController.clear(),
                                textController: _phoneController),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Image(
                                image:
                                    AssetImage('assets/images/icon_info.png'),
                                fit: BoxFit.fill,
                                width: 13,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  StringText.text_introduction_get_otp,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Mytheme.colorTextSubTitle,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans-Regular",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // side: const BorderSide(color: Colors.red)
                          ),
                          primary: Mytheme.colorBgButtonLogin,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 44)),
                      child: const Text(
                        StringText.text_continue,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        validateOtp(phone);
                        // Get.toNamed('/updatePassword');
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  // Future<void> getOtpAgain(String phone) async {
  //   await pr.show();
  //   RemoteServices.getOtpPhone(phone).then((value) async {
  //     await pr.hide();
  //     if (value.statusCode == 200) {
  //       Get.snackbar("Thông báo", "Mã OTP đã được gửi lại");
  //     } else {
  //       Get.snackbar("Thông báo", "${value.message}");
  //     }
  //   });
  // }

  Future<void> getOtpAgain(String phone) async {
    await pr.show();
    var param = jsonEncode(<String, String>{'phone': phone});
    APIManager.postAPICallNoNeedToken(RemoteServices.getOtpURL, param).then(
        (value) async {
      await pr.hide();
      if (value['status_code'] == 200) {
        Get.snackbar("Thông báo", "Mã OTP đã được gửi lại");
      } else {
        Utils.showAlertDialogOneButton(context, value['message'].toString());
      }
    }, onError: (error) async {
      await pr.hide();
      var statuscode = error.toString();
      if (statuscode.contains("Unauthorised:")) {
        var unauthorised = "Unauthorised:";
        var test = statuscode.substring(unauthorised.length, statuscode.length);
        var response = json.decode(test.toString());
        var message = response["message"];
        Utils.showAlertDialogOneButton(context, message);
      } else {
        print("Error == $error");
        Utils.showAlertDialogOneButton(context, error);
      }
    });
  }

  Future<void> validateOtp(String phone) async {
    String? otp;
    if (_phoneController.text.isNotEmpty) {
      otp = _phoneController.text;
      await pr.show();
      var param = jsonEncode(<String, String>{'phone': phone, 'otp': otp});
      APIManager.postAPICallNoNeedToken(RemoteServices.validateOTPURL, param)
          .then((value) async {
        await pr.hide();
        if (value['status_code'] == 200) {
          if (typeScreen == 0) {
            Get.toNamed('/updatePassword', arguments: "register:$phone");
          } else {
            Get.toNamed('/updatePassword', arguments: "forgot:$phone");
          }
        } else {
          Utils.showAlertDialogOneButton(context, value['message'].toString());
        }
      }, onError: (error) async {
        await pr.hide();
        var statuscode = error.toString();
        if (statuscode.contains("Unauthorised:")) {
          var unauthorised = "Unauthorised:";
          var test =
              statuscode.substring(unauthorised.length, statuscode.length);
          var response = json.decode(test.toString());
          var message = response["message"];
          Utils.showAlertDialogOneButton(context, message);
        } else {
          print("Error == $error");
          Utils.showAlertDialogOneButton(context, error);
        }
      });
    } else {
      Utils.showAlertDialogOneButton(context, "Vui lòng điền mã OTP");
    }
  }
}
