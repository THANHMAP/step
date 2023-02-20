import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/education_model.dart';
import 'package:step_bank/models/lesson_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/card_education.dart';
import '../../compoment/card_education_topic.dart';
import '../../compoment/card_setting.dart';
import '../../constants.dart';
import '../../models/course_detail_model.dart';
import '../../themes.dart';
import '../../util.dart';

class TopicEducationScreen extends StatefulWidget {
  const TopicEducationScreen({Key? key}) : super(key: key);

  @override
  _TopicEducationScreenState createState() => _TopicEducationScreenState();
}

class _TopicEducationScreenState extends State<TopicEducationScreen> {
  late ProgressDialog pr;
  List<DataLessonModel> _lessonList = [];
  // final EducationData _educationData = Get.arguments;

  final courseId = Get.arguments;

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
      loadListEducation(courseId.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Mytheme.colorBgMain,
              body: Column(
                children: <Widget>[
                  AppbarWidget(
                    text: _lessonList.isNotEmpty ? _lessonList[0].courseName ?? "" : "",
                    onClicked: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, left: 16, right: 16, bottom: 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 16, left: 0, bottom: 0, right: 26),
                                //   child:  Image.network(
                                //     _educationData.icon.toString(),
                                //     fit: BoxFit.fill,
                                //     width: 50,
                                //     loadingBuilder: (BuildContext context, Widget child,
                                //         ImageChunkEvent? loadingProgress) {
                                //       if (loadingProgress == null) return child;
                                //       return Center(
                                //         child: CircularProgressIndicator(
                                //           value: loadingProgress.expectedTotalBytes != null
                                //               ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!).toDouble()
                                //               : null,
                                //         ),
                                //       );
                                //     },
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       top: 16, left: 0, bottom: 18, right: 0),
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment: CrossAxisAlignment.start,
                                //     children: [
                                //       Align(
                                //         alignment: Alignment.centerLeft,
                                //         child: Text(
                                //           _educationData.name.toString(),
                                //           // textAlign: TextAlign.start,
                                //           style: const TextStyle(
                                //             fontSize: 20,
                                //             color: Mytheme.colorBgButtonLogin,
                                //             fontWeight: FontWeight.w400,
                                //             fontFamily: "OpenSans-Regular",
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (_lessonList.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 0, right: 0, bottom: 0),
                                child: Column(
                                  children: [
                                    for (var i = 0; i < _lessonList.length; i++) ...[
                                      layoutTest(_lessonList[i], i)
                                    ],
                                    // for (var i = 0; i < _lessonList.length; i++) ...[
                                    //   CardEducationTopicWidget(
                                    //     title: _lessonList[i].name,
                                    //     numberLesson: numberLesson(i+1),
                                    //     finish: _lessonList[i].numberFinish ?? 0,
                                    //     total: _lessonList[i].totalPart ?? 0,
                                    //     onClicked: () {
                                    //       trackingLesson(_lessonList[i].id ?? 0);
                                    //       _lessonList[i].nameCourse = _educationData.name;
                                    //       Get.toNamed('/educationTopicDetail', arguments: i);
                                    //     },
                                    //   ),
                                    //   const SizedBox(height: 10),
                                    // ]
                                  ],
                                ),
                              ),
                            ],
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

  headerLayout() {
    return Container(
      height: 236,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/img_header_home.png"),
          fit: BoxFit.cover,
        ),
      ),
      // child: Column(
      //   children: const <Widget>[],
      // ),
    );
  }


  String numberLesson(int number) {
    // if (number < 10) {
    //   return "0$number";
    // }

    return "$number";
  }

  Future<void> loadListEducation(String courseId) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'course_id': courseId,
    });
    APIManager.postAPICallNeedToken(RemoteServices.listLessonURL, param).then(
        (value) async {
      await pr.hide();
      var data = LessonModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _lessonList = data.data!;
          if(_lessonList.isNotEmpty) {
            _lessonList[0].collapsed = true;
          }
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> trackingLesson(int id) async {
    var param = jsonEncode(<String, String>{
      'lesson_id': id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.trackingURL, param).then(
            (value) async {
        }, onError: (error) async {
    });
  }

  layoutTest(DataLessonModel dataLessonModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 16),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    if(dataLessonModel.collapsed == true) {
                      dataLessonModel.collapsed = false;
                    } else {
                      dataLessonModel.collapsed = !dataLessonModel.collapsed!;
                    }

                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: dataLessonModel.collapsed == false
                        ? Colors.white
                        : Mytheme.color_0xFFCCECFB,
                    // borderRadius: BorderRadius.circular(8),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, left: 16, bottom: 18, right: 0),
                          child: Text(
                            dataLessonModel.name.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: Mytheme.colorBgButtonLogin,
                              fontWeight: FontWeight.w600,
                              fontFamily: "OpenSans-Semibold",
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 6, bottom: 0, right: 0),
                          child: IconButton(
                            icon:
                            Image.asset("assets/images/ic_arrow_down.png"),
                            // tooltip: 'Increase volume by 10',
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                dataLessonModel.collapsed = !dataLessonModel.collapsed!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                  visible: dataLessonModel.collapsed ?? false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, left: 10, bottom: 18, right: 10),
                    child: Column(
                      children: [
                        for (var i = 0; i < dataLessonModel.dataLesson!.length; i++) ...[
                          CardEducationTopicWidget(
                            title: dataLessonModel.dataLesson?[i].name,
                            numberLesson: numberLesson(i+1),
                            finish: dataLessonModel.dataLesson?[i].numberFinish ?? 0,
                            total: dataLessonModel.dataLesson?[i].totalPart ?? 0,
                            onClicked: () {
                              Constants.nameCourseTemp = dataLessonModel.name ?? "";
                              Constants.lessonListTemp = dataLessonModel.dataLesson;
                              trackingLesson(dataLessonModel.dataLesson?[i].id ?? 0);
                              // _lessonList[i].nameCourse = _educationData.name;
                              Get.toNamed('/educationTopicDetail', arguments: i);
                            },
                          ),
                          const SizedBox(height: 10),
                        ]
                      ],
                    ),
                  ))

              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     faqData.description.toString(),
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Mytheme.colorBgButtonLogin,
              //       fontWeight: FontWeight.w400,
              //       fontFamily: "OpenSans-Regular",
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

}
