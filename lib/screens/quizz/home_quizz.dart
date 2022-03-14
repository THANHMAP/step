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
import 'package:step_bank/constants.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';

class HomeQuizScreen extends StatefulWidget {
  const HomeQuizScreen({Key? key}) : super(key: key);

  @override
  _HomeQuizScreenState createState() => _HomeQuizScreenState();
}

class _HomeQuizScreenState extends State<HomeQuizScreen> {
  List<ContentQuizz> contentQuizz = Get.arguments;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.colorBgMain,
          body: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_home_quiz.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: AppbarWidget(
                        text: "_lessonData.nameCourse",
                        onClicked: () => Get.back(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, left: 24, right: 24),
                              child: Image.asset(
                                  "assets/images/img_home_quiz.png"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, left: 24, right: 24),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        // side: const BorderSide(color: Colors.red)
                                      ),
                                      primary: Mytheme.colorBgButtonLogin,
                                      minimumSize: Size(
                                          MediaQuery.of(context).size.width,
                                          44)),
                                  child: const Text(
                                    "Bắt đầu",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "OpenSans-Regular",
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    Constants.questionsGlobals = contentQuizz;
                                     Get.toNamed('/quizScreen', arguments: contentQuizz);
                                  },
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ), /* add child content here */
            ),
          ),
        ));
  }
}
