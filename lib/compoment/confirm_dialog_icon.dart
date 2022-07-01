import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants.dart';
import '../themes.dart';

class ConfirmDialogBoxWithIcon extends StatelessWidget {
  // final String? title, descriptions, text;
  final String? title;
  final String? textButtonLeft;
  final String? textButtonRight;
  final VoidCallback? onClickedConfirm;
  final VoidCallback? onClickedCancel;

  const ConfirmDialogBoxWithIcon(
      {Key? key,
        this.title,
        this.textButtonLeft,
        this.textButtonRight,
        this.onClickedConfirm,
        this.onClickedCancel})
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
              top: 0,
              right: 0,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
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
                child: SvgPicture.asset("assets/svg/ic_warning.svg"),
              ),
              
              Padding(
                padding:
                EdgeInsets.only(top: 12, left: 10, bottom: 8, right: 10),
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

              // SizedBox(
              //   height: 15,
              // ),

              SizedBox(
                height: 24,
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: Image(
              //     image: AssetImage('assets/images/ic_success.png'),
              //     fit: BoxFit.fill,
              //     width: 60,
              //   ),
              //   // child: FlatButton(
              //   //     onPressed: () {
              //   //       Navigator.of(context).pop();
              //   //     },
              //   //     child: Text(
              //   //       widget.text ?? "",
              //   //       style: TextStyle(fontSize: 18),
              //   //     )),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: onClickedCancel,
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      width: 135,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Mytheme.colorBgButtonLogin)
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Mytheme.colorBgButtonLogin.withOpacity(1), //color of shadow
                        //     spreadRadius: 1, //spread radius
                        //     blurRadius: 7, // blur radius
                        //     offset: Offset(0, 3), // changes position of shadow
                        //     //first paramerter of offset is left-right
                        //     //second parameter is top to down
                        //   ),
                        //   //you can set more BoxShadow() here
                        // ],
                      ),
                      child: Text(
                        textButtonLeft??"Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.color_434657,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onClickedConfirm,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      height: 44,
                      width: 135,
                      decoration: BoxDecoration(
                        color: Mytheme.colorBgButtonLogin,
                        borderRadius: BorderRadius.circular(8),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.grey.withOpacity(0.5), //color of shadow
                        //     spreadRadius: 1, //spread radius
                        //     blurRadius: 7, // blur radius
                        //     offset: Offset(0, 3), // changes position of shadow
                        //     //first paramerter of offset is left-right
                        //     //second parameter is top to down
                        //   ),
                        //   //you can set more BoxShadow() here
                        // ],
                      ),
                      child: Text(
                        textButtonRight ?? "Đăng xuất",
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.kBackgroundColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Positioned(
        //   left: Constants.padding,
        //   right: Constants.padding,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: Constants.avatarRadius,
        //     child: ClipRRect(
        //         borderRadius:
        //             BorderRadius.all(Radius.circular(Constants.avatarRadius)),
        //         child: Image.asset("assets/model.jpeg")),
        //   ),
        // ),
      ],
    );
  }
}
