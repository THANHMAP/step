import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Mytheme {
  static final TextStyle textIntro = GoogleFonts.nunito(
      fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white);
  static final TextStyle textIntroSmall = GoogleFonts.nunito(
      fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white);
  static final TextStyle textLogin = GoogleFonts.nunito(
      fontSize: 48, fontWeight: FontWeight.w800, color: Colors.green);
  static final TextStyle textLoginSmall = GoogleFonts.nunito(
      fontSize: 20, fontWeight: FontWeight.w400, color: Colors.green);
  static final TextStyle hAppTitle = GoogleFonts.grandHotel(
      fontSize: 25, color: Colors.pink, fontWeight: FontWeight.w500);
  static final TextStyle textName = GoogleFonts.dongle(
      fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500);
  static const TextStyle textSubTitle = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, fontFamily: "OpenSans-Semibold", color: colorTextSubTitle);

  static const TextStyle textHint = TextStyle(
      fontSize: 16, fontWeight: FontWeight.w600, fontFamily: "OpenSans-Regular", color: colorTextSubTitle);


  static const kPrimaryColor = Color(0xFFFF7643);
  static const kBackgroundColor = Color(0xFFFFFFFF);
  static const kSecondaryColor = Color(0xFF979797);
  static const kTextColor = Color(0xFF272727);
  static const kMenuColor = Color(0xFFFF7643);
  static const kShadowColor = Color(0xFFEDEDED);
  static const kAnimationDuration = Duration(milliseconds: 200);


  static const colorTextSubTitle = Color(0xFF1B1D29);
  static const colorTextDivider = Color(0xFFEFF0FB);
  static const colorBgButtonLogin = Color(0xFF031A6E);
  static const colorBgMain = Color(0xFFE5E5E5);
  static const color_121212 = Color(0xFF121212);
  static const color_434657 = Color(0xFF434657);
  static const color_44494D = Color(0xFF44494D);
  static const color_1990FF = Color(0xFF1990FF);
  static const color_82869E = Color(0xFF82869E);
  static const color_BCBFD6 = Color(0xFFBCBFD6);
  static const color_active = Color(0xFF031A6E);
  static const color_inActive = Color(0xFFBCBFD6);
  static const color_DCDEE9 = Color(0xFFDCDEE9);
  static const color_0xFF30CD60 = Color(0xFF30CD60);
  static const color_0xFFA7ABC3 = Color(0xFFA7ABC3);




  static const kYellowColor = Color(0xFFF2A900);

  static const double kBorderRadius = 28;
}
