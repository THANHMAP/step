import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../themes.dart';

class AppbarWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final bool? hideBack;
  final bool? showRight;
  final bool? showTextRight;
  final VoidCallback? onClicked;
  final VoidCallback? onClickedRight;

  const AppbarWidget({
    Key? key,
    this.text,
    this.color,
    this.hideBack,
    this.showRight = false,
    this.showTextRight = false,
    this.onClicked,
    this.onClickedRight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          color: Mytheme.colorBgButtonLogin,
        ),
        Container(
          height: 68,
          alignment: Alignment.center,
          color: Mytheme.colorBgButtonLogin,
          child: Row(
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
                      if(hideBack != true)...[
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            icon: Image.asset("assets/images/icon_back.png"),
                            onPressed: onClicked,
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child:  Center(
                  child:  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 0),
                    child: Text(
                      text!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: "OpenSans-Semibold",
                        // decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child:
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(showRight != false)...[
                        if (showTextRight == true)...[
                          Center(
                            child: InkWell(
                              onTap: onClickedRight,
                              child:  const Padding(
                                padding: EdgeInsets.only(left: 0, right: 0),
                                child: Text(
                                  "Lưu",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "OpenSans-Semibold",
                                    // decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else ... [
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              icon: Image.asset("assets/images/img_question.png"),
                              onPressed: onClickedRight,
                            ),
                          )
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
