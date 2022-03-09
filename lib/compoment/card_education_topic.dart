import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:step_bank/shared/SPref.dart';
import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class CardEducationTopicWidget extends StatelessWidget {
  final String? title;
  final String? numberLesson;
  final String? linkUrl;
  final VoidCallback? onClicked;

  const CardEducationTopicWidget({
    Key? key,
    this.title,
    this.numberLesson,
    this.linkUrl,
    this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClicked,
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
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 20, bottom: 18, right: 0),
                child: Text(
                  "01",
                  // textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Mytheme.color_BCBFD6,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-SemiBold",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, left: 0, bottom: 18, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title ?? "",
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
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 0, bottom: 0, right: 10),
                child: CircularPercentIndicator(
                  radius: 30.0,
                  animation: true,
                  animationDuration: 1200,
                  lineWidth: 6.0,
                  percent: 1,
                  center: new Text(
                    "3/3",
                    style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Mytheme.color_DCDEE9,
                  progressColor: Mytheme.color_0xFF30CD60,
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
