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
import 'package:step_bank/screens/quizz/quiz_custom.dart';
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
import 'quiz_custom.dart';

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
  List<QuestionDrap> listAnswersDragg = [];
  SubmitQuiz submitQuiz = SubmitQuiz();
  List<SubmitQuizData> listSubmitQuizData = [];
  int _numOfCorrectAns = 0;
  List<Question> listQuestion = [];
  String buttonNext = "Hoàn thành";

  List<StoreQuestionDrap> listStoreQuestionDrap = [];

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    contentQuizz = _studyData.contentQuizz!;
    for (var i = 0; i < contentQuizz.length; i++) {
      contentQuizz[i].isAnswers = false;
      for (var ii = 0; ii < contentQuizz[i].answers!.length; ii++) {
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
                text: Constants.nameCourseTemp,
                onClicked: () {
                  Navigator.of(context).pop(true);
                },
              ),
              Expanded(
                flex: 11,
                child: SingleChildScrollView(
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
                        if (contentQuizz[index].type == 3) ...[
                          Container(
                            margin: const EdgeInsets.only(
                                top: Constants.kDefaultPadding),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (var i = 0;
                                    i < contentQuizz[index].answers!.length;
                                    i++) ...[
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (checkQuestionAnswersed() == true)
                                              return;
                                            statusButtonFinish = true;
                                            for (var ii = 0;
                                            ii <
                                                contentQuizz[index]
                                                    .answers!
                                                    .length;
                                            ii++) {
                                              contentQuizz[index]
                                                  .answers![ii]
                                                  .isSelect = false;
                                            }
                                            contentQuizz[index]
                                                .answers![i]
                                                .isSelect =
                                            !contentQuizz[index]
                                                .answers![i]
                                                .isSelect!;
                                            _answers =
                                            contentQuizz[index].answers![i];
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 0, left: 0, right: 10),
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: getTheRightColorType3(
                                                    checkQuestionStatus,
                                                    contentQuizz[index]
                                                        .answers![i]),
                                                width: 1,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              color: getTheRightColorForBg(
                                                  checkQuestionStatus,
                                                  contentQuizz[index]
                                                      .answers![i]),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 1,
                                                  blurRadius: 7,
                                                  offset: const Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(urlIconType3(
                                                    checkQuestionStatus,
                                                    i,
                                                    contentQuizz[index]
                                                        .answers![i]
                                                        .isCorrect ??
                                                        0)),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  contentQuizz[index]
                                                      .answers![i]
                                                      .answerText ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Mytheme
                                                        .colorBgButtonLogin,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily:
                                                    "OpenSans-Semibold",
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                              ],
                            ),
                          ),
                        ] else if (contentQuizz[index].type == 4) ...[
                          Container(
                            margin: const EdgeInsets.only(
                                top: Constants.kDefaultPadding),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    for (var i = 0;
                                    i < contentQuizz[index].answers!.length;
                                    i++) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 0, left: 0, right: 10),
                                        child: Draggable<Answers>(
                                          maxSimultaneousDrags:
                                          contentQuizz[index]
                                              .answers![i]
                                              .isSelect ==
                                              true
                                              ? 0
                                              : 1,
                                          data: contentQuizz[index].answers![i],
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            decoration: contentQuizz[index]
                                                .answers![i]
                                                .isSelect ==
                                                false
                                                ? BoxDecoration(
                                                border: Border.all(
                                                  color: Mytheme
                                                      .color_0xFFA7ABC3,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                color: Colors.white)
                                                : BoxDecoration(
                                                color: Colors.white),
                                            child: contentQuizz[index]
                                                .answers![i]
                                                .isSelect ==
                                                false
                                                ? Image.network(
                                              contentQuizz[index]
                                                  .answers![i]
                                                  .answerFile ??
                                                  "",
                                              fit: BoxFit.fill,
                                              width: 50,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                  loadingProgress) {
                                                if (loadingProgress ==
                                                    null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    value: loadingProgress
                                                        .expectedTotalBytes !=
                                                        null
                                                        ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )
                                                : Container(
                                              width: 80,
                                              height: 80,
                                              child: SvgPicture.asset(
                                                  "assets/svg/border_drap.svg"),
                                            ),
                                          ),
                                          feedback: Container(
                                            width: 80,
                                            height: 80,
                                            child: contentQuizz[index]
                                                .answers![i]
                                                .isSelect ==
                                                false
                                                ? Image.network(
                                              contentQuizz[index]
                                                  .answers![i]
                                                  .answerFile ??
                                                  "",
                                              fit: BoxFit.fill,
                                              width: 50,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                  loadingProgress) {
                                                if (loadingProgress ==
                                                    null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child:
                                                  CircularProgressIndicator(
                                                    value: loadingProgress
                                                        .expectedTotalBytes !=
                                                        null
                                                        ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                            )
                                                : Container(
                                              width: 80,
                                              height: 80,
                                              child: SvgPicture.asset(
                                                  "assets/svg/border_drap.svg"),
                                            ),
                                          ),
                                          childWhenDragging: Container(
                                            width: 80,
                                            height: 80,
                                            child: SvgPicture.asset(
                                                "assets/svg/border_drap.svg"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height * 0.1,
                                ),
                                Row(
                                  children: [
                                    for (var i = 0;
                                    i < listAnswersDragg.length;
                                    i++) ...[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 0, left: 0, right: 10),
                                        child: DragTarget<Answers>(
                                          builder: (context, accepted, rejected) {
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: getTheRightColorBorderType4(
                                                        checkQuestionStatus,
                                                        listAnswersDragg[i]
                                                            .selectIsCorrect ??
                                                            0),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  color:
                                                  Mytheme.kBackgroundColor),
                                              child: Stack(
                                                children: [
                                                  listAnswersDragg[i].isSelect == true ? Image.network(
                                                    listAnswersDragg[i].answerFileTemp ?? "",
                                                    fit: BoxFit.fill,
                                                    loadingBuilder: (BuildContext
                                                    context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                        loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                        CircularProgressIndicator(
                                                          value: loadingProgress
                                                              .expectedTotalBytes !=
                                                              null
                                                              ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                              : null,
                                                        ),
                                                      );
                                                    },
                                                  ) : Container(),
                                                  if(checkQuestionStatus)...[
                                                    Align(
                                                        alignment: Alignment.topRight,
                                                        child: SvgPicture.asset(getIconCheckType4(listAnswersDragg[i].selectIsCorrect ??0))
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            );
                                          },
                                          onWillAccept: (data) {
                                            if (listAnswersDragg[i].isSelect ==
                                                true) {
                                              return false;
                                            } else {
                                              return true;
                                            }
                                          },
                                          onAccept: (data) {
                                            setState(() {
                                              for (var position = 0;
                                              position <
                                                  contentQuizz[index]
                                                      .answers!
                                                      .length;
                                              position++) {
                                                if (data.id ==
                                                    contentQuizz[index]
                                                        .answers![position]
                                                        .id) {
                                                  contentQuizz[index]
                                                      .answers![position]
                                                      .isSelect = true;
                                                  break;
                                                }
                                              }

                                              listAnswersDragg[i].answerFileTemp =
                                                  data.answerFile;
                                              listAnswersDragg[i].isSelect = true;
                                              listAnswersDragg[i].ordering = data.ordering;
                                              listAnswersDragg[i].id = data.id;


                                              bool checkStatus = false;
                                              for (var position = 0;
                                              position <
                                                  listAnswersDragg.length;
                                              position++) {
                                                if (listAnswersDragg[position]
                                                    .isSelect ==
                                                    true) {
                                                  checkStatus = true;
                                                } else {
                                                  checkStatus = false;
                                                  break;
                                                }
                                              }

                                              if (checkStatus == true) {
                                                statusButtonFinish = true;
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          for (var i = 0;
                          i < contentQuizz[index].answers!.length;
                          i++) ...[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (checkQuestionAnswersed() == true) return;
                                  statusButtonFinish = true;
                                  anserSelect == i;
                                  if (contentQuizz[index].type == 1) {
                                    for (var ii = 0;
                                    ii < contentQuizz[index].answers!.length;
                                    ii++) {
                                      contentQuizz[index].answers![ii].isSelect =
                                      false;
                                    }
                                    contentQuizz[index].answers![i].isSelect =
                                    !contentQuizz[index]
                                        .answers![i]
                                        .isSelect!;
                                    _answers = contentQuizz[index].answers![i];
                                  } else if (contentQuizz[index].type == 2) {
                                    contentQuizz[index].answers![i].isSelect =
                                    !contentQuizz[index]
                                        .answers![i]
                                        .isSelect!;
                                    if (contentQuizz[index]
                                        .answers![i]
                                        .isSelect ==
                                        true) {
                                      _listAnswers
                                          .add(contentQuizz[index].answers![i]);
                                    } else {
                                      _listAnswers.remove(
                                          contentQuizz[index].answers![i]);
                                    }
                                  }
                                  contentQuizz;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: Constants.kDefaultPadding),
                                padding: const EdgeInsets.all(
                                    Constants.kDefaultPadding),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                      color: getTheRightColor(checkQuestionStatus,
                                          contentQuizz[index].answers![i])),
                                  color: getTheRightColorForBg(
                                      checkQuestionStatus,
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (contentQuizz[index].type == 1) ...[
                                      SvgPicture.asset(urlIconRadio(
                                          checkQuestionStatus,
                                          contentQuizz[index].answers![i],
                                          i)),
                                    ] else ...[
                                      SvgPicture.asset(urlIconRadioMutil(
                                          checkQuestionStatus, i)),
                                    ],
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
                                    if (getTheRightIcon(checkQuestionStatus,
                                        contentQuizz[index].answers![i])
                                        .isNotEmpty) ...[
                                      Container(
                                        width: 26,
                                        height: 26,
                                        child: SvgPicture.asset(getTheRightIcon(
                                            checkQuestionStatus,
                                            contentQuizz[index].answers![i])),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: 20),
                        Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: checkQuestionStatus,
                          child: Align(
                            alignment: Alignment.centerLeft,
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
                        ),
                      ],
                    ),
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
                                          buttonNext = "Tiếp tục";
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
                                            } else if (contentQuizz[index]
                                                    .type ==
                                                3) {
                                              checkQuestion();
                                            } else if (contentQuizz[index]
                                                    .type ==
                                                4) {
                                              checkQuestionType4();
                                            } else {
                                              checkQuestionMutil();
                                            }
                                            buttonNext = "Tiếp tục";
                                            return;
                                          } else {
                                            if (index ==
                                                contentQuizz.length - 1) {
                                              Result _dataResult = Result();
                                              print(finish());
                                              _dataResult.result = finish();
                                              _dataResult.numOfCorrectAns =
                                                  _numOfCorrectAns;
                                              _dataResult.listQuestion =
                                                  listQuestion;
                                              Get.offAndToNamed(
                                                  "/resultQuizScreen",
                                                  arguments: _dataResult);
                                              return;
                                            } else {
                                              buttonNext = "Hoàn thành";
                                              index = index + 1;
                                              if (contentQuizz[index].type ==    4) {
                                                // listAnswersDragg.clear();
                                                if (listStoreQuestionDrap.isNotEmpty) {
                                                  for (var i = 0; i < listStoreQuestionDrap.length; i++) {
                                                    if(listStoreQuestionDrap[i].idQuestion == contentQuizz[index].id) {
                                                      listAnswersDragg = listStoreQuestionDrap[i].listAnswersDragg!;
                                                      break;
                                                    }
                                                  }
                                                } else {
                                                  for (int i = 0;
                                                      i <
                                                          contentQuizz[index]
                                                              .answers!
                                                              .length;
                                                      i++) {
                                                    QuestionDrap an =
                                                        QuestionDrap(
                                                      id: contentQuizz[index]
                                                          .answers![i]
                                                          .id,
                                                      isCorrect:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .isCorrect,
                                                      answerFile:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .answerFile,
                                                      answerFileTemp:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .answerFileTemp,
                                                      answerText:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .answerText,
                                                      isSelect:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .isSelect,
                                                      selectIsCorrect:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .selectIsCorrect,
                                                      ordering:
                                                          contentQuizz[index]
                                                              .answers![i]
                                                              .ordering,
                                                    );
                                                    listAnswersDragg.add(an);
                                                  }
                                                }
                                              }

                                              if (checkQuestionAnswersed() ==
                                                  true) {
                                                buttonNext = "Tiếp tục";
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

  void checkQuestionType4() {
    SubmitQuizData submitQuizData = SubmitQuizData();
    submitQuizData.questionId = contentQuizz[index].id;
    List<DataAnswer> listDataAnswer = [];

    for (var i = 0; i < listAnswersDragg.length; i++) {
      DataAnswer dataAnswer = DataAnswer();
      dataAnswer.answerId = listAnswersDragg[i].id;
      if (listAnswersDragg[i].ordering == i + 1) {
        listAnswersDragg[i].selectIsCorrect = 2;
        dataAnswer.isCorrect = true;
      } else {
        listAnswersDragg[i].selectIsCorrect = 1;
        dataAnswer.isCorrect = false;
      }
      dataAnswer.ordering = listAnswersDragg[i].ordering;
      listDataAnswer.add(dataAnswer);
    }
    bool status = true;
    for (var i = 0; i < listAnswersDragg.length; i++) {
      if (listAnswersDragg[i].selectIsCorrect == 1) {
        status = false;
        break;
      }
    }
    submitQuizData.dataAnswer = listDataAnswer;
    listSubmitQuizData.add(submitQuizData);
    listQuestion.add(Question(isCorrect: status, id: contentQuizz[index].id));
    listStoreQuestionDrap.add(StoreQuestionDrap(
      idQuestion: contentQuizz[index].id, listAnswersDragg: listAnswersDragg
    ));
    setState(() {
      contentQuizz[index].isAnswers = true;
      checkQuestionStatus = true;
      listAnswersDragg;
      contentQuizz;
    });
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
    listQuestion.add(Question(isCorrect: isCorrect, id: _answers.id));
    setState(() {
      checkQuestionStatus = true;
      contentQuizz;
    });
  }

  void checkQuestionType3() {
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
    listQuestion.add(Question(isCorrect: isCorrect, id: _answers.id));
    setState(() {
      checkQuestionStatus = true;
      contentQuizz;
    });
  }

  void checkQuestionMutil() {
    var data = contentQuizz[index].answers;
    var status = true;
    var statusNoAnswer = true;

    for (var i = 0; i < data!.length; i++) {
      if(data[i].isCorrect == 1) {
        statusNoAnswer = false;
        break;
      }
    }

    if(statusNoAnswer) {
      _numOfCorrectAns++;
      for (var i = 0; i < data.length; i++) {
        for (var ii = 0; ii < _listAnswers.length; ii++) {
          if (data[i].id == _listAnswers[ii].id) {
            contentQuizz[index].isAnswers = true;
            data[i].selectIsCorrect = 2;
          } else if (data[i].isCorrect == 1) {
            contentQuizz[index].answers![i].selectIsCorrect = 2;
          }
        }
      }
    } else {
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
    }


    if (_listAnswers.length == 1 && !statusNoAnswer) {
      status = false;
    }

    for (var i = 0; i < _listAnswers.length; i++) {
      if (_listAnswers[i].selectIsCorrect == 1) {
        status = false;
        break;
      }
    }
    if (status == true) _numOfCorrectAns++;
    SubmitQuizData submitQuizData = SubmitQuizData();
    submitQuizData.questionId = contentQuizz[index].id;
    List<DataAnswer> listDataAnswer = [];
    for (var i = 0; i < _listAnswers.length; i++) {
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
    listQuestion.add(Question(isCorrect: status, id: _answers.id));
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

  Color getTheRightColorType3(bool checkQuestion, Answers answers) {
    if (!checkQuestion) {
      if (answers.isSelect == true) {
        return Mytheme.color_0xFFCCECFB;
      } else {
        return Mytheme.kBackgroundColor;
      }
    } else {
      if (answers.selectIsCorrect == 2 && answers.isSelect == true) {
        return Mytheme.color_0xFF30CD60;
      } else if (answers.selectIsCorrect == 1 && answers.isSelect == true) {
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

  Color getTheRightColorBorderType4(bool checkQuestion, int answers) {
    if (checkQuestion) {
      if (answers == 2) {
        return Mytheme.color_0xFF30CD60;
      } else {
        return Mytheme.kRedColor;
      }
    } else {
      return Mytheme.color_0xFFA7ABC3;
    }
  }

  String getIconCheckType4(int answers) {
    if (answers == 2) {
      return "assets/svg/check_circle_correct.svg";
    } else {
      return "assets/svg/check_wrong.svg";
    }
  }

  String getTheRightIcon(bool checkQuestion, Answers answers) {
    if (getTheRightColor(checkQuestion, answers) == Mytheme.kRedColor) {
      return "assets/svg/check_wrong.svg";
    } else if (getTheRightColor(checkQuestion, answers) ==
        Mytheme.color_0xFF30CD60) {
      return "assets/svg/check_circle_correct.svg";
    }
    return "";
  }

  String urlIconRadio(bool checkQuestion, Answers answers, int index) {
    if (!checkQuestion) {
      if (anserSelect == index) {
        return "assets/svg/ic_radio_no_select.svg";
      } else {
        return "assets/svg/ic_radio_no_select.svg";
      }
    } else {
      if (answers.selectIsCorrect == 2 && answers.isSelect == true) {
        return "assets/svg/ic_radio_choose_correct.svg";
      } else if (answers.selectIsCorrect == 2) {
        return "assets/svg/ic_radio_not_select_green.svg";
      } else if (answers.selectIsCorrect == 1) {
        return "assets/svg/ic_radio_choose_incorrect.svg";
      }
    }
    return "assets/svg/ic_radio_no_select.svg";
  }

  String urlIconRadioMutil(bool checkQuestion, int indexLocal) {
    var answer = contentQuizz[index].answers![indexLocal];
    if (!checkQuestion) {
      if (answer.isSelect == true) {
        return "assets/svg/checkbox_select.svg";
      } else {
        return "assets/svg/checkbox_no_check.svg";
      }
    } else {
      if (answer.selectIsCorrect == 2 && answer.isSelect == true) {
        return "assets/svg/checkbox_check_correct.svg";
      } else if (answer.selectIsCorrect == 2) {
        return "assets/svg/checkbox_green.svg";
      } else if (answer.selectIsCorrect == 1) {
        return "assets/svg/checkbox_check_incorrect.svg";
      }
    }
    return "assets/svg/checkbox_no_check.svg";
  }

  String urlIconType3(bool checkQuestion, int indexLocal, int isCorrect) {
    var answer = contentQuizz[index].answers![indexLocal];
    if (!checkQuestion) {
      if (isCorrect == 1) {
        return "assets/svg/icon_right.svg";
      } else {
        return "assets/svg/icon_incorrect.svg";
      }
    } else {
      if (answer.selectIsCorrect == 2 && answer.isSelect == true) {
        return "assets/svg/icon_right_check.svg";
      } else if (answer.selectIsCorrect == 1 && answer.isSelect == true) {
        return "assets/svg/icon_worng_check.svg";
      } else if (isCorrect == 1) {
        return "assets/svg/icon_right.svg";
      } else {
        return "assets/svg/icon_incorrect.svg";
      }
    }
    return "assets/svg/icon_right.svg";
  }

  String finish() {
    submitQuiz.studyPartId = _studyData.id;
    submitQuiz.totalCorrect = _numOfCorrectAns;
    submitQuiz.data = listSubmitQuizData;
    return jsonEncode(submitQuiz);
  }
}

class StoreQuestionDrap {
  int? idQuestion;
  List<QuestionDrap>? listAnswersDragg;

  StoreQuestionDrap({this.idQuestion, this.listAnswersDragg});
}

class QuestionDrap {
  int? id;
  String? answerText;
  String? answerFile;
  String? answerFileTemp;
  int? isCorrect;
  bool? isSelect;
  int? selectIsCorrect;
  int? ordering;

  QuestionDrap(
      {this.id,
      this.answerText,
      this.answerFile,
      this.answerFileTemp,
      this.isCorrect,
      this.isSelect,
      this.selectIsCorrect,
      this.ordering});
}
