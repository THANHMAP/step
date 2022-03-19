import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:step_bank/shared/SPref.dart';
import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class CardContentTopicWidget extends StatelessWidget {
  final String? title;
  final int? type;
  final bool? hideImageRight;
  final VoidCallback? onClicked;

  const CardContentTopicWidget({
    Key? key,
    this.title,
    this.type,
    this.hideImageRight,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 20, bottom: 10, right: 0),
              child: IconButton(
                icon: SvgPicture.asset(urlIcon(type!)),
                iconSize: 10,
                onPressed: onClicked,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, left: 0, bottom: 0, right: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title ?? "",
                        // textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
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

            if (hideImageRight == false) ...[
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 40, bottom: 0, right: 10),
                    child: SizedBox(
                      width: 60,
                      child: IconButton(
                        icon: SvgPicture.asset("assets/svg/ic_download.svg"),
                        onPressed: onClicked,
                      ),
                    )),
              ),
            ]
          ],
        ),
      ),
    );
  }

  String urlIcon(int type){
    if(type == 1){
      return "assets/svg/ic_file.svg";
    } else if(type == 5){
      return "assets/svg/ic_quiz.svg";
    } else if(type == 2){
      return "assets/svg/ic_video.svg";
    }
    return "assets/svg/ic_file.svg";
  }
}
