import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/faq_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/dialog_nomal.dart';
import '../../compoment/textfield_widget.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class TermScreen extends StatefulWidget {
  const TermScreen({Key? key}) : super(key: key);

  @override
  _TermScreenState createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppbarWidget(
                      text: "CÁC ĐIỀU KHOẢN VÀ ĐIỀU KIỆN",
                      onClicked: () => Get.back(),
                    ),
                    Expanded(
                      child:  WebView(
                        initialUrl: 'https://co-opsmart.vn/term/',
                        // Enable Javascript on WebView
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ));
  }

}