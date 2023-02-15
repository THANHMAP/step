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
    Future.delayed(Duration.zero, () {
      loadListEducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.colorBgMain,
          body: Column(
            children: <Widget>[
              AppbarWidget(
                hideBack: true,
                text: "Học Tập",
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
                        headerLayout(),
                        layoutCourse(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
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
                            arguments: _educationList[i].id);
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
          height: 200,
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
        Container(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 36, left: 28, right: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Các khái niệm cơ bản",
                          style: TextStyle(
                            fontSize: 20,
                            color: Mytheme.colorBgButtonLogin,
                            fontWeight: FontWeight.w700,
                            fontFamily: "OpenSans-Bold",
                            // decoration: TextDecoration.underline,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
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
                      ],
                    ),
                  ),
              ),
              Expanded(
                flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 56, left:0, right: 10),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          'assets/svg/ic_eduction_home.svg',
                          allowDrawingOutsideViewBox: true,
                        ),
                      )
                  ),
              ),
            ],
          ),
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
