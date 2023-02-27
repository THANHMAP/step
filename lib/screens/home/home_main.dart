import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:step_bank/icon.dart';
import 'package:step_bank/screens/dashboard/home.dart';
import 'package:step_bank/screens/dashboard/profile.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/screens/splash/splash.dart';
import 'package:step_bank/themes.dart';

import '../../constants.dart';
import '../../service/local_notification_service.dart';
import '../../shared/SPref.dart';
import '../../util.dart';
import '../dashboard/education.dart';
import '../dashboard/tool.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain>
    with SingleTickerProviderStateMixin {
  PersistentTabController? _controller;
  ScrollController scrollHomeController = ScrollController();
  ScrollController scrollNewsController = ScrollController();
  var indexTutorial = 0;
  var statusShowTutorial = Constants.statusShowTutorial;
  final List<String> _listTutorial = [
    "Cùng Co-upSmart khám phá một số tính năng của ứng dụng",
    "Trang chủ: Cung cấp các tin tức, thông tin liên quan đến tài chính và các sự kiện quan trọng khác",
    "Công cụ: giúp bạn xây dựng kế hoạch tài chính tốt hơn cho riêng mình",
    "Học tập: cung cấp các tài liệu giáo dục về tài chính như các khóa học, bài giảng, video và tài liệu tham khảo.",
    "Tài khoản: giúp người dùng quản lý và kiểm soát tài khoản của mình",
    "Thông báo: Thông báo cho người dùng về tin tức mới nhất, học tập mới được đăng tài, và các sự kiện khác liên quan đến tài khoản người dùng"
  ];

  @override
  void initState() {
    super.initState();
    initNotification();
    Utils.portraitModeOnly();
    _controller = PersistentTabController(initialIndex: 0);
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(controller: _controller),
      ToolScreen(),
      EducationScreen(),
      ProfileScreen(controller: _controller)
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(MyFlutterApp.home),
        title: ("Trang chủ"),
        onSelectedTabPressWhenNoScreensPushed: () {
          scrollHomeController.animateTo(0,
              duration: const Duration(seconds: 1), curve: Curves.ease);
        },
        activeColorPrimary: Mytheme.color_active,
        inactiveColorPrimary: Mytheme.color_inActive,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(MyFlutterApp.tool),
        title: ("Công cụ"),
        activeColorPrimary: Mytheme.color_active,
        inactiveColorPrimary: Mytheme.color_inActive,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(MyFlutterApp.education),
        title: ("Học tập"),
        activeColorPrimary: Mytheme.color_active,
        inactiveColorPrimary: Mytheme.color_inActive,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(MyFlutterApp.setting),
        title: ("Tài khoản"),
        activeColorPrimary: Mytheme.color_active,
        inactiveColorPrimary: Mytheme.color_inActive,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: Stack(
          children: [
            PersistentTabView(
              context,
              controller: _controller,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: Colors.white,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
                  ? 0.0
                  : kBottomNavigationBarHeight,
              hideNavigationBarWhenKeyboardShows: true,
              margin: const EdgeInsets.all(0.0),
              bottomScreenMargin: 0.0,
              decoration: NavBarDecoration(
                // borderRadius: BorderRadius.circular(10.0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style3,
            ),
            if (statusShowTutorial) ...[
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.8), BlendMode.srcOut),
                // This one will create the magic
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          backgroundBlendMode: BlendMode
                              .dstOut), // This one will handle background + difference out
                    ),
                    if (indexTutorial == _listTutorial.length - 1) ...[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 65, right: 15),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ] else if (indexTutorial != 0) ...[
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: getValueMargin(indexTutorial)),
                          // 20 là trang chủ, 16 là cong cụ, 200 là học tập, 295 là tài khoản
                          height: 55,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              showTutorial(indexTutorial),
            ],
          ],
        ));
  }

  double getValueMargin(int index) {
    if (index == 1) {
      return 20;
    } else if (index == 2) {
      return 112;
    } else if (index == 3) {
      return 200;
    } else if (index == 4) {
      return 295;
    }
    return 0;
  }

  Widget showTutorial(int index) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                // boxShadow:  [
                //   BoxShadow(
                //       color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                // ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.only(top: 0, left: 20, bottom: 8, right: 20),
                    child: Text(
                      _listTutorial[index] ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        color: Mytheme.color_44494D,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Material(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (indexTutorial < _listTutorial.length - 1) {
                                indexTutorial++;
                              } else {
                                statusShowTutorial = false;
                                Constants.statusShowTutorial = false;
                                SPref.instance.addBoolToSF("loginFirst", false);
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 44,
                            width: 135,
                            decoration: BoxDecoration(
                              color: Mytheme.colorBgButtonLogin,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              indexTutorial != _listTutorial.length - 1
                                  ? "Tiếp tục"
                                  : "Hoàn thành",
                              style: const TextStyle(
                                fontSize: 16,
                                decoration: TextDecoration.none,
                                color: Mytheme.kBackgroundColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: "OpenSans-Semibold",
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            if (index == 0) ...[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image.asset("assets/images/img_person.png"),
              ),
            ],
          ],
        ),
      ),
    );
  }

  initNotification() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          // if (message.data['_id'] != null) {
          //   Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (context) => DemoScreen(
          //         id: message.data['_id'],
          //       ),
          //     ),
          //   );
          // }
        }
      },
    );

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
          (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.display(message);

        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
          (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }
}
