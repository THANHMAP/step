import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/banner_promotion_model.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/screens/dashboard/education.dart';
import 'package:step_bank/screens/dashboard/tool.dart';
import 'package:step_bank/screens/news/news_detail_screen.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/custom_exception.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';
import 'package:weather/weather.dart';

import '../../compoment/dialog_confirm.dart';
import '../../constants.dart';
import '../../models/education/lesson_learned.dart';
import '../../models/education/lesson_learned.dart';
import '../../models/lesson_model.dart';
import '../../models/number_notification.dart';
import '../../models/tool/tool_last_used.dart';
import '../../models/tool_model.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';
import '../news/web_view_news.dart';
import '../notification/notification.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class LifecycleEventHandler extends WidgetsBindingObserver {
  final AsyncCallback resumeCallBack;
  final AsyncCallback suspendingCallBack;

  LifecycleEventHandler({
    required this.resumeCallBack,
    required this.suspendingCallBack,
  });

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        if (resumeCallBack != null) {
          await resumeCallBack();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (suspendingCallBack != null) {
          await suspendingCallBack();
        }
        break;
    }
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, this.controller}) : super(key: key);
  final PersistentTabController? controller;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const String _kLocationServicesDisabledMessage =
      'Chức năng lấy vị trí hiện tại đang bị khóa. Vui lòng mở lại để sử dụng đươc chức năng này';
  static const String _kPermissionDeniedMessage =
      'Chức năng hiển thị thời tiết cần bạn cho phép lấy vị trí hiện. Vui lòng vào phần cài đặt điện thoại để mở';
  static const String _kPermissionDeniedForeverMessage =
      'Chức năng hiển thị thời tiết cần bạn cho phép lấy vị trí hiện. Vui lòng vào phần cài đặt điện thoại để mở.';
  static const String _kPermissionGrantedMessage = 'Permission granted.';
  int _index = 0;
  late ProgressDialog pr;
  List<NewsData>? newsList;
  List<DataToolUsed>? toolLastUsedList;
  DataLessonLearned? dataLessonLearned;
  List<BannerPromotionData>? listBanner = [];
  List<ToolData> _toolList = [];
  String key = '83709fb372c429d8e4f0eb5289273b78';
  late WeatherFactory ws;
  List<Weather> _data = [];
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  String imageHeader = "assets/images/img_header_home.png";
  String textNhietDo = "34";
  String statusWeather = "Trời nắng";
  Color textColorNhietDo = Mytheme.kBackgroundColor;
  bool statusPermission = false;
  int totalNotification = 0;
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    ws = WeatherFactory(key);
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Future.delayed(Duration.zero, () {
      fetchData();
    });
    if (Platform.isAndroid) {
      checkPermison();
    } else {
      _getCurrentPosition();
    }
  }

  Future<void> checkPermison() async {
    LocationPermission permission;
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: ConfirmDialogBox(
                    title: "Quyền truy cập vị trí",
                    descriptions:
                    "Chức năng hiển thị thời tiết cần bạn cho phép lấy vị trí hiện tại. Bạn có cho phép ứng dụng truy cập vị trí của bạn không?",
                    textButtonLeft: "Thoát",
                    textButtonRight: "Cho phép",
                    onClickedConfirm: () async {
                      _getCurrentPosition();
                      Navigator.pop(context, "");
                    },
                    onClickedCancel: () {
                      Navigator.pop(context, "");
                    },
                  ));
            }
        );
      });
    } else {
      _getCurrentPosition();
    }

  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kLocationServicesDisabledMessage,
      // );
      Utils.showError(_kLocationServicesDisabledMessage, context);

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // _updatePositionList(
        //   _PositionItemType.log,
        //   _kPermissionDeniedMessage,
        // );

        Utils.showError(_kPermissionDeniedMessage, context);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // _updatePositionList(
      //   _PositionItemType.log,
      //   _kPermissionDeniedForeverMessage,
      // );
      Utils.showError(_kPermissionDeniedForeverMessage, context);
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // _updatePositionList(
    //   _PositionItemType.log,
    //   _kPermissionGrantedMessage,
    // );
    return true;
  }

//
  void statusWeatherFunction() {
    setState(() {
      if (_data.isNotEmpty) {
        var status = _data[0].weatherConditionCode ?? 0;
        if (status >= 801 && status <= 804) {
          statusWeather = "Trời nhiều mây";
          imageHeader = "assets/images/img_header_cloud.png";
          textColorNhietDo = Mytheme.color_0xFF002766;
          // cloud

        } else if (status == 801 || status == 800) {
          statusWeather = "Trời nắng";
          imageHeader = "assets/images/img_header_home.png";
          textColorNhietDo = Mytheme.kBackgroundColor;
          // sun
        } else {
          statusWeather = "Trời mưa";
          imageHeader = "assets/images/img_header_rain.png";
          textColorNhietDo = Mytheme.color_0xFF002766;
          // rain
        }
      } else {
        statusWeather = "Trời nắng";
        imageHeader = "assets/images/img_header_home.png";
        textColorNhietDo = Mytheme.kBackgroundColor;
      }
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      setState(() {
        statusPermission = false;
      });
      return;
    }

    setState(() {
      statusPermission = true;
    });

    final position = await _geolocatorPlatform.getCurrentPosition();
    queryWeather(position.latitude, position.longitude);
    print(position);
  }

  void queryWeather(double lat, double long) async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    Weather weather = await ws.currentWeatherByLocation(lat, long);
    setState(() {
      _data = [weather];
      statusWeatherFunction();
      print(_data);
      // _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller?.index == 0) {
        if (widget.controller?.index != currentIndex) {
          currentIndex = 0;
          print("test setate${widget.controller?.index}");
          fetchAgainData();
        }
    } else {
      currentIndex = widget.controller?.index ?? 0;
    }
    print("test build n${widget.controller?.index}");
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
      child: GestureDetector(
        child: Scaffold(
          backgroundColor: Mytheme.colorBgMain,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: Column(
                children: [
                  Stack(
                    children: <Widget>[
                      headerLayout(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            totalNotification = 0;
                          });
                          Future.delayed(Duration.zero, () {
                            Get.toNamed("/notificationScreen");
                          });
                          // Get.toNamed("/notificationScreen");
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 66, right: 20),
                              child: Container(
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 2, right: 4),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: SvgPicture.asset(
                                          "assets/svg/ic_notification.svg",
                                        ),
                                      ),
                                    ),
                                    if (totalNotification > 0) ...[
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Mytheme.kRedColor,
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                totalNotification.toString(),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color:
                                                      Mytheme.kBackgroundColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "OpenSans-Bold",
                                                  // decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ],
                                ),
                              )),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 50,
                          left: 170,
                          right: 50,
                          bottom: 0,
                        ),
                        child: Text(
                          'Co-opSmart',
                          style: TextStyle(
                            fontSize: 17,
                            color: Mytheme.color_0xFF002766,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          top: 75,
                          left: 120,
                          right: 65,
                          bottom: 0,
                        ),
                        child: Text(
                          StringText.text_weather,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold,
                            color: Mytheme.color_0xFF002766,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, left: 33),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 27, right: 0),
                                child: SvgPicture.asset(
                                  "assets/svg/ic_logo_notext.svg",
                                  width: 70,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !statusPermission,
                              child: InkWell(
                                onTap: () {
                                  _getCurrentPosition();
                                },
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tải lại",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: Mytheme.kBackgroundColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-Semibold",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: statusPermission,
                              child: Row(
                                children: [
                                  Text(
                                      _data.isNotEmpty
                                          ? _data[0]
                                              .tempMax!
                                              .celsius!
                                              .round()
                                              .toString()
                                          : "34",
                                      style: GoogleFonts.manrope(
                                          fontSize: 36,
                                          fontWeight: FontWeight.w300,
                                          color: textColorNhietDo)),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        "0",
                                        style: GoogleFonts.manrope(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w300,
                                            color: textColorNhietDo),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "C",
                                    style: GoogleFonts.manrope(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w300,
                                        color: textColorNhietDo),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 7),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Text(
                                        statusWeather,
                                        style: GoogleFonts.manrope(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            color: textColorNhietDo),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  toolLayout(),
                  const SizedBox(height: 20),
                  if (dataLessonLearned != null) ...[
                    lessonLearnedLayout(),
                  ] else ...[
                    hocTapLayout(),
                  ],
                  const SizedBox(height: 20),
                  viewPager(),
                  const SizedBox(height: 20),
                  newsLayout(),
                  // const SizedBox(height: 20),
                  // bannerLayout(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  headerLayout() {
    return Container(
      height: 236,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageHeader),
          fit: BoxFit.cover,
        ),
      ),
      // child: Column(
      //   children: const <Widget>[],
      // ),
    );
  }

  toolLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                StringText.text_i_need,
                style: TextStyle(
                  fontSize: 28,
                  color: Mytheme.colorBgButtonLogin,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans-Bold",
                  // decoration: TextDecoration.underline,
                ),
              ),
              // di chuyen item tối cuối
              const Spacer(),
              TextButton(
                  onPressed: () {
                    widget.controller?.index = 1;
                  },
                  child: const Text(
                    StringText.text_all_tool,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_1990FF,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ],
          ),
          if (_toolList.isNotEmpty) ...[
            if (_toolList.length >= 2) ...[
              for (var i = 0; i < 2; i++) ...[
                defaultTool(i),
              ],
            ] else if (_toolList.length == 1) ...[
              defaultTool(0),
            ]
          ],
        ],
        // ],
      ),
    );
  }

  Widget defaultTool(position) {
    // var rng = Random();
    // var position = rng.nextInt(_toolList.length - 1);
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          Future.delayed(Duration.zero, () {
            Get.toNamed('/introductionToolScreen',
                arguments: _toolList[position]);
          });

        },
        child: Container(
          height: 84,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Image.network(
                    _toolList[position].icon ?? "",
                    fit: BoxFit.fill,
                    width: 30,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
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
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 10, right: 0),
                  child: Text(
                    _toolList[position].name ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      color: Mytheme.colorTextSubTitle,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-Semibold",
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image(
                  image: AssetImage('assets/images/img_arrow_right.png'),
                  fit: BoxFit.contain,
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  lessonLearnedLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Bài học đang học",
                style: TextStyle(
                  fontSize: 28,
                  color: Mytheme.colorBgButtonLogin,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans-Bold",
                  // decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              loadListEducation(dataLessonLearned!.courseId.toString(),
                  dataLessonLearned?.lessonId ?? 0);
            },
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Image.network(
                        dataLessonLearned?.thumbnail ?? "",
                        fit: BoxFit.fill,
                        width: 30,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
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
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 10, right: 0),
                      child: Text(
                        dataLessonLearned?.lessonName ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          color: Mytheme.colorTextSubTitle,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Image(
                      image: AssetImage('assets/images/img_arrow_right.png'),
                      fit: BoxFit.contain,
                      width: 16,
                      height: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  hocTapLayout() {
    return InkWell(
      onTap: () {
        widget.controller?.index = 2;
      },
      child: Container(
        height: 123,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/banner_hoc_tap.png"),
            fit: BoxFit.fill,
          ),
        ),
        // child: Column(
        //   children: const <Widget>[],
        // ),
      ),
    );
  }

  bannerLayout() {
    return InkWell(
      onTap: () {
        Future.delayed(Duration.zero, () {
          Get.toNamed('/contactScreen');
        });

      },
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Container(
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/banner_home.png"),
              fit: BoxFit.fill,
            ),
          ),
          // child: Column(
          //   children: const <Widget>[],
          // ),
        ),
      ),
    );
  }

  viewPager() {
    return SizedBox(
      height: 123,
      child: PageView.builder(
        itemCount: listBanner!.length,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  onTap: () {
                    Future.delayed(Duration.zero, () {
                      Get.toNamed("/webViewScreen",
                          arguments: listBanner![_index]);
                    });

                  },
                  child: Container(
                    height: 140.0,
                    width: double.infinity,
                    child: Image.network(
                      listBanner![i].thumbnail.toString(),
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
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
                  ),
                ),
              )

              // new Container(
              //   height: 300.0,
              //   color: Colors.transparent,
              //   child: new Container(
              //       decoration: new BoxDecoration(
              //           color: Colors.green,
              //           borderRadius: new BorderRadius.only(
              //             topLeft: const Radius.circular(40.0),
              //             topRight: const Radius.circular(40.0),
              //           )
              //       ),
              //       child: Image.network(
              //         listBanner![i].thumbnail.toString(),
              //         fit: BoxFit.none,
              //         loadingBuilder: (BuildContext context, Widget child,
              //             ImageChunkEvent? loadingProgress) {
              //           if (loadingProgress == null) return child;
              //           return Center(
              //             child: CircularProgressIndicator(
              //               value: loadingProgress.expectedTotalBytes != null
              //                   ? loadingProgress.cumulativeBytesLoaded /
              //                   loadingProgress.expectedTotalBytes!
              //                   : null,
              //             ),
              //           );
              //         },
              //       ),
              //   ),
              // ),
              // Card(
              //   elevation: 6,
              //   shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(20)),
              //   child: Center(
              //     child: Image.network(
              //       listBanner![i].thumbnail.toString(),
              //       fit: BoxFit.none,
              //       loadingBuilder: (BuildContext context, Widget child,
              //           ImageChunkEvent? loadingProgress) {
              //         if (loadingProgress == null) return child;
              //         return Center(
              //           child: CircularProgressIndicator(
              //             value: loadingProgress.expectedTotalBytes != null
              //                 ? loadingProgress.cumulativeBytesLoaded /
              //                 loadingProgress.expectedTotalBytes!
              //                 : null,
              //           ),
              //         );
              //       },
              //     ),
              //   ),
              // ),
              );
        },
      ),
    );
  }

  newsLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                StringText.text_news,
                style: TextStyle(
                  fontSize: 28,
                  color: Mytheme.colorBgButtonLogin,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans-Bold",
                  // decoration: TextDecoration.underline,
                ),
              ),
              // di chuyen item tối cuối
              const Spacer(),
              TextButton(
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: NewsScreen(),
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                    );
                    // Get.toNamed('/news');
                    // getOtpAgain(phone);
                  },
                  child: const Text(
                    StringText.text_news_more,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_1990FF,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          if (newsList != null) ...[
            for (var i = 0; i < 2; i++) ...[
              InkWell(
                onTap: () {
                  print("test ${newsList![i].linkDetail}");
                  pushNewScreen(
                    context,
                    screen: WebViewNewsScreen(url: newsList![i].linkDetail),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  // Get.toNamed('/newsDetail', arguments: newsList![i]);
                },
                child: Container(
                  height: 116,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Image.network(
                            newsList?[i].thumbnail ?? "",
                            fit: BoxFit.fill,
                            width: 128,
                            height: 106,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 13, left: 20, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  newsList?[i].name ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Mytheme.colorTextSubTitle,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans-Regular",
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Flexible(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        convert(newsList?[i].createdAt ?? ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.color_82869E,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                        textAlign: TextAlign.left,
                                      ))),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
          Container(
            height: 300,
            margin: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                // Divider(
                //   color: Colors.black,
                // ),
                bannerLayout(),
                Divider(
                  color: Colors.black,
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Image.asset("assets/images/icon_coopbank.png"),
                      // tooltip: 'Increase volume by 10',
                      iconSize: 100,
                      onPressed: () {
                        Future.delayed(Duration.zero, () {
                          Get.toNamed("/coopBankScreen");
                        });

                      },
                    ),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      width: 60,
                    ),
                    IconButton(
                      icon: Image.asset("assets/images/icon_bank.png"),
                      // tooltip: 'Increase volume by 10',
                      iconSize: 80,
                      onPressed: () {
                        Future.delayed(Duration.zero, () {
                          Get.toNamed("/qTDScreen");
                        });

                      },
                    ),
                  ],
                )),
                // ignore: prefer_const_constructors
                Divider(
                  color: Colors.black,
                ),
              ],
            ),
            // child: Column(
            //   children: const <Widget>[],
            // ),
          ),
        ],
      ),
    );
  }

  fetchData() async {
    var responses = await Future.wait([
      loadToolLastUsed(),
      loadLessonLearned(),
      loadNews(),
      loadBanner(),
      loadNumberNotification(),
    ]);
    // var response1 = responses.first;

    // var response2 = responses[1];
  }

  fetchAgainData() async {
    var responses = await Future.wait([
      loadToolLastUsed(),
      loadLessonLearned(),
    ]);
    // var response1 = responses.first;

    // var response2 = responses[1];
  }

  Future<void> loadLessonLearned() async {
    APIManager.getAPICallNeedToken(RemoteServices.getListLessonLearned).then(
        (value) async {
      var result = LessonLearned.fromJson(value);
      if (result.statusCode == 200) {
        setState(() {
          dataLessonLearned = result.data;
        });
      }
    }, onError: (error) async {});
  }

  Future<void> loadToolLastUsed() async {
    APIManager.getAPICallNeedToken(RemoteServices.getListToolUsed).then(
        (value) async {
      var result = ToolModel.fromJson(value);
      if (result.statusCode == 200) {
        if (result.data != null && result.data!.isNotEmpty) {
          setState(() {
            _toolList = result.data!;
          });
        } else {
          loadListTool();
        }
      } else {
        setState(() {
          toolLastUsedList = null;
        });
      }
    }, onError: (error) async {
      loadListTool();
      setState(() {
        toolLastUsedList = null;
      });
    });
  }

  Future<void> loadNews() async {
    APIManager.getAPICallNeedToken(RemoteServices.newsURL).then((value) async {
      var news = NewsModel.fromJson(value);
      if (news.statusCode == 200) {
        if (mounted) {
          setState(() {
            newsList = news.data;
          });
        }
      }
    }, onError: (error) async {
      // Utils.showError(error.toString(), context);
    });
    await pr.hide();
  }

  Future<void> loadBanner() async {
    // if (!pr.isShowing()) {
    //   await pr.show();
    // }
    APIManager.getAPICallNeedToken(RemoteServices.listBannerPromotionURL).then(
        (value) async {
      var data = BannerPromotionModel.fromJson(value);
      if (data.statusCode == 200) {
        if (mounted) {
          setState(() {
            listBanner = data.data;
          });
        }
      }
    }, onError: (error) async {
      Utils.showError(error.toString(), context);
    });
    await pr.hide();
  }

  int setMaxItem() {
    if (newsList == null) {
      return 0;
    } else if (newsList!.length >= 2) {
      return 2;
    }
    return 0;
  }

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }

  loadSharedPrefs() async {
    try {
      var isLogged = await SPref.instance.get("info_login");
      var response = json.decode(isLogged.toString());
      UserData user = UserData.fromJson(response);
      print(user);
    } on FetchDataException catch (e) {
      print('error caught: $e');
    }
  }

  Future<void> loadListTool() async {
    // var param = jsonEncode(<String, String>{
    //   'my_tool': "false",
    // });
    APIManager.postAPICallNeedToken(RemoteServices.listToolURL, "").then(
        (value) async {
      pr.hide();
      var data = ToolModel.fromJson(value);
      if (data.statusCode == 200) {
        if (mounted) {
          setState(() {
            _toolList = data.data!;
          });
        }
      }
    }, onError: (error) async {
      // Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadNumberNotification() async {
    APIManager.getAPICallNeedToken(RemoteServices.numberNotificationURL).then(
        (value) async {
      pr.hide();
      var data = NumberNotification.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          totalNotification = data.data?.total ?? 0;
        });
      }
    }, onError: (error) async {
      // Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadListEducation(String courseId, int lessonId) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'course_id': courseId,
    });
    APIManager.postAPICallNeedToken(RemoteServices.listLessonURL, param).then(
        (value) async {
      await pr.hide();
      var result = LessonModel.fromJson(value);
      if (result.statusCode == 200) {
        var data = result.data;
        if (data != null && data.isNotEmpty) {
          for (var lesson in data) {
            for (var i = 0; i < lesson.dataLesson!.length; i++) {
              if (lesson.dataLesson![i].id == lessonId) {
                Constants.nameCourseTemp = lesson.dataLesson![i].name ?? "";
                Constants.lessonListTemp = lesson.dataLesson;
                Future.delayed(Duration.zero, () {
                  Get.toNamed('/educationTopicDetail', arguments: i);
                });

                break;
              }
            }
          }
        }
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
