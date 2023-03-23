
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
import '../../shared/SPref.dart';
import '../../util.dart';
import '../dashboard/education.dart';
import '../dashboard/tool.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}




class _HomeMainState extends State<HomeMain> with SingleTickerProviderStateMixin {
  PersistentTabController? _controller;
  ScrollController scrollHomeController = ScrollController();
  ScrollController scrollNewsController = ScrollController();
  var indexTutorial = 0;
  var currentIndex = 0;
  var statusShowTutorial = Constants.statusShowTutorial;
  final List<String> _listTutorial = [
    "Cùng Co-opSmart khám phá một số tính năng của ứng dụng",
    "Cập nhật các thông tin, mẹo quản lý tài chính, chương trình và hoạt động của Quỹ TDND và Ngân hàng HTX",
    "Các công cụ giúp quản lý tài chính và kinh doanh hàng ngày",
    "Các bài học tương tác đơn giản và thú vị về tài chính và kinh doanh",
    "Quản lý, cập nhật thông tin cá nhân và theo dõi các hoạt động của bạn trên ứng dụng",
    "Các thông báo mới nhất về tin tức, bài học, lịch trả nợ… của riêng bạn"
  ];

  @override
  void initState() {
    super.initState();
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
    print("sadsadsadsd:${Get.bottomBarHeight} : ${Get.width}  :  ${Get.currentRoute}");
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(MyFlutterApp.home),
        title: ("Trang chủ"),
        // onSelectedTabPressWhenNoScreensPushed: () {
        //   scrollHomeController.animateTo(0,
        //       duration: const Duration(seconds: 1), curve: Curves.ease);
        // },
        // onPressed: (context) {
        //     setState(() {
        //       _controller?.index = 0;
        //     });
        // },
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
            if (statusShowTutorial)...[
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
                    if (indexTutorial == _listTutorial.length - 1)...[
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.only(top: 65, right: 16),
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                      ),
                    ] else if (indexTutorial != 0 && indexTutorial != 1)... [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: getValueMargin(indexTutorial), bottom: Get.bottomBarHeight > 0 ? kBottomNavigationBarHeight - 22 : 0.0), // 20 là trang chủ, 16 là cong cụ, 200 là học tập, 295 là tài khoản
                          height: 55,
                          width: Get.width < 405 ? 85 : 90,
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
  if (index == 2) {
      if (Get.width > 405) {
        return 116;
      } else if (Get.width < 385) {
        return 103;
      } else {
        return 110;
      }
    } else if (index == 3) {
      if (Get.width > 405) {
        return 213;
      } else if (Get.width < 385) {
        return 190;
      } else {
        return 200;
      }
    } else if (index == 4) {
      if (Get.width > 405) {
        return 306;
      } else if (Get.width < 385) {
        return 275;
      } else {
        return 290;
      }
    }
    return 0;
  }

  double getTop(int index) {
    if (index == 2 || index == 3 || index == 4) {
      return 300;
    }
    return 20;
  }

  double getBottom(int index) {
    if (index == 5) {
      return 400;
    }
    return 0;
  }

  Widget showTutorial(int index) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: getTop(index), bottom: getBottom(index), left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15),
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
                children:  <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0, left: 0, bottom: 8, right: 0),
                    child: Column(
                      children: [
                        Text(
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
                        if (indexTutorial == 1)...[
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Image.asset("assets/images/img_tuto_banner.png",
                            ),
                          ),
                        ],
                      ],
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
                        child:  InkWell(
                          onTap: (){
                            setState(() {
                              if (indexTutorial < _listTutorial.length - 1) {
                                indexTutorial++;
                              } else {
                                // indexTutorial = 0;
                                statusShowTutorial = false;
                                Constants.statusShowTutorial = false;
                                SPref.instance.addBoolToSF("loginFirst", false);
                              }
                            });

                          },
                          child:  Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 44,
                            width: 135,
                            decoration: BoxDecoration(
                              color: Mytheme.colorBgButtonLogin,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              indexTutorial != _listTutorial.length - 1 ?"Tiếp tục" : "Hoàn thành",
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
                padding: EdgeInsets.only(top: 20, right: 50),
                child: Image.asset("assets/images/img_person.png",
                  width: 170,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

}
