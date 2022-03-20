import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:step_bank/shared/SPref.dart';

import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class CardSettingWidget extends StatelessWidget {
  final String? title;
  final String? linkUrl;
  final VoidCallback? onClicked;

  const CardSettingWidget({
    Key? key,
    this.title,
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
              offset: const Offset(
                  0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, left: 16, bottom: 18, right: 26),
              child: SvgPicture.asset(
                linkUrl.toString(),
              )
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12,
                      left: 16,
                      bottom: 18,
                      right: 26),
                  child: Text(
                    title ?? "",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Mytheme.colorBgButtonLogin,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-Regular",
                    ),
                  )),
            ),

          ],
        ),
      ),
    );
  }
}