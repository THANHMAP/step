import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/exercise_model.dart';
import 'package:step_bank/models/lesson_model.dart';
import 'package:step_bank/models/study_model.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/card_content_topic.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class DetailEducationScreen extends StatefulWidget {
  const DetailEducationScreen({Key? key}) : super(key: key);

  @override
  _DetailEducationScreenState createState() => _DetailEducationScreenState();
}

class _DetailEducationScreenState extends State<DetailEducationScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  LessonData _lessonData = Get.arguments;
  List<StudyData> _studyData = [];
  List<ExerciseData> _exerciseData = [];

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Nội dung'),
    Tab(text: 'Tài liệu'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
    loadListStudy();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          if (_studyData.isEmpty) {
            loadListStudy();
          }
          break;
        case 1:
          if (_exerciseData.isEmpty) {
            loadListExercise();
          }
          break;
      }
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
              Expanded(
                flex: 11,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppbarWidget(
                        text: _lessonData.nameCourse,
                        onClicked: () => Get.back(),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 30, left: 0, right: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 16, right: 16),
                              child: Column(
                                children: [
                                  Text(
                                    _lessonData.name.toString(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Mytheme.colorTextSubTitle,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-SemiBold",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CachedNetworkImage(
                                    imageUrl: _lessonData.thumbnail.toString(),
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                              ),
                            ),
                            DefaultTabController(
                              length: 2,
                              child: SizedBox(
                                height: 300.0,
                                child: Column(
                                  children: <Widget>[
                                    TabBar(
                                      controller: _tabController,
                                      labelColor: Mytheme.color_active,
                                      unselectedLabelColor: Colors.grey,
                                      labelStyle: TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                      tabs: myTabs,
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: <Widget>[
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  if (_studyData.isNotEmpty) ...[
                                                    for (var i = 0;
                                                    i < _studyData.length;
                                                    i++) ...[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 16,
                                                            right: 16,
                                                            bottom: 12),
                                                        child:
                                                        CardContentTopicWidget(
                                                          title:
                                                          _studyData[i].name,
                                                          type:
                                                          _studyData[i].type,
                                                          hideImageRight: false,
                                                          onClicked: () {
                                                            _studyData[i].nameCourse = _lessonData.nameCourse;
                                                            if(_studyData[i].type == 5) {
                                                              Get.toNamed(
                                                                  '/homeQuizScreen', arguments: _studyData[i]);
                                                            } else if(_studyData[i].type == 2) {
                                                              Get.toNamed(
                                                                  '/videoScreen', arguments: _studyData[i]);
                                                            } else {
                                                              _studyData[i].nameCourse = _lessonData.nameCourse;
                                                              Get.toNamed(
                                                                  '/detailEducationScreen', arguments: _studyData[i]);
                                                            }

                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ]
                                                ],
                                              ),
                                            ),

                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  if (_exerciseData.isNotEmpty) ...[
                                                    for (var i = 0;
                                                    i < _exerciseData.length;
                                                    i++) ...[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 16,
                                                            right: 16,
                                                            bottom: 12),
                                                        child:
                                                        CardContentTopicWidget(
                                                          title:
                                                          _exerciseData[i].name,
                                                          type:
                                                          1,
                                                          hideImageRight: false,
                                                          onClicked: () {
                                                            // if(_exerciseData[i].tu)
                                                            // Get.toNamed('/detailEducationScreen', arguments: _exerciseData[i].);
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ]
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  color: Mytheme.kBackgroundColor,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 0, left: 24, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // side: const BorderSide(color: Colors.red)
                                  ),
                                  primary: Mytheme.colorTextDivider,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 44)),
                              child: const Text(
                                StringText.text_continue,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Mytheme.color_0xFFA7ABC3,
                                    fontFamily: "OpenSans-SemiBold",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {},
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
                                    borderRadius: BorderRadius.circular(8),
                                    // side: const BorderSide(color: Colors.red)
                                  ),
                                  primary: Mytheme.colorBgButtonLogin,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 44)),
                              child: const Text(
                                StringText.text_next_lesson,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "OpenSans-Regular",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {},
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> loadListStudy() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'lesson_id': _lessonData.id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.listStudyURL, param).then(
        (value) async {
      await pr.hide();
      var data = StudyModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _studyData = data.data!;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadListExercise() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'lesson_id': _lessonData.id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.listExerciseURL, param).then(
        (value) async {
      await pr.hide();
      var data = ExerciseModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _exerciseData = data.data!;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
