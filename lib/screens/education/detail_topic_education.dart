import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/exercise_model.dart';
import 'package:step_bank/models/lesson_model.dart';
import 'package:step_bank/models/study_model.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/card_content_topic.dart';
import '../../constants.dart';
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
  LessonData? _lessonData;
  List<StudyData> _studyData = [];
  List<ExerciseData> _exerciseData = [];
  String progressString = '0%';
  var progressValue = 0.0;
  bool selectDefault = true;
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = Get.arguments;
    _lessonData = Constants.lessonListTemp![index];
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    loadListStudy();
  }

  @override
  void dispose() {

    super.dispose();
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
                        text: _lessonData?.nameCourse ?? "",
                        onClicked: () => Get.back(),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 10, left: 0, right: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                              child: Column(
                                children: [
                                  Text(
                                    _lessonData?.name.toString() ?? "",
                                    style: const TextStyle(
                                      fontSize: 24,
                                      color: Mytheme.colorTextSubTitle,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-SemiBold",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  CachedNetworkImage(
                                    imageUrl: _lessonData?.thumbnail.toString() ?? "",
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectDefault = true;
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Nội dung",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectDefault
                                              ? Mytheme.colorBgButtonLogin
                                              : Mytheme.color_82869E,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-SemiBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectDefault = false;
                                      });
                                    },
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Tài liệu",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: !selectDefault
                                              ? Mytheme.colorBgButtonLogin
                                              : Mytheme.color_82869E,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-SemiBold",
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Divider(
                                        thickness: 2,
                                        color: selectDefault
                                            ? Mytheme.colorBgButtonLogin
                                            : Mytheme.color_82869E,
                                      )),
                                ),
                                Expanded(
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Divider(
                                        thickness: 2,
                                        color: !selectDefault
                                            ? Mytheme.colorBgButtonLogin
                                            : Mytheme.color_82869E,
                                      )),
                                )
                              ],
                            ),

                            Visibility(
                              visible: selectDefault ? true : false,
                              child: Column(
                                children: [
                                  if (_studyData
                                      .isNotEmpty) ...[
                                    for (var i = 0;
                                    i < _studyData.length;
                                    i++) ...[
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            top: 10,
                                            left: 16,
                                            right: 16,
                                            bottom: 12),
                                        child:
                                        CardContentTopicWidget(
                                          title: _studyData[i]
                                              .name,
                                          type: _studyData[i]
                                              .type,
                                          hideImageRight: true,
                                          onClicked: () {
                                            trackingLesson(_studyData[i].id??0);
                                            _studyData[i].nameCourse = _lessonData?.nameCourse;
                                            _studyData[i].exerciseData = _exerciseData;
                                            if (_studyData[i]
                                                .type ==
                                                5) {
                                              Get.toNamed(
                                                  '/homeQuizScreen',
                                                  arguments:
                                                  _studyData[
                                                  i]);
                                            } else if (_studyData[
                                            i]
                                                .type ==
                                                2) {
                                              Get.toNamed(
                                                  '/videoScreen',
                                                  arguments:
                                                  _studyData[
                                                  i]);
                                            } else {
                                              _studyData[i]
                                                  .nameCourse =
                                                  _lessonData
                                                      ?.nameCourse;
                                              Get.toNamed(
                                                  '/detailEducationScreen',
                                                  arguments:
                                                  _studyData[
                                                  i]);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ]
                                ],
                              ),),
                            Visibility(
                              visible: !selectDefault ? true : false,
                              child: Column(
                                children: [
                                  if (_exerciseData
                                      .isNotEmpty) ...[
                                    for (var i = 0;
                                    i <
                                        _exerciseData
                                            .length;
                                    i++) ...[
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(
                                            top: 10,
                                            left: 16,
                                            right: 16,
                                            bottom: 12),
                                        child:
                                        CardContentTopicWidget(
                                          title:
                                          _exerciseData[i]
                                              .name,
                                          type: 1,
                                          hideImageRight: false,
                                          onClicked: () async {
                                            downloadFile(
                                                _exerciseData[i].fileExercise ?? "",
                                                _exerciseData[i].name.toString(),
                                                "mp4");
                                          },
                                        ),
                                      ),
                                    ],
                                  ]
                                ],
                              ),),

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
                                  primary: index == 0 ? Mytheme.colorTextDivider: Mytheme.colorBgButtonLogin,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 44)),
                              child:  Text(
                                "Bài trước",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: index == 0 ? Mytheme.color_0xFFA7ABC3 : Mytheme.kBackgroundColor,
                                    fontFamily: "OpenSans-SemiBold",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if (index != 0) {
                                  setState(() {
                                    index = index - 1;
                                    _lessonData = Constants.lessonListTemp![index];
                                    loadListStudy();
                                  });
                                }
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
                                    borderRadius: BorderRadius.circular(8),
                                    // side: const BorderSide(color: Colors.red)
                                  ),
                                  primary: index == Constants.lessonListTemp!.length - 1 ? Mytheme.colorTextDivider : Mytheme.colorBgButtonLogin,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 44)),
                              child:  Text(
                                StringText.text_next_lesson,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: index == Constants.lessonListTemp!.length - 1  ? Mytheme.color_0xFFA7ABC3 : Mytheme.kBackgroundColor,
                                    fontFamily: "OpenSans-Regular",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                if(index == Constants.lessonListTemp!.length - 1) {

                                } else {
                                  index = index + 1;
                                  _lessonData = Constants.lessonListTemp![index];
                                  loadListStudy();
                                }
                              },
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
      'lesson_id': _lessonData?.id.toString() ?? "",
    });
    APIManager.postAPICallNeedToken(RemoteServices.listStudyURL, param).then(
        (value) async {
      var data = StudyModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _studyData = data.data!;
        });
        loadListExercise();
      }
    }, onError: (error) async {

      Utils.showError(error.toString(), context);
    });
    await pr.hide();
  }

  Future<void> loadListExercise() async {
    if(!pr.isShowing()) {
      await pr.show();
    }
    var param = jsonEncode(<String, String>{
      'lesson_id': _lessonData?.id.toString() ?? "",
    });
    APIManager.postAPICallNeedToken(RemoteServices.listExerciseURL, param).then(
        (value) async {

      var data = ExerciseModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          _exerciseData = data.data!;
        });
      }
    }, onError: (error) async {
      Utils.showError(error.toString(), context);
    });
    await pr.hide();
  }

  Future<void> downloadFile(
      String url, String fileName, String extension) async {
    var dio = new Dio();
    var dir = await getExternalStorageDirectory();
    var knockDir =
        await new Directory('${dir?.path}/AZAR').create(recursive: true);
    print("Hello checking the file in Externaal Sorage");
    io.File('${knockDir.path}/$fileName.$extension').exists().then((a) async {
      print(a);
      if (a) {
        OpenFile.open('${knockDir.path}/$fileName.$extension');
        print("Opening file");
        // showDialog(
        //     context: context,
        //     builder: (_) {
        //       return AlertDialog(
        //         title: Text('File is already downloaded'),
        //         actions: <Widget>[
        //           RaisedButton(
        //               child: Text('Open'),
        //               onPressed: () {
        //                 // TODO write your function to open file
        //                 Navigator.pop(context);
        //               })
        //         ],
        //       );
        //     });
        return;
      } else {
        print("Downloading file");
        openDialog();
        await dio.download(url, '${knockDir.path}/$fileName.$extension',
            onReceiveProgress: (rec, total) {
          if (mounted) {
            setState(() {
              progressValue = (rec / total);
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
              myDialogState.setState(() {
                myDialogState.progressData = progressString;
                myDialogState.progressValue = progressValue;
              });
            });
          }
        });
        if (mounted) {
          setState(() {
            print('${knockDir.path}');
            // TODO write your function to open file
          });
        }
        print("Download completed");
      }
    });
  }

  openDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MyDialog();
      },
    );
  }

  Future<void> trackingLesson(int id) async {
    var param = jsonEncode(<String, String>{
      'study_part_id': id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.trackingURL, param).then(
            (value) async {
        }, onError: (error) async {
    });
  }

}

_MyDialogState myDialogState = _MyDialogState();

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() {
    myDialogState = _MyDialogState();
    return myDialogState;
  }
}

class _MyDialogState extends State<MyDialog> {
  String progressData = '0%';
  var progressValue = 0.0;

  @override
  Widget build(BuildContext context) {
    print(progressValue);
    return AlertDialog(
      content: LinearProgressIndicator(
        value: progressValue,
        backgroundColor: Colors.red,
      ),
      title: Text(progressData),
      actions: <Widget>[
        progressValue == 1.0
            ? RaisedButton(
                child: Text('Done'),
                onPressed: () {
                  // TODO write your function to open file
                  Navigator.pop(context);
                })
            : Container()
      ],
    );
  }
}
