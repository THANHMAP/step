import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'models/result.dart';
import 'models/study_model.dart';

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
  static List<ContentQuizz>? questionsGlobals = null;
  static List<Result> resultQuestion = [];

  static const Color kSecondaryColor = Color(0xFF8B94BC);
  static const Color kGreenColor = Color(0xFF6AC259);
  static const Color kRedColor = Color(0xFFE92E30);
  static const Color kGrayColor = Color(0xFFC1C1C1);
  static const Color kBlackColor = Color(0xFF101010);
  static const LinearGradient kPrimaryGradient = LinearGradient(
    colors: [Color(0xFF46A0AE), Color(0xFF00FFCB)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const double kDefaultPadding = 20.0;
}