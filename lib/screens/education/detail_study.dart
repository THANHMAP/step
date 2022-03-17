import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
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
  late CarouselSlider carouselSlider = CarouselSlider();
  int activePage = 0;
  late PageController _pageController;
  List<String> fileSlideShare = [];

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
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    if(_studyData.fileSlideShare != null){
      fileSlideShare = _studyData.fileSlideShare!;
    }

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
                text: _studyData.nameCourse,
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
          child: Html(
            data: _studyData.contentText.toString(),
          ),
        ),

        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 300,
          child: PageView.builder(
              itemCount: fileSlideShare.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return slider(fileSlideShare,pagePosition,active);
              }),
        ),

        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset("assets/svg/ic_pre.svg"),
              // tooltip: 'Increase volume by 10',
              iconSize: 50,
              onPressed: goToPrevious,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${activePage+1}/${fileSlideShare.length}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Mytheme.colorBgButtonLogin,
                  fontWeight: FontWeight.w600,
                  fontFamily: "OpenSans-SemiBold",
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset("assets/svg/ic_next.svg"),
              // tooltip: 'Increase volume by 10',
              iconSize: 50,
              onPressed: goToNext,
            ),
            // OutlineButton(
            //   onPressed: goToNext,
            //   child: Text(">"),
            // ),
          ],
        ),
      ]),
    );
  }

  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(images[pagePosition].toString()))),
    );
  }

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  goToPrevious() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    _pageController.nextPage(
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
