import 'dart:async';
import 'dart:io';
import 'dart:io' as io;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';


import '../../compoment/card_content_topic.dart';
import '../../constants.dart';
import '../../models/exercise_model.dart';
import '../../models/study_model.dart';
import '../../themes.dart';
import '../../util.dart';
import 'detail_topic_education.dart';

class DetailEducationLessonScreen extends StatefulWidget {
  const DetailEducationLessonScreen({Key? key, this.exerciseData})
      : super(key: key);

  final List<ExerciseData>? exerciseData;

  @override
  _DetailEducationScreentate createState() => _DetailEducationScreentate();
}

class _DetailEducationScreentate extends State<DetailEducationLessonScreen> {
  late ProgressDialog pr;
  StudyData _studyData = StudyData();
  late CarouselSlider carouselSlider = CarouselSlider();
  int activePage = 0;
  late PageController _pageController;
  List<String> fileSlideShare = [];
  String progressString = '0%';
  var progressValue = 0.0;
  InAppWebViewController? webViewController;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  final ChromeSafariBrowser browser = new ChromeSafariBrowser();

  @override
  void initState() {
    super.initState();
    _studyData = Get.arguments;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
    if (_studyData.fileSlideShare != null) {
      fileSlideShare = _studyData.fileSlideShare!;
    }

    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
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
              AppbarWidget(
                text: Constants.nameCourseTemp,
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 70),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // if (_studyData.type == 4) ...[
                        //   typeVideo(),
                        // ],
                        if (_studyData.type == 3) ...[
                          typeImage(),
                          // imageGallery(),
                        ],
                        if (_studyData.type == 1) ...[
                          typeText(),
                        ],
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
                        for (var i = 0;
                            i < _studyData.exerciseData!.length;
                            i++) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 16, right: 16, bottom: 12),
                            child: CardContentTopicWidget(
                              title: _studyData.exerciseData![i].name,
                              type: 1,
                              hideImageRight: false,
                              onClicked: () async {
                                downloadFile(
                                    "https://firebasestorage.googleapis.com/v0/b/angel-study-circle.appspot.com/o/big_buck_bunny_720p_5mb.mp4?alt=media&token=64180039-5e62-4aa5-8e18-b1bb7b33bcc3",
                                    _studyData.exerciseData![i].name.toString(),
                                    "mp4");
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
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 20, left: 24, right: 24),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // side: const BorderSide(color: Colors.red)
                            ),
                            primary: Mytheme.colorBgButtonLogin,
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 44)),
                        child: Text(
                          "Tiếp tục",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans-Regular",
                              fontWeight: FontWeight.bold),
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

  // typeVideo() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
  //     child: Column(children: [
  //       Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           _studyData.name.toString(),
  //           style: const TextStyle(
  //             fontSize: 24,
  //             color: Mytheme.colorTextSubTitle,
  //             fontWeight: FontWeight.w600,
  //             fontFamily: "OpenSans-SemiBold",
  //           ),
  //         ),
  //       ),
  //       Align(
  //         alignment: Alignment.centerLeft,
  //         child: Text(
  //           _studyData.contentText.toString(),
  //           style: const TextStyle(
  //             fontSize: 16,
  //             color: Mytheme.colorTextSubTitle,
  //             fontWeight: FontWeight.w400,
  //             fontFamily: "OpenSans-Regular",
  //           ),
  //         ),
  //       ),
  //       SizedBox(
  //           width: double.infinity,
  //           height: 300,
  //           // the most important part of this example
  //           child: WebViewPlus(
  //             key: UniqueKey(),
  //             initialUrl: _studyData.fileScorm.toString(),
  //             // Enable Javascript on WebView
  //             javascriptMode: JavascriptMode.unrestricted,
  //           )),
  //       const SizedBox(height: 10),
  //     ]),
  //   );
  // }

  typeImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.name.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-SemiBold",
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Html(
            data: _studyData.contentText.toString(),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 400,
          child: PageView.builder(
              itemCount: fileSlideShare.length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return slider(fileSlideShare, pagePosition, active);
              }),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset("assets/svg/ic_pre.svg"),
              // tooltip: 'Increase volume by 10',
              iconSize: 50,
              onPressed: goToPrevious,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${activePage + 1}/${fileSlideShare.length}",
                style: const TextStyle(
                  fontSize: 18,
                  color: Mytheme.colorBgButtonLogin,
                  fontWeight: FontWeight.w600,
                  fontFamily: "OpenSans-SemiBold",
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset("assets/svg/ic_next.svg"),
              // tooltip: 'Increase volume by 10',
              iconSize: 50,
              onPressed: goToNext,
            ),
            // OutlineButton(
            //   onPressed: goToNext,
            //   child: Text(">"),
            // ),
          ],
        ),
      ]),
    );
  }

  typeText() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _studyData.name.toString(),
            style: const TextStyle(
              fontSize: 24,
              color: Mytheme.colorTextSubTitle,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-SemiBold",
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Html(
            data: _studyData.contentText.toString(),
          ),
        ),
      ]),
    );
  }

  // imageGallery() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
  //     child: Column(children: [
  //       Center(
  //         child: InkWell(
  //           child: Ink.image(
  //             fit: BoxFit.cover,
  //             image: NetworkImage(fileSlideShare[0]),
  //             height: 300,
  //           ),
  //           onTap: openGallery,
  //         ),
  //       ),
  //     ]),
  //   );
  // }

  void openGallery(int position) => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GalleryWidget(
            urlImages: fileSlideShare,
            index: position,
        ),
      ));

  Widget slider(images, pagePosition, active) {
    double margin = active ? 10 : 20;

    return InkWell(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        margin: EdgeInsets.all(margin),
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(images[pagePosition].toString()))),
      ),
      onTap: () {
        openGallery(pagePosition);
      },
    ) ;
  }

  imageAnimation(PageController animation, images, pagePosition) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, widget) {
        print(pagePosition);

        return SizedBox(
          width: 200,
          height: 200,
          child: widget,
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Image.network(images[pagePosition]),
      ),
    );
  }

  goToPrevious() {
    _pageController.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  goToNext() {
    _pageController.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.decelerate);
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
}

class GalleryWidget extends StatefulWidget {
  final PageController pageController;
  final List<String> urlImages;
  final int index;
  GalleryWidget({
    required this.urlImages,
    this.index = 0,
  }) : pageController = PageController(initialPage: index);

  @override
  State<StatefulWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            PhotoViewGallery.builder(
                pageController: widget.pageController,
                itemCount: widget.urlImages.length,
                builder: (context, index) {
                  final urlImage = widget.urlImages[index];
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(urlImage),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.contained * 4,
                  );
                }
            ),
            Container(
              height: 80,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                child: Align(
                  child: Padding(
                      padding: const EdgeInsets.only(top: 66, left: 20),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SvgPicture.asset(
                          "assets/svg/ic_back.svg",
                        ),
                      )),
                ),
              ),
            )

          ],
        ),

      );
}
