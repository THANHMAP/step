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

import '../../compoment/card_setting.dart';
import '../../compoment/question_card.dart';
import '../../controllers/question_controller.dart';
import '../../models/result_question.dart';
import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final StudyData _studyData = Get.arguments;
  List<ContentQuizz> contentQuizz = [];
  late ResultQuestion resultQuestion;
  late int indexQuestion;

  int index = 0;
  QuestionController _questionController = Get.put(QuestionController());
  String buttonNext = "Tiếp Tục";
  bool isDisable = true;
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
    contentQuizz = _studyData.contentQuizz!;
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
              AppbarWidget(
                text: _studyData.nameCourse,
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                flex: 11,
                child: PageView.builder(
                  // Block swipe to next qn
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questionController.questions?.length,
                  itemBuilder: (context, index) => QuestionCard(
                    indexQuestion: index,
                    question: _questionController.questions![index],
                    callback: (bool) {
                      Future.delayed(Duration.zero, () async {
                        setState(() {
                          isDisable = bool;
                        });
                      });
                    },
                    calbackQuestion: (int indexQuestion) {
                      this.indexQuestion = indexQuestion;
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: Mytheme.kBackgroundColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 0, left: 0, right: 0),
                    child: Column(
                      children: [
                        const Align(
                          child: Image(
                            image: AssetImage(
                                'assets/images/img_line_horizone.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 0, left: 16, right: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            side: const BorderSide(
                                                color: Mytheme
                                                    .colorBgButtonLogin)),
                                        primary: Mytheme.kBackgroundColor,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            44)),
                                    child: const Text(
                                      "Trở về",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorBgButtonLogin,
                                          fontFamily: "OpenSans-SemiBold",
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                      _questionController.preQuestion();
                                      setState(() {
                                        buttonNext = "Tiếp tục";
                                      });
                                    },
                                  )),
                              SizedBox(
                                height: 100,
                                width: 30,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          // side: const BorderSide(color: Colors.red)
                                        ),
                                        primary: isDisable
                                            ? Mytheme.color_DCDEE9
                                            : Mytheme.colorBgButtonLogin,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            44)),
                                    child: Text(
                                      buttonNext,
                                      style: TextStyle(
                                          color: isDisable
                                              ? Mytheme.color_0xFFA7ABC3
                                              : Mytheme.kBackgroundColor,
                                          fontSize: 16,
                                          fontFamily: "OpenSans-SemiBold",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      if (!isDisable) {
                                        if (!_questionController.checkAnswerd(indexQuestion)) {

                                        }
                                        _questionController.nextQuestion();
                                        setState(() {
                                          isDisable = true;
                                        });
                                        if (_questionController
                                                .questionNumber.value ==
                                            contentQuizz.length - 1) {
                                          setState(() {
                                            buttonNext = "Hoàn thành";
                                          });
                                        }
                                      }

                                      print(
                                          "testttttt ${_questionController.questionNumber}");
                                    },
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> loadListExercise() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'study_part_id': _studyData.id.toString(),
      'question_id': "",
      'answer_id': "",
      'is_correct': '',
      'total_correct': '',
    });
    APIManager.postAPICallNeedToken(RemoteServices.submitQuizURL, param).then(
        (value) async {
      await pr.hide();
      if (value.statusCode == 200) {
        setState(() {});
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
