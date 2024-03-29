import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../themes.dart';

class AppbarWidget extends StatelessWidget {
  final String? text;
  final Color? color;
  final bool? hideBack;
  final VoidCallback? onClicked;

  const AppbarWidget({
    Key? key,
    this.text,
    this.color,
    this.hideBack,
    this.onClicked,
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
          child: Stack(
            children: <Widget>[
              Center(
                child: Text(
                  text!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                    // decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18),
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
            ],
          ),
        ),
      ],
    );
  }
}
