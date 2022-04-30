import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/dialog_confirm.dart';
import '../../models/biometrics_model.dart';
import '../../models/login_model.dart';
import '../../service/custom_exception.dart';
import '../../shared/SPref.dart';
import '../../themes.dart';
import '../../util.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({Key? key}) : super(key: key);

  @override
  _AccountSetupScreentate createState() => _AccountSetupScreentate();
}

class _AccountSetupScreentate extends State<AccountSetupScreen> {
  late ProgressDialog pr;
  late UserData user = UserData();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(text: '123456789');
  bool _isDisableEmail = true;
  String urlActionUsername = "assets/images/ic_edit.png";
  bool _switchValue = false;
  BiometricsData _biometricsData = BiometricsData();

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  bool _isFingerprint = false;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    loadSharedPrefs();
    _checkBiometrics();
    _getAvailableBiometrics();
    loadCheckBiometrics();
    _emailController.text = user.email.toString();
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) return;

    if (availableBiometrics.contains(BiometricType.fingerprint)) {
      setState(() {
        _isFingerprint = true;
      });
    }

    // setState(() {
    //   _availableBiometrics = availableBiometrics;
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
              text: "Cài đặt tài khoản",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    loadImage(user),
                    const SizedBox(height: 20),
                    phoneUser(),
                    const SizedBox(height: 10),
                    passwordUser(),
                    const SizedBox(height: 10),
                    emailUser(),
                    const SizedBox(height: 10),
                    switchFinger(),
                    const SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 12, left: 20, bottom: 18, right: 20),
                      child: Text(
                        "Lưu ý: Tất cả vân tay đã được đăng ký trong thiết bị đều có thể xác thực.",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 14,
                          color: Mytheme.color_82869E,
                          fontWeight: FontWeight.w400,
                          fontFamily: "OpenSans-Regular",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget loadImage(UserData user) {
    if (user.avatar != null && user.avatar.toString().isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 125.0,
              height: 125.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(user.avatar.toString())))),
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                user.name.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  color: Mytheme.color_active,
                  fontWeight: FontWeight.w600,
                  fontFamily: "OpenSans-Semibold",
                ),
              ))
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            width: 125.0,
            height: 125.0,
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/no_image.png"),
                ))),
        Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              user.name.toString(),
              style: const TextStyle(
                fontSize: 18,
                color: Mytheme.color_active,
                fontWeight: FontWeight.w600,
                fontFamily: "OpenSans-Semibold",
              ),
            ))
      ],
    );
  }

  phoneUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, left: 16, bottom: 5, right: 0),
                  child: Text(
                    "Điện thoại",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                      color: Mytheme.colorBgButtonLogin,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-Semibold",
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 10, bottom: 18, right: 10),
                    child: Text(
                      user.phone.toString(),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Mytheme.color_82869E,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  passwordUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Mật khẩu",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 13, right: 0),
                child: TextField(
                  obscureText: true,
                  readOnly: true,
                  controller: TextEditingController()..text = '12345678',
                  autofocus: true,
                  obscuringCharacter: "*",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                  decoration: const InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: '123456789',
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 6, bottom: 0, right: 0),
                child: IconButton(
                  icon: Image.asset("assets/images/ic_edit.png"),
                  // tooltip: 'Increase volume by 10',
                  iconSize: 50,
                  onPressed: () {
                    Get.toNamed('/inputAccountAgain', arguments: user.phone);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  emailUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Email",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 16,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 13, right: 0),
                child: TextField(
                  readOnly: _isDisableEmail,
                  controller: _emailController,
                  autofocus: true,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: user.email ?? "Thêm thông tin",
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 6, bottom: 0, right: 0),
                child: IconButton(
                  icon: Image.asset(urlActionUsername),
                  // tooltip: 'Increase volume by 10',
                  iconSize: 50,
                  onPressed: () {
                    if (_isDisableEmail == true) {
                      setState(() {
                        _isDisableEmail = false;
                        _emailController.text = user.email.toString();
                        urlActionUsername = "assets/images/ic_delete.png";
                      });
                    } else {
                      _isDisableEmail = true;
                      _emailController.text = user.email.toString();
                      urlActionUsername = "assets/images/ic_edit.png";
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  switchFinger() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Đăng nhập vân tay",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Mytheme.colorBgButtonLogin,
                        fontWeight: FontWeight.w600,
                        fontFamily: "OpenSans-Semibold",
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 16, bottom: 18, right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        if (_switchValue) {
                          showDialogConfig();
                        } else {
                          setState(() {
                            if (_isFingerprint && _canCheckBiometrics) {
                              saveBiometrics(_switchValue);
                            } else {
                              Utils.showAlertDialogOneButton(context,
                                  "Điện thoại không hỗ trợ hoặc chưa bật chức năng này trong cài đặt");
                            }
                          });
                        }
                      },
                      child: Image.asset(
                        !_switchValue ? "assets/images/ic_switch_off.png": "assets/images/ic_switch_on.png",
                        width: 60,
                        height: 44,
                      ),
                    ),

                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loadSharedPrefs() async {
    try {
      var isLogged = await SPref.instance.get("info_login");
      var response = json.decode(isLogged.toString());
      setState(() {
        user = UserData.fromJson(response);
        _emailController.text = user.email.toString();
      });
      print(response);
    } on FetchDataException catch (e) {
      print('error caught: $e');
    }
  }

  void loadCheckBiometrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValueBiometrics = prefs.containsKey("biometrics");
    if (checkValueBiometrics) {
      var data = await SPref.instance.get("biometrics");
      setState(() {
        _biometricsData = BiometricsData.fromJson(json.decode(data.toString()));
        _switchValue = _biometricsData.isActivated!;
      });
    }
  }

  showDialogConfig() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: ConfirmDialogBox(
                title: "Tắt xác thực vân tay",
                descriptions:
                    "Tính năng giúp bảo mật tài khoản của bạn tốt hơn. Bạn chắc chắn muốn tắt ?",
                textButtonLeft: "Huỷ",
                textButtonRight: "Tắt xác thực",
                onClickedConfirm: () async {
                  saveBiometrics(false);
                  setState(() {
                    _switchValue = false;
                  });
                  Navigator.pop(context, "");
                },
                onClickedCancel: () {
                  Navigator.pop(context, "");
                },
              ));
        });
  }

  Future<void> saveBiometrics(bool active) async {
    _switchValue = true;
    _biometricsData.isActivated = active;
    await SPref.instance.set("biometrics", json.encode(_biometricsData));
  }
}
