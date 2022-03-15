import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:step_bank/models/info_user.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/models/request_status.dart';
import 'package:step_bank/models/sent_otp.dart';

class RemoteServices {

  static var client = http.Client();
  static var baseURL = 'https://co-opsmart.vn';
  static var signInURL = '$baseURL/api/v1/user/login';
  static var validatePhoneURL = '$baseURL/api/v1/user/validate-phone';
  static var getOtpURL = '$baseURL/api/v1/user/get-otp';
  static var validateOTPURL = '$baseURL/api/v1/user/validate-otp';
  static var signUpOTPURL = '$baseURL/api/v1/user/signup';
  static var updatePasswordURL = '$baseURL/api/v1/user/update-password';
  static var forgotPasswordURL = '$baseURL/api/v1/user/forgot-password';
  static var newsURL = '$baseURL/api/v1/new/list';
  static var listUserGroupURL = '$baseURL/api/v1/setting/list-user-group';
  static var listCityURL = '$baseURL/api/v1/setting/list-cities';
  static var updateUserURL = '$baseURL/api/v1/user/update-info';
  static var loginSocialURL = '$baseURL/api/v1/user/login-social';
  static var reportErrorURL = '$baseURL/api/v1/setting/store-comment-error-app';
  static var faqURL = '$baseURL/api/v1/setting/list-faqs';
  static var updateAvatarURL = '$baseURL/api/v1/user/update-avatar';

  // education

  static var listCourseURL = '$baseURL/api/v1/education/list-course';
  static var listLessonURL = '$baseURL/api/v1/education/list-lesson';
  static var listStudyURL = '$baseURL/api/v1/education/list-study-part';
  static var listExerciseURL = '$baseURL/api/v1/education/list-exercise';
  static var submitQuizURL = '$baseURL/api/v1/education/submit-quizz';



  // static Future<SentOtpModel> postSignInUser(String phone, String type) async {
  //   var c = Completer<SentOtpModel>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/send-otp'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone,
  //         'type' : type
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(SentOtpModel.fromJson(body['data']));
  //   } catch (_) {
  //     c.complete(SentOtpModel.fromJson(body));
  //   }
  //   return c.future;
  // }
  //
  // // validate phone
  // static Future<RequestStatus> validatePhoneUser(String phone) async {
  //   var c = Completer<RequestStatus>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/validate-phone'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(RequestStatus.fromJson(body));
  //   } catch (_) {
  //     c.complete(RequestStatus.fromJson(body));
  //   }
  //   return c.future;
  // }
  //
  // // get otp phone
  // static Future<RequestStatus> getOtpPhone(String phone) async {
  //   var c = Completer<RequestStatus>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/get-otp'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(RequestStatus.fromJson(body));
  //   } catch (_) {
  //     c.complete(RequestStatus.fromJson(body));
  //   }
  //   return c.future;
  // }
  //
  // // validate otp
  // static Future<RequestStatus> validateOtpPhone(String phone, String otp) async {
  //   var c = Completer<RequestStatus>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/validate-otp'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone,
  //         'otp': otp
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(RequestStatus.fromJson(body));
  //   } catch (_) {
  //     c.complete(RequestStatus.fromJson(body));
  //   }
  //   return c.future;
  // }
  //
  // // sign up
  // static Future<InfoUserModel> signUp(String phone, String password, String passwordConfirm) async {
  //   var c = Completer<InfoUserModel>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/signup'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'phone': phone,
  //         'password': password,
  //         'password_confirm': passwordConfirm
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(InfoUserModel.fromJson(body));
  //   } catch (_) {
  //     c.complete(InfoUserModel.fromJson(body));
  //   }
  //   return c.future;
  // }
  //
  // // sign in
  // static Future<LoginModel> signIn(String phone, String password, String deviceType, String fcmToken) async {
  //   var c = Completer<LoginModel>();
  //   // ignore: prefer_typing_uninitialized_variables
  //   var body;
  //   try {
  //     var response = await client.post(
  //       Uri.parse('$baseURL/api/v1/user/login'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //       },
  //       body: jsonEncode(<String, String>{
  //         'username': phone,
  //         'password': password,
  //         'device_type': deviceType,
  //         'fcm_token': fcmToken
  //       }),
  //     );
  //     body = jsonDecode(response.body);
  //     if (kDebugMode) {
  //       print(body);
  //     }
  //     c.complete(LoginModel.fromJson(body));
  //   } catch (_) {
  //     c.complete(LoginModel.fromJson(body));
  //   }
  //   return c.future;
  // }

}