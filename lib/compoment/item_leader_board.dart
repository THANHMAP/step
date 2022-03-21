import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:step_bank/shared/SPref.dart';
import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class ItemLeaderBoardWidget extends StatelessWidget {
  final String? name;
  final int? numberStt;
  final String? avatar;
  final int score;
  final VoidCallback? onClicked;

  const ItemLeaderBoardWidget({
    Key? key,
    this.name,
    this.numberStt,
    required this.avatar,
    required this.score,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: getColor(numberStt ?? 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 20, bottom: 18, right: 0),
                child: Text(
                  "$numberStt",
                  // textAlign: TextAlign.start,
                  style:  TextStyle(
                    fontSize: 24,
                    color: getColorText(numberStt ?? 1),
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-SemiBold",
                  ),
                ),
              ),
            ),
            Container(
                width: 43.0,
                height: 43.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(avatar.toString())))),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 10, bottom: 18, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        name ?? "",
                        // textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Mytheme.colorBgButtonLogin,
                          fontWeight: FontWeight.w400,
                          fontFamily: "OpenSans-Regular",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 0, bottom: 0, right: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "$score điểm",
                    style:  TextStyle(
                      fontSize: 16,
                      color: getColorText(numberStt ?? 1),
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-SemiBold",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColor(int value) {
    if (value <= 3) {
      return Mytheme.color_0xFFCCECFB;
    }
    return Mytheme.colorBgMain;
  }

  Color getColorText(int value) {
    if (value <= 3) {
      return Mytheme.colorBgButtonLogin;
    }
    return Mytheme.color_0xFFA7ABC3;
  }

}
