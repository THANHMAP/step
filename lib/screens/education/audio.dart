import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io;
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../compoment/card_content_topic.dart';
import '../../constants.dart';
import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';
import 'detail_topic_education.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late ProgressDialog pr;
  StudyData _studyData = Get.arguments;
  TargetPlatform? _platform;
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  String currentTime = "0:00:00";
  String completeTime = "0:00:00";

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();

    player.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });

    player.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
    Future.delayed(Duration.zero, () {
      playaudio();
    });

  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> playaudio() async {
    int status = await player.play(_studyData.contentFile.toString(), isLocal: false);
    if (status == 1) {
      setState(() {
        isPlaying = true;
      });
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
              AppbarWidget(
                text: Constants.nameCourseTemp,
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                flex: 11,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 70),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          width: 240,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(80),
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    if (isPlaying) {
                                      player.pause();

                                      setState(() {
                                        isPlaying = false;
                                      });
                                    } else {
                                      player.resume();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    }
                                  }),
                              IconButton(
                                icon: Icon(
                                  Icons.stop,
                                  color: Colors.black,
                                  size: 25,
                                ),
                                onPressed: () {
                                  player.stop();

                                  setState(() {
                                    isPlaying = false;
                                  });
                                },
                              ),
                              Text(
                                "   " + currentTime,
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              Text(" | "),
                              Text(
                                completeTime,
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Html(
                            data: _studyData.contentText.toString(),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Tài liệu",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Mytheme.colorTextSubTitle,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans-Regular",
                                  ),
                                ),
                              ),
                              Divider(color: Colors.black),
                            ],
                          ),
                        ),
                        for (var i = 0; i < _studyData.exerciseData!.length; i++) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 12),
                            child: CardContentTopicWidget(
                              title: _studyData.exerciseData![i].name,
                              type: 1,
                              hideImageRight: false,
                              onClicked: () async {
                                // downloadFile(
                                //     "https://firebasestorage.googleapis.com/v0/b/angel-study-circle.appspot.com/o/big_buck_bunny_720p_5mb.mp4?alt=media&token=64180039-5e62-4aa5-8e18-b1bb7b33bcc3",
                                //     _studyData.exerciseData![i].name.toString(),
                                //     "mp4");
                              },
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 0, left: 24, right: 24),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // side: const BorderSide(color: Colors.red)
                            ),
                            primary: Mytheme.colorBgButtonLogin,
                            minimumSize: Size(MediaQuery.of(context).size.width, 44)),
                        child: Text(
                          "Tiếp tục",
                          style: TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Get.back();
                          // await browser.open(
                          //     url: Uri.parse("https://internal.co-opsmart.vn/scorm/13"),
                          //     options: ChromeSafariBrowserClassOptions(
                          //         android: AndroidChromeCustomTabsOptions(shareState: CustomTabsShareState.SHARE_STATE_OFF),
                          //         ios: IOSSafariOptions(barCollapsingEnabled: true)));
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
