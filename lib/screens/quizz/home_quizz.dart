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
  StudyData _studyData = StudyData();
  List<ContentQuizz> contentQuizz = [];
  bool isFinish = false;
  late ProgressDialog pr;
  String textButton = "Bắt đầu";
  @override
  void initState() {
    super.initState();
    _studyData = Get.arguments;
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    contentQuizz = _studyData.contentQuizz!;
    Future.delayed(Duration.zero, () {
      checkQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
        child: GestureDetector(
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
                        flex: 2,
                        child: Container(
                          child: AppbarWidget(
                            text: Constants.nameCourseTemp,
                            onClicked: () => Get.back(),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Câu hỏi khảo sát",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      color: Mytheme.color_0xFF003A8C,
                                      fontFamily: "OpenSans-SemiBold",
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10, left: 44, right: 44),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Bộ đề gồm ${contentQuizz.length} câu. Bạn đã sẵn sàng trả lời câu hỏi và khảo sát chưa ?",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontFamily: "OpenSans-Regular",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
                                  child: Image.asset("assets/images/img_home_quiz.png"),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
                                  child: Column(
                                    children: [
                                      Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible: isFinish,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                                // side: const BorderSide(color: Colors.red)
                                              ),
                                              primary: Mytheme.colorBgButtonLogin,
                                              minimumSize: Size(MediaQuery.of(context).size.width, 44)),
                                          child: const Text(
                                            "Xem lại kết quả",
                                            style:
                                            TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            Get.offAndToNamed('/showQuizScreen', arguments: _studyData);
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 7),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                              // side: const BorderSide(color: Colors.red)
                                            ),
                                            primary: Mytheme.colorBgButtonLogin,
                                            minimumSize: Size(MediaQuery.of(context).size.width, 44)),
                                        child: Text(
                                          textButton,
                                          style: TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Get.offAndToNamed('/quizCustomScreen', arguments: _studyData);
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ), /* add child content here */
                ),
              ),
            )),
    );
  }

  Future<void> checkQuiz() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'study_part_id': _studyData.id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.checkQuizdURL, param).then((value) async {
      await pr.hide();
      if (value["status_code"] == 200) {
        setState(() {
          isFinish = value["data"]["is_finish"];
          if (isFinish) {
            textButton = "Làm lại";
          } else {
            textButton = "Bắt đầu";
          }
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
