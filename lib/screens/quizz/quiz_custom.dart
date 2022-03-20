import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/constants.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/models/result.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../compoment/card_setting.dart';
import '../../compoment/question_card.dart';
import '../../controllers/question_controller.dart';
import '../../models/result_question.dart';
import '../../models/study_model.dart';
import '../../models/submit_quiz.dart';
import '../../themes.dart';
import '../../util.dart';

class QuizCustomScreen extends StatefulWidget {
  const QuizCustomScreen({Key? key}) : super(key: key);

  @override
  _QuizCustomScreenState createState() => _QuizCustomScreenState();
}

class _QuizCustomScreenState extends State<QuizCustomScreen> {
  var _studyData = Get.arguments;
  List<ContentQuizz> contentQuizz = [];
  int index = 0;
  int anserSelect = 10;
  bool checkQuestionStatus = false;
  bool statusButtonFinish = false;
  Answers _answers = Answers();
  List<Answers> _listAnswers = [];
  SubmitQuiz submitQuiz = SubmitQuiz();
  List<SubmitQuizData> listSubmitQuizData = [];
  int _numOfCorrectAns = 0;
  List<Question> listQuestion = [];
  String buttonNext = "Hoàn thành";

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    contentQuizz = _studyData.contentQuizz!;
    for(var i = 0; i < contentQuizz.length; i++) {
      contentQuizz[i].isAnswers = false;
      for(var ii =0; ii < contentQuizz[i].answers!.length; ii++) {
        contentQuizz[i].answers![ii].selectIsCorrect = 0;
        contentQuizz[i].answers![ii].isSelect = false;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    contentQuizz = [];
    index = 0;
    anserSelect = 10;
    checkQuestionStatus = false;
    statusButtonFinish = false;
    _answers = Answers();
    super.dispose();
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
                  Navigator.of(context).pop(true);
                },
              ),
              Expanded(
                flex: 11,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: Constants.kDefaultPadding,
                  ),
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Text(
                        "Câu ${index + 1}.${contentQuizz[index].questionText.toString()}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Mytheme.color_0xFF003A8C,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-SemiBold",
                        ),
                      ),
                      const SizedBox(height: Constants.kDefaultPadding / 2),
                      for (var i = 0;
                          i < contentQuizz[index].answers!.length;
                          i++) ...[
                        InkWell(
                          onTap: () {
                            setState(() {
                              statusButtonFinish = true;
                              if (contentQuizz[index].type == 1) {
                                for (var ii = 0;
                                    ii < contentQuizz[index].answers!.length;
                                    ii++) {
                                  contentQuizz[index].answers![ii].isSelect =
                                      false;
                                }
                                contentQuizz[index].answers![i].isSelect =
                                    !contentQuizz[index].answers![i].isSelect!;
                                _answers = contentQuizz[index].answers![i];
                              } else if (contentQuizz[index].type == 2) {
                                contentQuizz[index].answers![i].isSelect =
                                    !contentQuizz[index].answers![i].isSelect!;
                                if (contentQuizz[index].answers![i].isSelect ==
                                    true) {
                                  _listAnswers
                                      .add(contentQuizz[index].answers![i]);
                                } else {
                                  _listAnswers
                                      .remove(contentQuizz[index].answers![i]);
                                }
                              }
                              contentQuizz;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                                top: Constants.kDefaultPadding),
                            padding:
                                const EdgeInsets.all(Constants.kDefaultPadding),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border: Border.all(
                                  color: getTheRightColor(checkQuestionStatus,
                                      contentQuizz[index].answers![i])),
                              color: getTheRightColorForBg(checkQuestionStatus,
                                  contentQuizz[index].answers![i]),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SvgPicture.asset(anserSelect == i
                                    ? "assets/svg/ic_radio_no_select.svg"
                                    : "assets/svg/ic_radio_no_select.svg"),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, left: 10, right: 0),
                                    child: Text(
                                      "${i + 1}. ${contentQuizz[index].answers![i].answerText}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorBgButtonLogin,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: anserSelect == i
                                        ? Constants.kGreenColor
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: getColorCircle(
                                            checkQuestionStatus,
                                            contentQuizz[index].answers![i])),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Icon(
                                      getTheRightIcon(checkQuestionStatus,
                                          contentQuizz[index].answers![i]),
                                      size: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: checkQuestionStatus,
                        child: Text(
                          "Giải thích: ${contentQuizz[index].suggest.toString()}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Mytheme.color_82869E,
                            fontWeight: FontWeight.w400,
                            fontFamily: "OpenSans-Regular",
                          ),
                        ),
                      ),
                    ],
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
                                      setState(() {
                                        if (index > 0) {
                                          index = index - 1;
                                        }
                                        if (checkQuestionAnswersed() == true) {
                                          checkQuestionStatus = true;
                                          statusButtonFinish = true;
                                        } else {
                                          statusButtonFinish = false;
                                          checkQuestionStatus = false;
                                        }
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
                                        primary: statusButtonFinish == false
                                            ? Mytheme.color_DCDEE9
                                            : Mytheme.colorBgButtonLogin,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            44)),
                                    child: Text(
                                      buttonNext,
                                      style: TextStyle(
                                          color: statusButtonFinish == false
                                              ? Mytheme.color_0xFFA7ABC3
                                              : Mytheme.kBackgroundColor,
                                          fontSize: 16,
                                          fontFamily: "OpenSans-SemiBold",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (statusButtonFinish) {
                                          if (checkQuestionAnswersed() ==
                                              false) {
                                            if (contentQuizz[index].type == 1) {
                                              checkQuestion();
                                            } else {
                                              checkQuestionMutil();
                                            }
                                            buttonNext = "Tiếp tục";
                                            return;
                                          } else {
                                            if (index == contentQuizz.length - 1) {
                                              Result _dataResult = Result();
                                              _dataResult.result = finish();
                                              _dataResult.numOfCorrectAns = _numOfCorrectAns;
                                              _dataResult.listQuestion = listQuestion;
                                              Get.offAndToNamed("/resultQuizScreen", arguments: _dataResult);
                                              return;
                                            } else {
                                              buttonNext = "Hoàn thành";
                                              index = index + 1;
                                              if (checkQuestionAnswersed() ==
                                                  true) {
                                                checkQuestionStatus = true;
                                                statusButtonFinish = true;
                                              } else {
                                                statusButtonFinish = false;
                                                checkQuestionStatus = false;
                                              }
                                            }
                                          }
                                        }
                                      });
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

  void checkQuestion() {
    var data = contentQuizz[index].answers;
    var isCorrect = false;
    for (var i = 0; i < data!.length; i++) {
      if (contentQuizz[index].answers![i].id == _answers.id) {
        contentQuizz[index].isAnswers = true;
        if (_answers.isCorrect == 1) {
          _numOfCorrectAns++;
          contentQuizz[index].answers![i].selectIsCorrect = 2;
        } else {
          contentQuizz[index].answers![i].selectIsCorrect = 1;
        }
      } else if (data[i].isCorrect == 1) {
        contentQuizz[index].answers![i].selectIsCorrect = 2;
      }
    }
    SubmitQuizData submitQuizData = SubmitQuizData();
    submitQuizData.questionId = contentQuizz[index].id;
    DataAnswer dataAnswer = DataAnswer();
    dataAnswer.answerId = _answers.id;
    if (_answers.isCorrect == 1) {
      dataAnswer.isCorrect = true;
      isCorrect = true;
    } else {
      dataAnswer.isCorrect = false;
      isCorrect = false;
    }
    List<DataAnswer> listDataAnswer = [];
    listDataAnswer.add(dataAnswer);
    submitQuizData.dataAnswer = listDataAnswer;
    listSubmitQuizData.add(submitQuizData);
    listQuestion.add(Question(
      isCorrect: isCorrect,
      id: _answers.id
    ));
    setState(() {
      checkQuestionStatus = true;
      contentQuizz;
    });
  }

  void checkQuestionMutil() {
    var data = contentQuizz[index].answers;
    var status = true;
    for (var i = 0; i < data!.length; i++) {
      for (var ii = 0; ii < _listAnswers.length; ii++) {
        if (data[i].id == _listAnswers[ii].id) {
          contentQuizz[index].isAnswers = true;
          if (_listAnswers[ii].isCorrect == 1) {
            data[i].selectIsCorrect = 2;
          } else {
            data[i].selectIsCorrect = 1;
          }
        } else if (data[i].isCorrect == 1) {
          contentQuizz[index].answers![i].selectIsCorrect = 2;
        }
      }
    }
    for(var i = 0; i < _listAnswers.length; i++) {
      if(_listAnswers[i].selectIsCorrect == 1) {
        status = false;
        break;
      }
    }
    if(status == true)  _numOfCorrectAns++;
    SubmitQuizData submitQuizData = SubmitQuizData();
    submitQuizData.questionId = contentQuizz[index].id;
    List<DataAnswer> listDataAnswer = [];
    for(var i = 0; i < _listAnswers.length; i++) {
      DataAnswer dataAnswer = DataAnswer();
      dataAnswer.answerId = _listAnswers[i].id;
      if (_listAnswers[i].selectIsCorrect == 2) {
        dataAnswer.isCorrect = true;
      } else {
        dataAnswer.isCorrect = false;
      }
      listDataAnswer.add(dataAnswer);
    }
    submitQuizData.dataAnswer = listDataAnswer;
    listSubmitQuizData.add(submitQuizData);
    listQuestion.add(Question(
        isCorrect: status,
        id: _answers.id
    ));
    setState(() {
      checkQuestionStatus = true;
      contentQuizz;
    });
  }

  Color getTheRightColor(bool checkQuestion, Answers answers) {
    if (!checkQuestion) {
      if (answers.isSelect == true) {
        return Mytheme.color_0xFFCCECFB;
      } else {
        return Mytheme.kBackgroundColor;
      }
    } else {
      if (answers.selectIsCorrect == 2) {
        return Mytheme.color_0xFF30CD60;
      } else if (answers.selectIsCorrect == 1) {
        return Mytheme.kRedColor;
      }
    }
    return Mytheme.kBackgroundColor;
  }

  Color getTheRightColorForBg(bool checkQuestion, Answers answers) {
    if (!checkQuestion) {
      if (answers.isSelect == true) {
        return Mytheme.color_0xFFCCECFB;
      } else {
        return Mytheme.kBackgroundColor;
      }
    } else {
      return Mytheme.kBackgroundColor;
    }
    return Mytheme.kBackgroundColor;
  }

  bool? checkQuestionAnswersed() {
    return contentQuizz[index].isAnswers;
  }

  Color getColorCircle(bool checkQuestion, Answers answers) {
    if (getTheRightColor(checkQuestion, answers) == Mytheme.kRedColor) {
      return Constants.kRedColor;
    } else if (getTheRightColor(checkQuestion, answers) ==
        Mytheme.color_0xFF30CD60) {
      return Constants.kGreenColor;
    }
    return Colors.transparent;
    return Mytheme.kBackgroundColor;
  }

  IconData? getTheRightIcon(bool checkQuestion, Answers answers) {
    if (getTheRightColor(checkQuestion, answers) == Mytheme.kRedColor) {
      return Icons.close;
    } else if (getTheRightColor(checkQuestion, answers) ==
        Mytheme.color_0xFF30CD60) {
      return Icons.done;
    }
    return null;
  }

  String finish() {
    submitQuiz.studyPartId = _studyData.id;
    submitQuiz.totalCorrect = _numOfCorrectAns;
    submitQuiz.data = listSubmitQuizData;
    return jsonEncode(submitQuiz);

  }

}
