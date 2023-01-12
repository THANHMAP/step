import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:intl/intl.dart';
import '../../themes.dart';
import '../../util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NotificationNewScreen extends StatefulWidget {
  const NotificationNewScreen({Key? key}) : super(key: key);

  @override
  _NotificationNewScreenState createState() =>
      _NotificationNewScreenState();
}

class _NotificationNewScreenState extends State<NotificationNewScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  NewsData? newsData;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadDetailNew(Get.arguments.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Utils.portraitModeOnly();
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Mytheme.colorBgMain,
              body: Column(
                children: <Widget>[
                  AppbarWidget(
                    text: StringText.text_news_detail,
                    onClicked: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  Expanded(
                    child: WebView(
                      initialUrl: newsData?.linkDetail,
                      // Enable Javascript on WebView
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                  )
                ],
              ),
            )),
    );
  }

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }

  Future<void> loadDetailNew(String id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'new_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.newDetailURL, param).then((value) async {
      await pr.hide();
      if (value["status_code"] == 200) {
        print(value['data']);
        setState(() {
          newsData = NewsData.fromJson(value["data"]);
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}


