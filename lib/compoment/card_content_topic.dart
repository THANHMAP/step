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
  final bool? isFinish;
  final bool? hideImageRight;
  final VoidCallback? onClicked;

  const CardContentTopicWidget({
    Key? key,
    this.title,
    this.type,
    this.isFinish,
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
            Expanded(
              flex: 1,
              child:
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: SvgPicture.asset(urlIcon(type!)),
                          onPressed: onClicked,
                        ),
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
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
            ),

            Visibility(
              visible: hideImageRight == true ? true : false,
              child: Expanded(
                flex: 1,
                child:
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: Image.asset(urlIsFinish(isFinish ?? false)), onPressed: () {  },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Visibility(
              visible: hideImageRight == true ? false : true,
              child: Expanded(
                flex: 1,
                child:
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: SvgPicture.asset("assets/svg/ic_download.svg"),
                          onPressed: onClicked,
                        ),
                      )
                    ],
                  ),
                ),
              ),),

          ],
        ),
      ),
    );
  }

  String urlIsFinish(bool isFinish) {
    if (isFinish) {
      return "assets/images/img_finish.png";
    }
    return "assets/images/img_no_finish.png";
  }

  String urlIcon(int type){
    if(type == 1){
      return "assets/svg/text.svg";
    } else if(type == 5){
      return "assets/svg/question.svg";
    } else if(type == 2){
      return "assets/svg/video.svg";
    } else if(type == 6) {
      return "assets/svg/audio.svg";
    } else if(type == 4) {
      return "assets/svg/play_circle_outline.svg";
    }
    return "assets/svg/slideShare.svg";
  }
}
