import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/screens/news/news_detail_screen.dart';
import 'package:step_bank/screens/news/news_screen.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/custom_exception.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  late ProgressDialog pr;
  List<NewsData>? newsList;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    // loadSharedPrefs();
    loadNews();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                  ],
                ),
                toolLayout(),
                const SizedBox(height: 20),
                hoctapLayout(),
                const SizedBox(height: 20),
                viewPager(),
                const SizedBox(height: 20),
                newsLayout(),
              ],
            ),
          ),
        ),
      ),
    );
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
                    // getOtpAgain(phone);
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
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              print("Container clicked");
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
                      child: Image(
                        image: AssetImage('assets/images/img_khoan_vay.png'),
                        fit: BoxFit.cover,
                        width: 52,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 10, right: 0),
                      child: Text(
                        "Ước tính khoản vay",
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
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              print("Container clicked");
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
                      child: Image(
                        image: AssetImage('assets/images/img_khoan_vay.png'),
                        fit: BoxFit.cover,
                        width: 52,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 0, left: 10, right: 0),
                      child: Text(
                        "Xem danh sách hồ sơ vay vốn",
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

  hoctapLayout() {
    return Container(
      height: 123,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/img_bg_hoctap.png"),
          fit: BoxFit.fill,
        ),
      ),
      // child: Column(
      //   children: const <Widget>[],
      // ),
    );
  }

  viewPager() {
    return SizedBox(
      height: 123,
      child: PageView.builder(
        itemCount: 10,
        controller: PageController(viewportFraction: 0.7),
        onPageChanged: (int index) => setState(() => _index = index),
        itemBuilder: (_, i) {
          return Transform.scale(
            scale: i == _index ? 1 : 0.9,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Card ${i + 1}",
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
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
                  pushNewScreen(
                    context,
                    screen: NewsDetailScreen(newsData: newsList![i]),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                  // Get.toNamed('/newsDetail', arguments: newsList![i]);
                },
                child: Container(
                  height: 106,
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
                              top: 0, left: 20, right: 10),
                          child: Column(
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
                              )),
                              const SizedBox(height: 10),
                              Flexible(
                                  child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        newsList?[i].createdAt ?? "",
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
            height: 103,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/img_bank_home.png"),
                fit: BoxFit.fill,
              ),
            ),
            // child: Column(
            //   children: const <Widget>[],
            // ),
          ),
        ],
      ),
    );
  }

  Future<void> loadNews() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.newsURL).then((value) async {
      await pr.hide();
      var news = NewsModel.fromJson(value);
      if (news.statusCode == 200) {
        setState(() {
          newsList = news.data;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  int setMaxItem() {
    if (newsList == null) {
      return 0;
    } else if (newsList!.length >= 2) {
      return 2;
    }
    return 0;
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
}
