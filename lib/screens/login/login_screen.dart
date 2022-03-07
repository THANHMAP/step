import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/dialog_nomal.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';
import 'package:step_bank/strings.dart';
import 'package:step_bank/util.dart';
import 'package:http/http.dart' as http;
import '../../themes.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = true;
  late ProgressDialog pr;
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    _handleSignOut();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    _phoneController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        doLoginBySocial(_currentUser!, "1");
      }
    });
    _googleSignIn.signInSilently();

    // loadData();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
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

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        backgroundColor: Mytheme.kBackgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: 236,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/bg_top_login.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      // child: Column(
                      //   children: const <Widget>[],
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Container(
                        height: 216,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/img_top_login.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        // child: Column(
                        //   children: const <Widget>[],
                        // ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 86, left: 28),
                      child: Container(
                        width: 76,
                        height: 30,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/img_logo_text.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        // child: Column(
                        //   children: const <Widget>[],
                        // ),
                      ),
                    ),
                  ],
                ),

                // Text("WELCOME", style: Mytheme.textLogin),
                // Text("Please login to continue", style: Mytheme.textLoginSmall),

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
                        height: 46,
                        child: TextFieldWidget(
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
                                    height: 46,
                                    child: TextFieldWidget(
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
                        ],
                      ),
                      // SizedBox(
                      //   height: 46,
                      //   child: TextFieldWidget(
                      //       obscureText: isPasswordVisible,
                      //       hintText: StringText.text_password_input,
                      //       // labelText: 'Password',
                      //       // prefixIcon:
                      //       // const Icon(Icons.person, color: Colors.grey),
                      //       textInputAction: TextInputAction.done,
                      //       suffixIcon: isPasswordVisible
                      //           ? Icons.visibility_off
                      //           : Icons.visibility,
                      //       clickSuffixIcon: () {
                      //         setState(() {
                      //           isPasswordVisible = !isPasswordVisible;
                      //         });
                      //       },
                      //       textController: _passwordController),
                      // ),
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
                      const SizedBox(height: 10),
                      ButtonWidgetBorder(
                          text: StringText.text_try,
                          color: Mytheme.kBackgroundColor,
                          onClicked: () => {}),
                      const SizedBox(height: 10),
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
                            icon: Image.asset("assets/images/icon_google.png"),
                            // tooltip: 'Increase volume by 10',
                            iconSize: 50,
                            onPressed: () {
                              _handleSignIn();
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
                            onPressed: () {},
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
                                  color: Mytheme.colorBgButtonLogin,
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
    );
  }

  Future<void> doLogin() async {
    String? phone, password, typeDevice, fcmToken;
    if (_phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await pr.show();
      phone = _phoneController.text;
      password = _passwordController.text;
      typeDevice = "Android";
      fcmToken = "test";
      var param = jsonEncode(<String, String>{
        'username': phone,
        'password': password,
        'device_type': typeDevice,
        'fcm_token': fcmToken
      });
      APIManager.postAPICallNoNeedToken(RemoteServices.signInURL, param).then(
          (value) async {
        await pr.hide();
        var loginModel = LoginModel.fromJson(value);
        if (loginModel.statusCode == 200) {
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
      GoogleSignInAccount _currentUser, String socialType) async {
    var param = jsonEncode(<String, String>{
      'email': _currentUser.email,
      'social_id': _currentUser.id,
      'social_type': socialType,
      'device_type': "Android",
      'fcm_token': "DCM",
    });

    APIManager.postAPICallNoNeedToken(RemoteServices.loginSocialURL, param).then(
        (value) async {
      await pr.hide();
      var loginModel = LoginModel.fromJson(value);
      if (loginModel.statusCode == 200) {
        await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
        await SPref.instance.set("info_login", json.encode(loginModel.data));
        Get.offAllNamed("/home");
      }
    }, onError: (error) async {
      await pr.hide();
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
  }

  void loadData() async {
    var isLogged = await SPref.instance.get("token");
    if (isLogged != null && isLogged.toString().isNotEmpty) {
      Get.offAndToNamed('/home');
      return;
    }
  }
}
