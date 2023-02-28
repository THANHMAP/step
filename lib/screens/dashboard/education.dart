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
import '../../compoment/info_dialog.dart';
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
                showRight: true,
                onClickedRight: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
                          child: WillPopScope(
                              onWillPop: () {
                                return Future.value(false);
                              },
                              child: InfoDialogBox(
                                title: "",
                                descriptions: "<p style=\"text-align:justify\">Phần học tập gồm c&aacute;c nội dung đa dạng để gi&uacute;p bạn hiểu r&otilde; hơn về t&igrave;nh h&igrave;nh t&agrave;i ch&iacute;nh của m&igrave;nh. VD: thiết lập mục ti&ecirc;u tiết kiệm, chuẩn bị để đăng k&yacute; vay vốn với tổ chức t&agrave;i ch&iacute;nh, điều chỉnh ng&acirc;n s&aacute;ch để sử dụng tiền cho những hạng mục quan trọng nhất&hellip;</p>" +

                              "<p style=\"text-align:justify\">Nội dung học tập được sắp xếp theo từng chủ đề v&agrave; c&aacute;c b&agrave;i học kh&aacute;c nhau. Mỗi b&agrave;i học bao gồm c&aacute;c hoạt động tương t&aacute;c m&agrave; bạn c&oacute; thể t&igrave;m hiểu theo tiến độ ri&ecirc;ng của m&igrave;nh, v&agrave;o bất kỳ l&uacute;c n&agrave;o, v&agrave; từ bất kỳ đ&acirc;u.</p>" +

                              "<p style=\"text-align:justify\">Bạn cũng c&oacute; thể theo d&otilde;i tiến độ học tập của m&igrave;nh v&agrave; ph&acirc;n bổ lại thời gian để ho&agrave;n thiện tất cả c&aacute;c b&agrave;i học theo nhu cầu. Ngo&agrave;i ra, bạn c&ograve;n c&oacute; thể học lại/l&agrave;m lại c&aacute;c hoạt động/b&agrave;i học nhiều lần để đảm bảo hiểu hết tất cả c&aacute;c nội dung.</p>" +

                              "<p style=\"text-align:justify\">Ch&uacute;c bạn c&oacute; trải nghiệm học tập th&agrave;nh c&ocirc;ng!</p>",
                                textButton: "Đóng",
                                hideButtonLink: true,
                              )),
                        );
                      });
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
