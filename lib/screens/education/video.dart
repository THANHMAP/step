import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:open_file_safe/open_file_safe.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../compoment/card_content_topic.dart';
import '../../constants.dart';
import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';
import 'detail_topic_education.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late ProgressDialog pr;
  StudyData _studyData = Get.arguments;
  String progressString = '0%';
  var progressValue = 0.0;
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    // Step 3
    initializePlayer();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // _videoPlayerController1.addListener(() {
    //   _chewieController.deviceOrientationsAfterFullScreen =
    //   if(_chewieController!.isFullScreen == false) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ]);
    //   }
    // });
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController1 =
        VideoPlayerController.network(_studyData.contentFile.toString());
    _videoPlayerController2 =
        VideoPlayerController.network(_studyData.contentFile.toString());
    await Future.wait([
      _videoPlayerController1.initialize(),
      _videoPlayerController2.initialize()
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      showOptions: false,
      autoPlay: true,
      looping: false,
      allowFullScreen: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.grey,
      ),
      // autoInitialize: true,
    );

  }

  int currPlayIndex = 0;

  Future<void> toggleVideo() async {
    await _videoPlayerController1.pause();
    currPlayIndex = currPlayIndex == 0 ? 1 : 0;
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Mytheme.light.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Mytheme.colorBgButtonLogin,
          title: Text(
            Constants.nameCourseTemp,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-Semibold",
              // decoration: TextDecoration.underline,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Utils.portraitModeOnly();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null &&
                    _chewieController!
                        .videoPlayerController.value.isInitialized
                    ? Chewie(
                  controller: _chewieController!,
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Loading'),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Text(
                        //     "Tài liệu",
                        //     style: const TextStyle(
                        //       fontSize: 16,
                        //       color: Mytheme.colorTextSubTitle,
                        //       fontWeight: FontWeight.w400,
                        //       fontFamily: "OpenSans-Regular",
                        //     ),
                        //   ),
                        // ),
                        // Divider(
                        //     color: Colors.black
                        // ),
                      ],
                    ),
                  ),

                  // for (var i = 0; i < _studyData.exerciseData!.length; i++) ...[
                  //   Padding(
                  //     padding: const EdgeInsets.only(
                  //         top: 10, left: 16, right: 16, bottom: 12),
                  //     child: CardContentTopicWidget(
                  //       title: _studyData.exerciseData![i].name,
                  //       type: 1,
                  //       hideImageRight: false,
                  //       onClicked: () async {
                  //         downloadFile(
                  //             "https://firebasestorage.googleapis.com/v0/b/angel-study-circle.appspot.com/o/big_buck_bunny_720p_5mb.mp4?alt=media&token=64180039-5e62-4aa5-8e18-b1bb7b33bcc3",
                  //             _studyData.exerciseData![i].name.toString(),
                  //             "mp4");
                  //       },
                  //     ),
                  //   ),
                  // ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

}
