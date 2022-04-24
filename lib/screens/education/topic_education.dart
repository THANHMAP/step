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
import 'package:step_bank/models/education_model.dart';
import 'package:step_bank/models/lesson_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/card_education.dart';
import '../../compoment/card_education_topic.dart';
import '../../compoment/card_setting.dart';
import '../../themes.dart';
import '../../util.dart';

class TopicEducationScreen extends StatefulWidget {
  const TopicEducationScreen({Key? key}) : super(key: key);

  @override
  _TopicEducationScreenState createState() => _TopicEducationScreenState();
}

class _TopicEducationScreenState extends State<TopicEducationScreen> {
  late ProgressDialog pr;
  List<LessonData> _lessonList = [];
  final EducationData _educationData = Get.arguments;

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
      loadListEducation();
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
                text: "Chủ đề học tập",
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 16, right: 16, bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 0, bottom: 0, right: 26),
                              child:  Image.network(
                                _educationData.icon.toString(),
                                fit: BoxFit.fill,
                                width: 50,
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? (loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!).toDouble()
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16, left: 0, bottom: 18, right: 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _educationData.name.toString(),
                                      // textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Mytheme.colorBgButtonLogin,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                  CardEducationTopicWidget(
                                    title: _lessonList[i].name,
                                    numberLesson: numberLesson(i+1),
                                    finish: _lessonList[i].numberFinish ?? 0,
                                    total: _lessonList[i].totalPart ?? 0,
                                    onClicked: () {
                                      trackingLesson(_lessonList[i].id ?? 0);
                                      _lessonList[i].nameCourse = _educationData.name;
                                      Get.toNamed('/educationTopicDetail', arguments: _lessonList[i]);
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                ]
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
        ));
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
    if (number < 10) {
      return "0$number";
    }

    return "$number";
  }

  Future<void> loadListEducation() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'course_id': _educationData.id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.listLessonURL, param).then(
        (value) async {
      await pr.hide();
      var data = LessonModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _lessonList = data.data!;
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

}
