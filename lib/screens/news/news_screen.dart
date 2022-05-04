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
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:intl/intl.dart';
import '../../themes.dart';
import '../../util.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late ProgressDialog pr;
  List<NewsData>? newsList;

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
      loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.colorBgMain,
          body: Column(
            children: <Widget>[
              AppbarWidget(
                text: StringText.text_news,
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 70),
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
        ));
  }

  newsLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Container(
          //       alignment: Alignment.center,
          //       margin: EdgeInsets.all(10),
          //       height: 40,
          //       width: 73,
          //       decoration: BoxDecoration(
          //         color: Mytheme.color_BCBFD6,
          //         borderRadius: BorderRadius.circular(8),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Colors.grey.withOpacity(0.5), //color of shadow
          //             spreadRadius: 1, //spread radius
          //             blurRadius: 7, // blur radius
          //             offset: Offset(0, 3), // changes position of shadow
          //             //first paramerter of offset is left-right
          //             //second parameter is top to down
          //           ),
          //           //you can set more BoxShadow() here
          //         ],
          //       ),
          //       child: Text(
          //         StringText.text_all,
          //         style: TextStyle(
          //           fontSize: 16,
          //           color: Mytheme.color_434657,
          //           fontWeight: FontWeight.w600,
          //           fontFamily: "OpenSans-Semibold",
          //         ),
          //       ),
          //     ),
          //     // Container(
          //     //   alignment: Alignment.center,
          //     //   margin: EdgeInsets.all(10),
          //     //   height: 40,
          //     //   width: 101,
          //     //   decoration: BoxDecoration(
          //     //     color: Colors.white,
          //     //     borderRadius: BorderRadius.circular(8),
          //     //     boxShadow: [
          //     //       BoxShadow(
          //     //         color: Colors.grey.withOpacity(0.5), //color of shadow
          //     //         spreadRadius: 1, //spread radius
          //     //         blurRadius: 7, // blur radius
          //     //         offset: Offset(0, 3), // changes position of shadow
          //     //         //first paramerter of offset is left-right
          //     //         //second parameter is top to down
          //     //       ),
          //     //       //you can set more BoxShadow() here
          //     //     ],
          //     //   ),
          //     //   child: Text(
          //     //     StringText.text_not_read,
          //     //     style: TextStyle(
          //     //       fontSize: 16,
          //     //       color: Mytheme.color_434657,
          //     //       fontWeight: FontWeight.w600,
          //     //       fontFamily: "OpenSans-Semibold",
          //     //     ),
          //     //   ),
          //     // ),
          //   ],
          // ),
          // const SizedBox(height: 10),
          if (newsList != null) ...[
            for (var i = 0; i < newsList!.length; i++) ...[
              InkWell(
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: NewsDetailScreen(newsData: newsList![i]),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  // Get.toNamed('/newsDetail', arguments: newsList![i]);
                },
                child: Container(
                  height: 106,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Image.network(
                            newsList?[i].thumbnail ?? "",
                            fit: BoxFit.fill,
                            width: 128,
                            height: 106,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 20, right: 10),
                          child: Column(
                            children: [
                              Flexible(
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      newsList?[i].name ?? "",
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
                              const SizedBox(height: 10),
                              Flexible(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        convert(newsList?[i].createdAt ?? ""),
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

  Future<void> loadNews() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.newsURL).then((value) async {
      await pr.hide();
      var news = NewsModel.fromJson(value);
      if (news.statusCode == 200) {
        setState(() {
          newsList = news.data;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
