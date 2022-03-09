import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:step_bank/shared/SPref.dart';

import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class CardEducatonWidget extends StatelessWidget {
  final String? title;
  final String? numberLesson;
  final String? linkUrl;
  final VoidCallback? onClicked;

  const CardEducatonWidget({
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
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 20, bottom: 18, right: 26),
              child: Image(
                image: AssetImage(linkUrl ?? ""),
                fit: BoxFit.fill,
                width: 52,
                height: 52,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, bottom: 18, right: 26),
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      numberLesson ?? "",
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
          ],
        ),
      ),
    );
  }
}
