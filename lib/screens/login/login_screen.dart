import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';
import 'package:step_bank/strings.dart';
import 'package:step_bank/util.dart';
import 'package:http/http.dart' as http;
import '../../models/biometrics_model.dart';
import '../../themes.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart' as apple;

import 'authService.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<bool> _isAvailableFuture = apple.TheAppleSignIn.isAvailable();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;
  late ProgressDialog pr;
  GoogleSignInAccount? _currentUser;

  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool _canCheckBiometrics = false;
  bool _isFingerprint = false;
  bool _isDeviceSupported = false;
  List<BiometricType>? _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  BiometricsData _biometricsData = BiometricsData();
  var platform = "Android";
  String token = "";

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    _handleSignOut();
    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "IOS";
    }
    FirebaseMessaging.instance.getToken().then((value) {
      token = value!;
    });
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    loadCheckBiometrics();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        doLoginBySocial(_currentUser!.email, _currentUser!.id, "1");
      }
    });
    _googleSignIn.signInSilently();

    auth.isDeviceSupported().then((isSupported) {
      // setState(() => _supportState = isSupported ? _SupportState.supported : _SupportState.unsupported),
      setState(() {
        if (isSupported == _SupportState.supported) {
          _isDeviceSupported = true;
        } else {
          _isDeviceSupported = false;
        }
      });
    });
    _checkBiometrics();
    _getAvailableBiometrics();
    // loadData();
  }

  void login() async {
    final result =
        await FacebookAuth.i.login(permissions: ["public_profile", "email"]);

    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "email,name",
      );
      // doLoginBySocial(userData['email'].toString(), userData['id'].toString(), "2", platform, "");
      print(userData['email'].toString());
    }
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

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    if (authenticated) {
      doLoginWithBiometrics(_biometricsData.phone.toString(),
          _biometricsData.password.toString());
    } else {}

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void _loginFacebook() async {
    final result = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);
    if (result.status == LoginStatus.success) {
      final userData = await FacebookAuth.i.getUserData(
        fields: "email,name",
      );
      doLoginBySocial(
          userData['email'].toString(), userData['id'].toString(), "2");
      print(userData['email'].toString());
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          backgroundColor: Mytheme.kBackgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 246,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/head_login.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringText.text_phone,
                            textAlign: TextAlign.left,
                            style: Mytheme.textSubTitle,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 56,
                          child: TextFieldWidget(
                              textAlign: true,
                              maxLines: 1,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              textInputAction: TextInputAction.next,
                              obscureText: false,
                              hintText: StringText.text_phone_input,
                              // labelText: "Phone number",
                              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                              suffixIcon: Icons.close,
                              clickSuffixIcon: () => _phoneController.clear(),
                              textController: _phoneController),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StringText.text_password,
                            textAlign: TextAlign.left,
                            style: Mytheme.textSubTitle,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 6,
                                child: Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: SizedBox(
                                      height: 56,
                                      child: TextFieldWidget(
                                          textAlign: true,
                                          maxLines: 1,
                                          obscureText: isPasswordVisible,
                                          hintText:
                                          StringText.text_password_input,
                                          // labelText: 'Password',
                                          // prefixIcon:
                                          // const Icon(Icons.person, color: Colors.grey),
                                          textInputAction: TextInputAction.done,
                                          suffixIcon: isPasswordVisible
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          clickSuffixIcon: () {
                                            setState(() {
                                              isPasswordVisible =
                                              !isPasswordVisible;
                                            });
                                          },
                                          textController: _passwordController),
                                    ))),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (_isFingerprint && _canCheckBiometrics) {
                                    checkBiometrics();
                                  } else {
                                    Utils.showAlertDialogOneButton(context,
                                        "Điện thoại không hỗ trợ hoặc chưa bật chức năng này trong cài đặt");
                                  }
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      height: 44,
                                      width: 44,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/bg_fingerprint.png"),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, left: 8, bottom: 8, right: 12),
                                      child: Container(
                                        height: 24,
                                        width: 27,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/fingerprint.png"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed('/forgotPassword');
                            },
                            child: const Text(
                              StringText.text_forgot_password,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.colorBgButtonLogin,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                                decoration: TextDecoration.underline,
                              ),
                            )),
                        const SizedBox(height: 10),
                        ButtonWidget(
                            text: StringText.text_login,
                            color: Mytheme.colorBgButtonLogin,
                            onClicked: () => doLogin()),
                        // const SizedBox(height: 10),
                        // ButtonWidgetBorder(
                        //     text: StringText.text_try,
                        //     color: Mytheme.kBackgroundColor,
                        //     onClicked: () => {}),
                        const SizedBox(height: 10),

                      if (Platform.isIOS) ...[
                        apple.AppleSignInButton(
                          style: apple.ButtonStyle.black,
                          buttonText: "Đăng nhập bằng Apple",
                          onPressed: () => _signInWithApple(context),
                        ),
                        const SizedBox(height: 5),
                        ],


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(StringText.text_login_different),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon:
                              Image.asset("assets/images/icon_google.png"),
                              // tooltip: 'Increase volume by 10',
                              iconSize: 50,
                              onPressed: () async {
                                // _handleSignIn();
                                // signInWithGoogle();
                                _signInWithGoogle(context);
                              },
                            ),
                            const Image(
                              image: AssetImage('assets/images/img_col.png'),
                              fit: BoxFit.fill,
                              width: 2,
                            ),
                            IconButton(
                              icon: Image.asset("assets/images/icon_face.png"),
                              // tooltip: 'Increase volume by 10',
                              iconSize: 50,
                              onPressed: () {
                                _loginFacebook();
                              },
                            ),

                          ],
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              StringText.text_no_register,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.color_121212,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Get.toNamed('/register');
                                },
                                child: const Text(
                                  StringText.text_register,
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Mytheme.colorTextSubTitle,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "OpenSans-Regular",
                                    decoration: TextDecoration.underline,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            image:
                            AssetImage('assets/images/img_line_horizone.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Image(
                            image: AssetImage('assets/images/img_bank.png'),
                            fit: BoxFit.fill,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  Future<void> doLogin() async {
    String? phone, password;
    if (_phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await pr.show();
      phone = _phoneController.text;
      password = _passwordController.text;
      var param = jsonEncode(<String, String>{
        'username': phone,
        'password': password,
        'device_type': platform,
        'fcm_token': token
      });
      APIManager.postAPICallNoNeedToken(RemoteServices.signInURL, param).then(
          (value) async {
        await pr.hide();
        var loginModel = LoginModel.fromJson(value);
        if (loginModel.statusCode == 200) {
          saveBiometrics(false, phone.toString(), password.toString());
          await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
          await SPref.instance.set("info_login", json.encode(loginModel.data));
          Get.offAllNamed("/home");
        }
      }, onError: (error) async {
        await pr.hide();
        var statuscode = error.toString();
        if (statuscode.contains("Unauthorised:")) {
          var unauthorised = "Unauthorised:";
          var test =
              statuscode.substring(unauthorised.length, statuscode.length);
          var response = json.decode(test.toString());
          var message = response["message"];
          Utils.showAlertDialogOneButton(context, message);
        } else {
          print("Error == $error");
          Utils.showAlertDialogOneButton(context, error);
        }
      });
    }
  }

  Future<void> doLoginBySocial(
      String email, String id, String socialType) async {
    var param = jsonEncode(<String, String>{
      'email': email,
      'social_id': id,
      'social_type': socialType,
      'device_type': platform,
      'fcm_token': token
    });
    await pr.show();
    APIManager.postAPICallNoNeedToken(RemoteServices.loginSocialURL, param)
        .then((value) async {
      var loginModel = LoginModel.fromJson(value);
      if (loginModel.statusCode == 200) {
        await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
        await SPref.instance.set("info_login", json.encode(loginModel.data));
        Get.offAllNamed("/home");
      }
    }, onError: (error) async {
      var statuscode = error.toString();
      if (statuscode.contains("Unauthorised:")) {
        var unauthorised = "Unauthorised:";
        var test = statuscode.substring(unauthorised.length, statuscode.length);
        var response = json.decode(test.toString());
        var message = response["message"];
        Utils.showAlertDialogOneButton(context, message);
      } else {
        print("Error == $error");
        Utils.showAlertDialogOneButton(context, error);
      }
      await pr.hide();
    });
    await pr.hide();
  }

  Future<void> doLoginWithBiometrics(String phone, String password) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'username': phone,
      'password': password,
      'device_type': platform,
      'fcm_token': token
    });
    APIManager.postAPICallNoNeedToken(RemoteServices.signInURL, param).then(
        (value) async {
      var loginModel = LoginModel.fromJson(value);
      if (loginModel.statusCode == 200) {
        await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
        await SPref.instance.set("info_login", json.encode(loginModel.data));
        Get.offAllNamed("/home");
      }
    }, onError: (error) async {
      var statuscode = error.toString();
      if (statuscode.contains("Unauthorised:")) {
        var unauthorised = "Unauthorised:";
        var test = statuscode.substring(unauthorised.length, statuscode.length);
        var response = json.decode(test.toString());
        var message = response["message"];
        Utils.showAlertDialogOneButton(context, message);
      } else {
        print("Error == $error");
        Utils.showAlertDialogOneButton(context, error);
      }
    });
    await pr.hide();
  }

  void loadData() async {
    var isLogged = await SPref.instance.get("token");
    if (isLogged != null && isLogged.toString().isNotEmpty) {
      Get.offAndToNamed('/home');
      return;
    }
  }

  void loadCheckBiometrics() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValueBiometrics = prefs.containsKey("biometrics");
    if (checkValueBiometrics) {
      var data = await SPref.instance.get("biometrics");
      setState(() {
        _biometricsData = BiometricsData.fromJson(json.decode(data.toString()));
      });
    }
  }

  void saveBiometrics(bool active, String phone, String password) {
    _biometricsData.isActivated = active;
    _biometricsData.phone = phone;
    _biometricsData.password = password;
    SPref.instance.set("biometrics", json.encode(_biometricsData));
  }

  void checkBiometrics() {
    if (_biometricsData.isActivated == true) {
      _authenticate();
    } else {
      Utils.showAlertDialogOneButton(
          context, "Vui lòng đang nhập và mở chức năng này trong cài đặt");
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithApple(
          scopes: [apple.Scope.email, apple.Scope.fullName]);
      print('uid: ${user.uid} ---- email: ${user.email}');
      doLoginBySocial(
          user.email.toString(), user.uid.toString(), "2");
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final user = await authService.signInWithGoogle(context: context);
      print('_signInWithGoogle uid: ${user?.uid} ---- email: ${user?.email}');
      // doLoginBySocial(
      //     user.email.toString(), user.uid.toString(), "2");
    } catch (e) {
      // TODO: Show alert here
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    log('datacredential: $credential');
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

}
