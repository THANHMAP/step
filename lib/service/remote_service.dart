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
  // static var baseURL = 'https://co-opsmart.vn';
  // static var baseURL = 'https://staging.co-opsmart.vn';
  static var baseURL = "https://internal.co-opsmart.vn";
  static var signInURL = '$baseURL/api/v1/user/login';
  static var validatePhoneURL = '$baseURL/api/v1/user/validate-phone';
  static var getOtpURL = '$baseURL/api/v1/user/get-otp';
  static var validateOTPURL = '$baseURL/api/v1/user/validate-otp';
  static var signUpOTPURL = '$baseURL/api/v1/user/signup';
  static var updatePasswordURL = '$baseURL/api/v1/user/update-password';
  static var forgotPasswordURL = '$baseURL/api/v1/user/forgot-password';
  static var newsURL = '$baseURL/api/v1/new/list';
  static var newDetailURL = '$baseURL/api/v1/new/detail';
  static var listUserGroupURL = '$baseURL/api/v1/setting/list-user-group';
  static var listCityURL = '$baseURL/api/v1/setting/list-cities';
  static var updateUserURL = '$baseURL/api/v1/user/update-info';
  static var loginSocialURL = '$baseURL/api/v1/user/login-social';
  static var reportErrorURL = '$baseURL/api/v1/setting/store-comment-error-app';
  static var userMedalsURL = '$baseURL/api/v1/user/user-medals';


  static var faqURL = '$baseURL/api/v1/setting/list-faqs';
  static var updateAvatarURL = '$baseURL/api/v1/user/update-avatar';
  static var listBannerPromotionURL = '$baseURL/api/v1/setting/list-banner-promotion';
  static var trackingURL = '$baseURL/api/v1/tracking/behavior';
  static var validatePasswordUserURL = '$baseURL/api/v1/user/validate-password';

  static var leaderBoardURL = '$baseURL/api/v1/user/leader-board';
  static var positionLeaderBoardURL = '$baseURL/api/v1/user/position-leader-board';
  static var checkQuizdURL = '$baseURL/api/v1/education/check-user-quizz';
  static var userAnswersdURL = '$baseURL/api/v1/education/user-answers';

  static var listContactURL = '$baseURL/api/v1/setting/list-contact';



  // education

  static var listCourseURL = '$baseURL/api/v1/education/list-course';
  static var listLessonURL = '$baseURL/api/v1/education/list-lesson';
  static var listStudyURL = '$baseURL/api/v1/education/list-study-part';
  static var listExerciseURL = '$baseURL/api/v1/education/list-exercise';
  static var submitQuizURL = '$baseURL/api/v1/education/submit-quizz';

  // tool

  static var listToolURL = '$baseURL/api/v1/tool/list';
  static var listItemToolURL = '$baseURL/api/v1/tool/list-user';
  static var storeDataItemToolURL = '$baseURL/api/v1/tool/store-data';
  static var deleteItemToolURL = '$baseURL/api/v1/tool/delete-my-tool';
  static var sampleDataURL = '$baseURL/api/v1/tool/data-sample';
  static var getDetailItemToolURL = '$baseURL/api/v1/tool/detail-tool-calculate';
  static var updateItemToolURL = '$baseURL/api/v1/tool/update-data-tool';
  static var listWithDrawToolURL = '$baseURL/api/v1/tool/list-with-draw';
  static var storeWithDrawToolURL = '$baseURL/api/v1/tool/store-with-draw';

  static var listNotificationURL = '$baseURL/api/v1/setting/list-notification';

  static var reportDataDrawToolURL = '$baseURL/api/v1/tool/report-with-draw';
  static var reportDetailDataDrawToolURL = '$baseURL/api/v1/tool/report-detail-with-draw';

  static var listWithDrawFilterToolURL = '$baseURL/api/v1/tool/list-with-draw-filter';
  static var nextRepaymentDateToolURL = '$baseURL/api/v1/tool/next-repayment-date';
  static var numberNotificationURL = '$baseURL/api/v1/setting/number-notification';

  static var deleteUserURL = '$baseURL/api/v1/user/delete';
  static var getListCredit = '$baseURL/api/v1/setting/list-credit';

}