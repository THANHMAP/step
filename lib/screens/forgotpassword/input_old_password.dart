import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/textfield_widget.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../themes.dart';
import '../../util.dart';

class InputOldPassWordScreen extends StatefulWidget {
  const InputOldPassWordScreen({Key? key}) : super(key: key);

  @override
  _InputOldPassWordScreenState createState() => _InputOldPassWordScreenState();
}

class _InputOldPassWordScreenState extends State<InputOldPassWordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;
  late ProgressDialog pr;
  String phone = "";
  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    phone = Get.arguments.toString();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
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
                          text: "Nhập mật khẩu cũ",
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
                                  "Nhập mật khẩu cũ",
                                  textAlign: TextAlign.left,
                                  style: Mytheme.textSubTitle,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 56,
                                child: TextFieldWidget(
                                    textAlign: true,
                                    maxLines: 1,
                                    obscureText: isPasswordVisible,
                                    hintText: "Nhập mật khẩu",
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
                            StringText.text_continue,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "OpenSans-Regular",
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            if(_passwordController.text.isNotEmpty) {
                              validatePassword(_passwordController.text);
                            } else {

                            }
                          },
                        )),
                  ),
                ],
              ),
            )),
    );
  }

  Future<void> validatePassword(String password) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'password': password,
    });
    APIManager.postAPICallNeedToken(RemoteServices.validatePasswordUserURL, param).then(
            (value) async {
          pr.hide();
          if (value['status_code'] == 200) {
            Get.offAndToNamed("/updateNewPassWordScreen");
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}
