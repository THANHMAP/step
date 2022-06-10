import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/constants.dart';
import '../../models/answers_model.dart';
import '../../models/study_model.dart' as study;
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../themes.dart';
import '../../util.dart';

class ShowQuizScreen extends StatefulWidget {
  const ShowQuizScreen({Key? key}) : super(key: key);

  @override
  _ShowQuizScreenState createState() => _ShowQuizScreenState();
}

class _ShowQuizScreenState extends State<ShowQuizScreen> {
  late ProgressDialog pr;
  List<ContentQuizz> contentQuizz = [];
  var studyData = study.StudyData();
  String textButton = "Tiếp theo";
  int index = 0;
  var statusHasAnswer = false;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    studyData = Get.arguments;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    showQuiz(studyData.id ?? 0);
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
                  child:  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Constants.kDefaultPadding,
                    ),
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        if (contentQuizz.isNotEmpty) ...[
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
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 0, left: 0, right: 10),
                                            child: Container(
                                              width: 150,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: getTheRightColorType3(
                                                      contentQuizz[index]
                                                          .answers![i]),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                color: Mytheme.kBackgroundColor,
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
                                                      contentQuizz[index]
                                                          .answers![i])),
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
                              child: Column(
                                children: [
                                  loadType4(contentQuizz[index].answers!),
                                ],
                              ),
                            ),
                          ] else ...[
                            for (var i = 0;
                            i < contentQuizz[index].answers!.length;
                            i++) ...[
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      top: Constants.kDefaultPadding),
                                  padding: const EdgeInsets.all(
                                      Constants.kDefaultPadding),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: getTheRightColor(
                                            statusHasAnswer,
                                            contentQuizz[index]
                                                .answers![i]
                                                .userChoose,
                                            contentQuizz[index]
                                                .answers![i]
                                                .isCorrect)),
                                    color: Mytheme.kBackgroundColor,
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
                                            statusHasAnswer,
                                            contentQuizz[index]
                                                .answers![i]
                                                .userChoose,
                                            contentQuizz[index]
                                                .answers![i]
                                                .isCorrect)),
                                      ] else ...[
                                        SvgPicture.asset(urlIconRadioMutil(
                                            statusHasAnswer,
                                            contentQuizz[index]
                                                .answers![i]
                                                .userChoose,
                                            contentQuizz[index]
                                                .answers![i]
                                                .isCorrect)),
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
                                      if (getTheRightIcon(
                                          statusHasAnswer,
                                          contentQuizz[index]
                                              .answers![i]
                                              .userChoose,
                                          contentQuizz[index]
                                              .answers![i]
                                              .isCorrect)
                                          .isNotEmpty) ...[
                                        Container(
                                          width: 26,
                                          height: 26,
                                          child: SvgPicture.asset(
                                            getTheRightIcon(
                                                statusHasAnswer,
                                                contentQuizz[index]
                                                    .answers![i]
                                                    .userChoose,
                                                contentQuizz[index]
                                                    .answers![i]
                                                    .isCorrect),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                          const SizedBox(height: 20),
                          Align(
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
                        ],
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
                                      setState(
                                        () {
                                          if (index > 0) {
                                            textButton = "Tiếp theo";
                                            index = index - 1;
                                            checkQuestionHasAnser();
                                          }
                                        },
                                      );
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
                                        primary: Mytheme.colorBgButtonLogin,
                                        minimumSize: Size(
                                            MediaQuery.of(context).size.width,
                                            44)),
                                    child: Text(
                                      textButton,
                                      style: TextStyle(
                                          color: Mytheme.kBackgroundColor,
                                          fontSize: 16,
                                          fontFamily: "OpenSans-SemiBold",
                                          fontWeight: FontWeight.w600),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (index == contentQuizz.length - 1) {
                                          Get.back();
                                          return;
                                        }
                                        index = index + 1;
                                        checkQuestionHasAnser();
                                        if (index == contentQuizz.length - 1) {
                                          textButton = "Tiếp tục";
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


  bool? checkQuestionAnswersed() {
    return false;
  }


  Future<void> showQuiz(int id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'study_part_id': id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.userAnswersdURL, param).then(
        (value) async {
      await pr.hide();
      var data = AnswersModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          contentQuizz = data.data!.contentQuizz!;
          checkQuestionHasAnser();
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Color getTheRightColor(bool noAnser, bool? userChoose, int? isCorrect) {

    if (userChoose == true) {
      if(noAnser == false) {
        return Mytheme.color_0xFF30CD60;
      }
      if (isCorrect == 0) {
        return Mytheme.kRedColor;
      } else {
        return Mytheme.color_0xFF30CD60;
      }
    } else {
      if (isCorrect == 1) {
        return Mytheme.color_0xFF30CD60;
      }
    }
    return Mytheme.kBackgroundColor;
  }

  String urlIconRadio(bool noAnser, bool? userChoose, int? isCorrect) {
    if(noAnser == false) {
      return "assets/svg/ic_radio_choose_correct.svg";
    }
    if (userChoose == true) {
      if (isCorrect == 0) {
        return "assets/svg/ic_radio_choose_incorrect.svg";
      } else {
        return "assets/svg/ic_radio_choose_correct.svg";
      }
    } else if (isCorrect == 1) {
      return "assets/svg/ic_radio_not_select_green.svg";
    }
    return "assets/svg/ic_radio_no_select.svg";
  }

  String urlIconRadioMutil(bool noAnser, bool? userChoose, int? isCorrect) {
    if (userChoose == true) {
      if(noAnser == false) {
        return "assets/svg/checkbox_check_correct.svg";
      }
      if (isCorrect == 0) {
        return "assets/svg/checkbox_check_incorrect.svg";
      } else {
        return "assets/svg/checkbox_check_correct.svg";
      }
    } else if (isCorrect == 1) {
      return "assets/svg/checkbox_green.svg";
    }
    return "assets/svg/checkbox_no_check.svg";
  }

  String getTheRightIcon(bool noAnser, bool? userChoose, int? isCorrect) {
    if (userChoose == true) {
      if(noAnser == false) {
        return "assets/svg/check_circle_correct.svg";
      }
      if (isCorrect == 0) {
        return "assets/svg/check_wrong.svg";
      } else {
        return "assets/svg/check_circle_correct.svg";
      }
    } else if (isCorrect == 1) {
      return "assets/svg/check_circle_correct.svg";
    }
    return "";
  }

  Color getTheRightColorType3(Answers answers) {
    if (answers.userChoose == true && answers.isCorrect == 1) {
      return Mytheme.color_0xFF30CD60;
    } else if (answers.userChoose == true && answers.isCorrect == 0) {
      return Mytheme.kRedColor;
    }
    return Mytheme.kBackgroundColor;
  }

  String urlIconType3(Answers answers) {
    if (answers.userChoose == true) {
      if (answers.isCorrect == 0) {
        return "assets/svg/icon_worng_check.svg";
      } else {
        return "assets/svg/icon_right_check.svg";
      }
    } else if (answers.isCorrect == 1) {
      return "assets/svg/icon_right.svg";
    } else {
      return "assets/svg/icon_incorrect.svg";
    }
  }

  Widget loadType4(List<Answers> answers) {
    answers.sort((a, b) => a.ordering!.compareTo(b.ordering!));
    return Row(
      children: [
        for (var i = 0; i < answers.length; i++) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 0, left: 0, right: 10),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        getTheRightColorBorderType4(answers[i].isCorrect ?? 0),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Mytheme.kBackgroundColor),
              child: Stack(
                children: [
                  Image.network(
                    answers[i].answerFile ?? "",
                    fit: BoxFit.fill,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset(getIconCheckType4(answers[i].isCorrect ??0))
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color getTheRightColorBorderType4(int answers) {
    if (answers == 1) {
      return Mytheme.color_0xFF30CD60;
    } else {
      return Mytheme.kRedColor;
    }
  }

  String getIconCheckType4(int answers) {
    if (answers == 1) {
      return "assets/svg/check_circle_correct.svg";
    } else {
      return "assets/svg/check_wrong.svg";
    }
  }

  checkQuestionHasAnser() {
    var data = contentQuizz[index].answers;
    for (var i = 0; i < data!.length; i++) {
      if(data[i].isCorrect == 1) {
        statusHasAnswer = true;
        break;
      }
    }
    setState(() {
      statusHasAnswer;
    });
  }

}
