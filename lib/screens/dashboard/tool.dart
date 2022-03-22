import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/education_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/card_education.dart';
import '../../compoment/card_setting.dart';
import '../../themes.dart';
import '../../util.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({Key? key}) : super(key: key);

  @override
  _ToolScreenState createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  late ProgressDialog pr;
  List<EducationData> _educationList = [];

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    // Future.delayed(Duration.zero, () {
    //   loadListEducation();
    // });
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
              hideBack: true,
              text: "Công cụ",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 70),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                  Padding(
                  padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                  child: Column(
                    children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 16, right: 16, bottom: 0),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              CardSettingWidget(
                                title: "Lập ngân sách",
                                linkUrl: 'assets/svg/ic_lapngansach.svg',
                                onClicked: () {
                                },
                              ),

                              const SizedBox(height: 15),
                              CardSettingWidget(
                                title: "Kế hoạch sản xuất kinh doanh",
                                linkUrl: 'assets/svg/ic_kehoach.svg',
                                onClicked: () {
                                },
                              ),

                              const SizedBox(height: 15),
                              CardSettingWidget(
                                title: "Quản lý tiết kiệm",
                                linkUrl: 'assets/svg/ic_quanlytietkiem.svg',
                                onClicked: () {
                                },
                              ),

                              const SizedBox(height: 15),
                              CardSettingWidget(
                                title: "Lịch trả nợ",
                                linkUrl: 'assets/svg/ic_lichtrano.svg',
                                onClicked: () {
                                },
                              ),

                              const SizedBox(height: 15),
                              CardSettingWidget(
                                title: "Danh mục hồ sơ vay vốn",
                                linkUrl: 'assets/svg/ic_danhmucvayvon.svg',
                                onClicked: () {
                                },
                              ),

                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                      // headerLayout(),
                      // layoutCourse(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  layoutCourse() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        children: [
          if (_educationList.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 0),
              child: Column(
                children: [
                  for (var i = 0; i < _educationList.length; i++) ...[
                    const SizedBox(height: 15),
                    CardEducatonWidget(
                      title: _educationList[i].name,
                      numberLesson: "",
                      linkUrl: _educationList[i].icon,
                      onClicked: () {
                        Get.toNamed('/educationTopic',
                            arguments: _educationList[i]);
                      },
                    ),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  headerLayout() {
    return Stack(
      children: <Widget>[
        Container(
          height: 236,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_home.png"),
              fit: BoxFit.cover,
            ),
          ),
          // child: Column(
          //   children: const <Widget>[],
          // ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 56, left: 28, right: 0),
          child: Container(
            width: 216,
            child: Column(
              children: [
                Text(
                  "Các khái niệm kinh doanh cơ bản",
                  style: TextStyle(
                    fontSize: 23,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w700,
                    fontFamily: "OpenSans-Bold",
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 136, left: 28, right: 0),
          child: SizedBox(
            width: 130,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: const BorderSide(color: Colors.red)
                  ),
                  primary: Mytheme.colorBgButtonLogin,
                  minimumSize: Size(MediaQuery.of(context).size.width, 44)),
              child: const Text(
                "Xem thêm",
                style: TextStyle(
                    fontSize: 16,
                    fontFamily: "OpenSans-Regular",
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Get.toNamed("/courseScreen");
              },
            ),
          ),
        ),

        Padding(
            padding: const EdgeInsets.only(top: 56, left: 28, right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: SvgPicture.asset(
                'assets/svg/ic_eduction_home.svg',
                allowDrawingOutsideViewBox: true,
              ),
            )
        ),

      ],
    );
  }

  Future<void> loadListEducation() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'type': '0',
    });
    APIManager.postAPICallNeedToken(RemoteServices.listCourseURL, param).then(
            (value) async {
          await pr.hide();
          var data = EducationModel.fromJson(value);
          if (data.statusCode == 200) {
            setState(() {
              _educationList = data.data!;
            });
          }
        }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}