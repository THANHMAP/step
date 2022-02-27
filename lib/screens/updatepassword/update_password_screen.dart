import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/dialog_nomal.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../themes.dart';
import '../../util.dart';

class UpdatePassWordScreen extends StatefulWidget {
  const UpdatePassWordScreen({Key? key}) : super(key: key);

  @override
  _UpdatePassWordScreenState createState() => _UpdatePassWordScreenState();
}

class _UpdatePassWordScreenState extends State<UpdatePassWordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool isPasswordVisible = true;
  bool isPasswordConfirmVisible = true;
  String title = "";
  String textButton = "";
  String phone = "";
  int typeScreen = 0;
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    if (Get.arguments.toString().contains("register:")) {
      typeScreen = 0;
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_create_password;
      textButton = StringText.text_register_button;
    } else {
      typeScreen = 1;
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_create_password_new;
      textButton = StringText.text_change_password;
    }

    _passwordController.addListener(() => setState(() {}));
    _passwordConfirmController.addListener(() => setState(() {}));
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
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              StringText.text_password,
                              textAlign: TextAlign.left,
                              style: Mytheme.textSubTitle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 46,
                            child: TextFieldWidget(
                                obscureText: isPasswordVisible,
                                hintText: StringText.text_password_input,
                                // labelText: 'Password',
                                // prefixIcon:
                                // const Icon(Icons.person, color: Colors.grey),
                                textInputAction: TextInputAction.done,
                                suffixIcon: isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                clickSuffixIcon: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                textController: _passwordController),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            // color: const Color(0xFFEFF0FB),
                            height: 88,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEFF0FB),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 9, left: 11, right: 11, bottom: 8),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      StringText.text_regestion_password_1,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.color_434657,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 44, right: 11, bottom: 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      StringText.text_regestion_password_2,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.color_434657,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 0, left: 44, right: 11, bottom: 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      StringText.text_regestion_password_3,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.color_434657,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              StringText.text_password_input_again,
                              textAlign: TextAlign.left,
                              style: Mytheme.textSubTitle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 46,
                            child: TextFieldWidget(
                                obscureText: isPasswordConfirmVisible,
                                hintText: StringText.text_password_input_again,
                                // labelText: 'Password',
                                // prefixIcon:
                                // const Icon(Icons.person, color: Colors.grey),
                                textInputAction: TextInputAction.done,
                                suffixIcon: isPasswordConfirmVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                clickSuffixIcon: () {
                                  setState(() {
                                    isPasswordConfirmVisible =
                                        !isPasswordConfirmVisible;
                                  });
                                },
                                textController: _passwordConfirmController),
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
                      child: Text(
                        textButton,
                        style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        doUpdate();
                        // Get.toNamed('/otp');
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  Future<void> signUp() async {
    String? password, passwordConfirm;
    if (_passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty) {
      await pr.show();
      password = _passwordController.text;
      passwordConfirm = _passwordConfirmController.text;
      var param = jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
        'password_confirm': passwordConfirm
      });
      if (password == passwordConfirm) {
        APIManager.postAPICallNoNeedToken(RemoteServices.signUpOTPURL, param)
            .then((value) async {
          await pr.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child:  NormalDialogBox(
                        descriptions: StringText.text_register_acc_success,
                        onClicked: () => switchToLogin()
                    ));
              });
        }, onError: (error) async {
          await pr.hide();
          Utils.showError(error.toString(), context);
        });
      } else {
        await pr.hide();
        Utils.showAlertDialogOneButton(
            context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
        // Get.snackbar("Thông báo", "Mật khẩu không giống nhau. Vui lòng nhập lại");
      }
    } else {
      Utils.showAlertDialogOneButton(
          context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
      // Get.snackbar("Thông báo", "Vui lòng điền đúng dịnh dạng số điện thoại");
    }
  }

  Future<void> updatePassword() async {
    String? password, passwordConfirm;
    if (_passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty) {
      await pr.show();
      password = _passwordController.text;
      passwordConfirm = _passwordConfirmController.text;
      var param = jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
        'password_confirm': passwordConfirm
      });
      if (password == passwordConfirm) {
        APIManager.postAPICallNoNeedToken(
                RemoteServices.forgotPasswordURL, param)
            .then((value) async {
          await pr.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child:  NormalDialogBox(
                      descriptions: StringText.text_change_password_success,
                      onClicked: () => switchToLogin()
                    ));
              });

        }, onError: (error) async {
          await pr.hide();
          Utils.showError(error.toString(), context);
        });
      } else {
        await pr.hide();
        Utils.showAlertDialogOneButton(
            context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
        // Get.snackbar("Thông báo", "Mật khẩu không giống nhau. Vui lòng nhập lại");
      }
    } else {
      Utils.showAlertDialogOneButton(
          context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
      // Get.snackbar("Thông báo", "Vui lòng điền đúng dịnh dạng số điện thoại");
    }
  }

  Future<void> doUpdate() async {
    if (typeScreen == 0) {
      signUp();
    } else {
      updatePassword();
    }
  }

  Future<void> switchToLogin() async {
    Get.offAllNamed("/login");
  }


}
