import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/dialog_nomal.dart';
import '../../compoment/textfield_widget.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
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

    _nameController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
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
                      text: StringText.text_report_title,
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
                              "Tên lỗi",
                              textAlign: TextAlign.left,
                              style: Mytheme.textSubTitle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: TextFieldWidget(
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
                                ],
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                hintText: "Tên lỗi",
                                // labelText: "Phone number",
                                // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                suffixIcon: Icons.close,
                                clickSuffixIcon: () => _nameController.clear(),
                                textController: _nameController),
                          ),
                          const SizedBox(height: 30),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Nội dung",
                              textAlign: TextAlign.left,
                              style: Mytheme.textSubTitle,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            child: TextFieldWidget(
                                keyboardType: TextInputType.text,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter
                                      .singleLineFormatter
                                ],
                                textInputAction: TextInputAction.done,
                                obscureText: false,
                                hintText: "Nội dung lỗi",
                                // labelText: "Phone number",
                                // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                suffixIcon: Icons.close,
                                clickSuffixIcon: () =>
                                    _contentController.clear(),
                                textController: _contentController),
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
                        "Gửi báo cáo lỗi",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        sendReport();
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  Future<void> sendReport() async {
    String? titleError, contentError;
    if (_nameController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      titleError = _nameController.text;
      contentError = _contentController.text;
      var param = jsonEncode(<String, String>{'name': titleError, 'content': contentError,});
      await pr.show();
      APIManager.postAPICallNeedToken(RemoteServices.reportErrorURL, param)
          .then((value) async {
        if (value['status_code'] == 200) {
          await pr.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child:  NormalDialogBox(
                        descriptions: StringText.text_report_success,
                        onClicked: () {
                            Get.back();
                        }
                    ));
              });
        } else {
          await pr.hide();
          Utils.showAlertDialogOneButton(context, value['message'].toString());
        }
      }, onError: (error) async {
        await pr.hide();
        Utils.showError(error.toString(), context);
      });
    } else {
      Utils.showAlertDialogOneButton(context, "Vui lòng điền dây dủ thông tin");
    }
  }
}
