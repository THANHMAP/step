
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
    return PersistentTabView(
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
    );
  }
}
