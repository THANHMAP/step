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

class ForgotPassWordScreen extends StatefulWidget {
  const ForgotPassWordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPassWordScreenState createState() => _ForgotPassWordScreenState();
}

class _ForgotPassWordScreenState extends State<ForgotPassWordScreen> {
  final TextEditingController _phoneController = TextEditingController();
  late ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    _phoneController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              resizeToAvoidBottomInset : false,
              backgroundColor: Mytheme.kBackgroundColor,
              body: Column(
                children: <Widget>[
                  Expanded(
                    flex: 9,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppbarWidget(
                          text: StringText.text_restore_password,
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
                                  StringText.text_phone,
                                  textAlign: TextAlign.left,
                                  style: Mytheme.textSubTitle,
                                ),
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
                                    hintText: StringText.text_phone_input,
                                    // labelText: "Phone number",
                                    // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                    suffixIcon: Icons.close,
                                    clickSuffixIcon: () => _phoneController.clear(),
                                    textController: _phoneController),
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
                        padding: const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                // side: const BorderSide(color: Colors.red)
                              ),
                              primary: Mytheme.colorBgButtonLogin,
                              minimumSize: Size(MediaQuery.of(context).size.width,
                                  44)),
                          child: const Text(
                            StringText.text_get_otp,
                            style: TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            validatePhoneUser();
                          },
                        )
                    ),
                  ),
                ],
              ),
            )),
    );
  }

  Future<void> validatePhoneUser() async {
    String? phone;
    if (_phoneController.text.isNotEmpty &&
        _phoneController.text.length > 9 &&
        _phoneController.text.length < 12) {
      phone = _phoneController.text;
      var param = jsonEncode(<String, String>{'phone': phone, 'type': '2',});
      await pr.show();
      APIManager.postAPICallNoNeedToken(RemoteServices.validatePhoneURL, param)
          .then((value) async {
        if (value['status_code'] == 200) {
          getOtp(phone.toString());
        } else {
          await pr.hide();
          Utils.showAlertDialogOneButton(context, value['message'].toString());
        }
      }, onError: (error) async {
        await pr.hide();
        Utils.showError(error.toString(), context);
      });
    } else {
      Utils.showAlertDialogOneButton(
          context, "Vui lòng điền đúng dịnh dạng số điện thoại");
      // Get.snackbar("Thông báo", "Vui lòng điền đúng dịnh dạng số điện thoại");
    }
  }

  Future<void> getOtp(String phone) async {
    var param = jsonEncode(<String, String>{'phone': phone});
    APIManager.postAPICallNoNeedToken(RemoteServices.getOtpURL, param)
        .then((value) async {
      await pr.hide();
      if (value['status_code'] == 200) {
        Get.offAndToNamed('/otp', arguments: "forgot:$phone");
      } else {
        Utils.showAlertDialogOneButton(context, value['message'].toString());
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}
