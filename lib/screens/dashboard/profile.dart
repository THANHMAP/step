import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/card_setting.dart';
import 'package:step_bank/compoment/dialog_confirm.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/dialog_nomal.dart';
import '../../themes.dart';
import '../../util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, this.controller}) : super(key: key);
  final PersistentTabController? controller;
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
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
                text: StringText.text_tai_khoan,
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
                          padding: const EdgeInsets.only(
                              top: 10, left: 15, right: 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Tổng quát",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Mytheme.colorBgButtonLogin,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-Semibold",
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              // thong tin ca nhan
                              CardSettingWidget(
                                title: "Thông tin cá nhân",
                                linkUrl: 'assets/svg/ic_info.svg',
                                onClicked: () {
                                  Get.toNamed('/editProfile');
                                  // Get.toNamed('/educationTopic');
                                },
                              ),
                              const SizedBox(height: 10),
                              // bảng xếp hạng
                              CardSettingWidget(
                                title: "Bảng xếp hạng",
                                linkUrl: 'assets/svg/ic_rank.svg',
                                onClicked: () {
                                  Get.toNamed('/leaderBoardScreen');
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return WillPopScope(
                                  //           onWillPop: () {
                                  //             return Future.value(false);
                                  //           },
                                  //           child: ConfirmDialogBox(
                                  //             title: "Thoát đăng nhập",
                                  //             descriptions:
                                  //                 "Đăng xuất khỏi tài khoản này?",
                                  //             onClickedConfirm: () async {
                                  //               await SPref.instance
                                  //                   .set("token", "");
                                  //               Get.offAllNamed("/login"
                                  //                   "");
                                  //             },
                                  //             onClickedCancel: () {
                                  //               Navigator.pop(context, "");
                                  //             },
                                  //           ));
                                  //     });
                                },
                              ),
                              const SizedBox(height: 10),
                              //tool
                              CardSettingWidget(
                                title: "Các công cụ của tôi",
                                linkUrl: 'assets/svg/ic_tool.svg',
                                onClicked: () {
                                  widget.controller?.index = 1;
                                },
                              ),
                              const SizedBox(height: 10),
                              //setting
                              CardSettingWidget(
                                title: "Cài đặt tài khoản",
                                linkUrl: 'assets/svg/ic_setting.svg',
                                onClicked: () {
                                  Get.toNamed('/setupAccount');
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Tổng quát",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Mytheme.colorBgButtonLogin,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-Semibold",
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 10),
                              // //face
                              // CardSettingWidget(
                              //   title: "Kết nối trên MXH",
                              //   linkUrl: 'assets/svg/ic_face.svg',
                              //   onClicked: () {
                              //   },
                              // ),
                              const SizedBox(height: 10),
                              //lien he
                              CardSettingWidget(
                                title: "Liên hệ",
                                linkUrl: 'assets/svg/ic_lienhe.svg',
                                onClicked: () {
                                  Get.toNamed('/contactScreen');
                                },
                              ),
                              const SizedBox(height: 10),
                              // cau hoi
                              CardSettingWidget(
                                title: "Câu hỏi thường gặp",
                                linkUrl: 'assets/svg/ic_fqa.svg',
                                onClicked: () {
                                  Get.toNamed('/faq');
                                },
                              ),
                              const SizedBox(height: 10),

                              // bao cao loi
                              CardSettingWidget(
                                title: "Báo cáo lỗi",
                                linkUrl: 'assets/svg/ic_error.svg',
                                onClicked: () {
                                  Get.toNamed('/reportError');
                                },
                              ),
                              const SizedBox(height: 10),

                              // bao cao loi
                              CardSettingWidget(
                                title: "Điều khoản sử dụng",
                                linkUrl: 'assets/svg/ic_dieukhoan.svg',
                                onClicked: () {
                                  Get.toNamed('/termScreen');
                                },
                              ),
                              const SizedBox(height: 10),
                              // logout
                              CardSettingWidget(
                                title: StringText.text_logout,
                                linkUrl: 'assets/svg/ic_dangxuat.svg',
                                onClicked: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return WillPopScope(
                                            onWillPop: () {
                                              return Future.value(false);
                                            },
                                            child: ConfirmDialogBox(
                                              title: "Thoát đăng nhập",
                                              descriptions:
                                                  "Đăng xuất khỏi tài khoản này?",
                                              onClickedConfirm: () async {
                                                await SPref.instance
                                                    .set("token", "");
                                                Get.offAllNamed("/login"
                                                    "");
                                              },
                                              onClickedCancel: () {
                                                Navigator.pop(context, "");
                                              },
                                            ));
                                      }
                                      );
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
