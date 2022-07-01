import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../themes.dart';

class NormalDialogBox extends StatelessWidget {
  // final String? title, descriptions, text;
  final String? descriptions;
  final VoidCallback? onClicked;

  const NormalDialogBox({Key? key, this.descriptions, this.onClicked,})
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
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              // boxShadow:  [
              //   BoxShadow(
              //       color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              // ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Image.asset("assets/images/ic_close.png"),
                  // tooltip: 'Increase volume by 10',
                  iconSize: 50,
                  onPressed: onClicked,
                ),
              ),
              // Text(
              //   widget.title ?? "",
              //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              // ),
              // SizedBox(
              //   height: 15,
              // ),
              Padding(
                padding:  EdgeInsets.only(
                    top: 0, left: 10, bottom: 8, right: 10),
                child: Text(
                  descriptions ?? "",
                  style:  TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_44494D,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(
                height: 22,
              ),
               Align(
                alignment: Alignment.center,
                child: Image(
                  image: AssetImage('assets/images/ic_success.png'),
                  fit: BoxFit.fill,
                  width: 60,
                ),
                // child: FlatButton(
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     },
                //     child: Text(
                //       widget.text ?? "",
                //       style: TextStyle(fontSize: 18),
                //     )),
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
