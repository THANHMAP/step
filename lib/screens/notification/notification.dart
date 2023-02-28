import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/models/notification_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:intl/intl.dart';
import '../../models/navigator_reschedule.dart';
import '../../themes.dart';
import '../../util.dart';
import '../news/web_view_news.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late ProgressDialog pr;
  List<NotificationData>? dataListNotification;

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
      loadNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  text: "Thông báo",
                  onClicked: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 15, right: 15, bottom: 70),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          newsLayout(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  newsLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        children: [
          if (dataListNotification != null) ...[
            for (var i = 0; i < dataListNotification!.length; i++) ...[
              InkWell(
                onTap: () {
                  if (dataListNotification![i].type == "NEWS") {
                    loadDetailNew(
                        dataListNotification![i].data?.newId.toString() ?? "");
                    // Get.toNamed("/notificationNewScreen", arguments: dataListNotification![i].data?.newId);
                  } else if (dataListNotification![i].type ==
                      "REPAYMENT_SCHEDULE_TOOL") {
                    Get.toNamed("/editRepaymentScreen", arguments: NavigatorReschedule(1, dataListNotification![i].data?.userToolId.toString()));
                  }
                },
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 10),
                          child: Column(
                            children: [
                              Flexible(
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      dataListNotification?[i].title ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    )),
                              ),
                              Flexible(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        convert(dataListNotification?[i]
                                                .createdAt ??
                                            ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.color_82869E,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                        textAlign: TextAlign.left,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ],
      ),
    );
  }

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }

  Future<void> loadNotification() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.listNotificationURL).then(
        (value) async {
      await pr.hide();
      var notificationData = NotificationModel.fromJson(value);
      if (notificationData.statusCode == 200) {
        setState(() {
          dataListNotification = notificationData.data;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadDetailNew(String id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'new_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.newDetailURL, param).then(
        (value) async {
      await pr.hide();
      if (value["status_code"] == 200) {
        var data = NewsData.fromJson(value["data"]);
        pushNewScreen(
          context,
          screen: WebViewNewsScreen(url: data.linkDetail),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
