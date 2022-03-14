import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';

class DetailEducationLessonScreen extends StatefulWidget {
  const DetailEducationLessonScreen({Key? key}) : super(key: key);

  @override
  _DetailEducationScreentate createState() => _DetailEducationScreentate();
}

class _DetailEducationScreentate extends State<DetailEducationLessonScreen> {
  late ProgressDialog pr;
  StudyData _studyData = Get.arguments;
  late CarouselSlider carouselSlider;
  int _current = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
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
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 70),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (_studyData.type == 4) ...[
                          typeVideo(),
                        ],
                        if (_studyData.type == 3) ...[
                          typeImage(),
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  typeVideo() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.name.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-SemiBold",
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.contentText.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ),
        SizedBox(
            width: double.infinity,
            height: 300,
            // the most important part of this example
            child: WebView(
              initialUrl: _studyData.fileScorm.toString(),
              // Enable Javascript on WebView
              javascriptMode: JavascriptMode.unrestricted,
            )),
        const SizedBox(height: 10),
      ]),
    );
  }

  typeImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.name.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-SemiBold",
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.contentText.toString(),
            style: const TextStyle(
              fontSize: 16,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ),
        carouselSlider = CarouselSlider(
          height: 400.0,
          initialPage: 0,
          enlargeCenterPage: false,
          autoPlay: false,
          reverse: false,
          enableInfiniteScroll: false,
          autoPlayInterval: Duration(seconds: 2),
          autoPlayAnimationDuration: Duration(milliseconds: 2000),
          pauseAutoPlayOnTouch: Duration(seconds: 10),
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              _current = index;
            });
          },
          items: _studyData.fileSlideShare?.map((imgUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            OutlineButton(
              onPressed: goToPrevious,
              child: Text("<"),
            ),
            OutlineButton(
              onPressed: goToNext,
              child: Text(">"),
            ),
          ],
        ),
      ]),
    );
  }

  goToPrevious() {
    carouselSlider.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    carouselSlider.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
  }

// Future<void> loadNews() async {
//   await pr.show();
//   APIManager.getAPICallNeedToken(RemoteServices.newsURL).then((value) async {
//     await pr.hide();
//     var news = NewsModel.fromJson(value);
//     if (news.statusCode == 200) {
//       setState(() {
//         newsList = news.data;
//       });
//     }
//   }, onError: (error) async {
//     await pr.hide();
//     Utils.showError(error.toString(), context);
//   });
// }
}
