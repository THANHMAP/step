import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import 'package:step_bank/shared/SPref.dart';

import '../strings.dart';
import '../themes.dart';
import 'dialog_confirm.dart';

class CardItemToolWidget extends StatelessWidget {
  final String? title;
  final String? date;
  final VoidCallback? onClickedView;
  final VoidCallback? onClickedDelete;

  const CardItemToolWidget({
    Key? key,
    this.title,
    this.date,
    this.onClickedView,
    this.onClickedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, bottom: 6, right: 16),
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
                              fontSize: 18,
                              color: Mytheme.colorBgButtonLogin,
                              fontWeight: FontWeight.w600,
                              fontFamily: "OpenSans-SemiBold",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, bottom: 18, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Lập ngày ${convert(date?? "")}",
                            // textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Mytheme.color_82869E,
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 8, bottom: 18, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Expanded(
                            child:  InkWell(
                              onTap: onClickedView,
                              child: Container(
                                height: 31,
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Mytheme.color_0xFFBDE8FF,
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
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 12, bottom: 5, right: 12),
                                  child:     Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Xem",
                                      // textAlign: TextAlign.start,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_121212,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),

                              ),
                            ),
                        ),

                        Expanded(
                            child: InkWell(
                              onTap: onClickedDelete,
                              child:   Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16),
                                  child: Container(
                                    height: 31,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Mytheme.color_0xFFFFCFC9,
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 0, bottom: 5, right: 0),
                                      child:     Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Xóa",
                                          // textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Mytheme.color_121212,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans-Regular",
                                          ),
                                        ),
                                      ),
                                    ),

                                  )
                              ),
                            ),
                        ),

                      ],
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),

      ),
    );
  }

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }
}
