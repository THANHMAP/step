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

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({Key? key, required this.newsData}) : super(key: key);

  final NewsData? newsData;

  @override
  Widget build(BuildContext context) {
    Utils.portraitModeOnly();
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
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
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 70),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child:  Text(
                                      newsData!.name!.toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-Semibold",
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),

                                  const SizedBox(height: 10),
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        convert(
                                            newsData?.createdAt!.toString() ?? ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.color_82869E,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                        textAlign: TextAlign.left,
                                      )),

                                  // newsLayout(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              child: Image.network(
                                newsData?.thumbnail ?? "",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 15, right: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Html(
                                    data: newsData?.content!.toString() ?? "",
                                  ),
                                  // Text(
                                  //   newsData?.content!.toString() ?? "",
                                  //   style: TextStyle(
                                  //     fontSize: 16,
                                  //     color: Mytheme.colorTextSubTitle,
                                  //     fontWeight: FontWeight.w400,
                                  //     fontFamily: "OpenSans-Regular",
                                  //   ),
                                  //   textAlign: TextAlign.left,
                                  // ),

                                  // newsLayout(),
                                ],
                              ),
                            ),
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

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }
}
