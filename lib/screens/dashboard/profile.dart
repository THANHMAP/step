import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

import '../../themes.dart';
import '../../util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
          backgroundColor: Mytheme.kBackgroundColor,
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
                                linkUrl: 'assets/images/img_info.png',
                                onClicked: () {
                                  Get.toNamed('/editProfile');
                                },
                              ),
                              const SizedBox(height: 10),
                              // bảng xếp hạng
                              CardSettingWidget(
                                title: "Bảng xếp hạng",
                                linkUrl: 'assets/images/img_xephang.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              //tool
                              CardSettingWidget(
                                title: "Các công cụ của tôi",
                                linkUrl: 'assets/images/img_tool.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              //setting
                              CardSettingWidget(
                                title: "Cài đặt tài khoản",
                                linkUrl: 'assets/images/img_setting.png',
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
                                      });
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
                              const SizedBox(height: 10),
                              //face
                              CardSettingWidget(
                                title: "Kết nối trên MXH",
                                linkUrl: 'assets/images/img_fb.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              //lien he
                              CardSettingWidget(
                                title: "Liên hệ",
                                linkUrl: 'assets/images/img_lienhe.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              // cau hoi
                              CardSettingWidget(
                                title: "Câu hỏi thường gặp",
                                linkUrl: 'assets/images/img_cauhoi.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),

                              // bao cao loi
                              CardSettingWidget(
                                title: "Báo cáo lỗi",
                                linkUrl: 'assets/images/img_baocaoloi.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),

                              // bao cao loi
                              CardSettingWidget(
                                title: "Điều khoản sử dụng",
                                linkUrl: 'assets/images/img_dieukhoan.png',
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
                                      });
                                },
                              ),
                              const SizedBox(height: 10),
                              // logout
                              CardSettingWidget(
                                title: StringText.text_logout,
                                linkUrl: 'assets/images/ic_logout.png',
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
                                      });
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
