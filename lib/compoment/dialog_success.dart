import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../constants.dart';
import '../themes.dart';

class SuccessDialogBox extends StatelessWidget {
  // final String? title, descriptions, text;
  final String? title;
  final String? descriptions;
  final String? textButton;
  final VoidCallback? onClickedConfirm;

  const SuccessDialogBox(
      {Key? key,
        this.title,
        this.descriptions,
        this.textButton,
        this.onClickedConfirm
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: Dialog(
          insetPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context),
        ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 0,
              top: 0,
              right: 0,
              bottom: Constants.padding),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // boxShadow:  [
            //   BoxShadow(
            //       color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            // ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 36,
              ),
              Align(
                alignment: Alignment.center,
                child: SvgPicture.asset("assets/svg/ic_success.svg"),
              ),

              Padding(
                padding:
                EdgeInsets.only(top: 12, left: 20, bottom: 8, right: 20),
                child: Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 0, left:20, bottom: 8, right: 20),
                child: Text(
                  descriptions ?? "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_44494D,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),

                ),
              ),

              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onClickedConfirm,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 44,
                        width: 135,
                        decoration: BoxDecoration(
                          color: Mytheme.colorBgButtonLogin,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          textButton!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Mytheme.kBackgroundColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: "OpenSans-Semibold",
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
