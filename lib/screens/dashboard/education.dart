import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class EducationScreen extends StatefulWidget {
  const EducationScreen({Key? key}) : super(key: key);

  @override
  _EducationScreenState createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
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
    loadListEducation();
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
                text: "Học tập",
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 0, right: 0, bottom: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        headerLayout(),
                        if (_educationList.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 16, right: 16, bottom: 0),
                            child: Column(
                              children: [
                                for (var i = 0; i < _educationList.length; i++) ...[
                                  CardEducatonWidget(
                                    title: _educationList[i].name,
                                    numberLesson: "10 bài học",
                                    linkUrl: 'assets/images/img_taichinh.png',
                                    onClicked: () {
                                      Get.toNamed('/educationTopic');
                                    },
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
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

  loadCardEducation() {
    if (_educationList.isNotEmpty) {
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 0),
        child: Column(
          children: [
            for (var i = 0; i < 2; i++) ...[
              CardEducatonWidget(
                title: _educationList[i].name,
                numberLesson: "10 bài học",
                linkUrl: 'assets/images/img_taichinh.png',
                onClicked: () {
                  Get.toNamed('/editProfile');
                },
              ),
            ]
          ],
        ),
      );
    }
  }

  Future<void> loadListEducation() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.listCourseURL).then(
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
