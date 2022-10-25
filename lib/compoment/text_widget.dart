import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../themes.dart';


class RichTextWidget extends StatelessWidget{
  final String? text0;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;
  final String? text6;
  final String? text7;
  const RichTextWidget({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
    this.text3,
    this.text4,
    this.text5,
    this.text6,
    this.text7,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          RichText(
            text: TextSpan(
              text: text0,
              style: const TextStyle(
                fontSize: 12,
                color: Mytheme.color_82869E,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans-Regular",
              ),
              children: <TextSpan>[
                TextSpan(
                  text: text1 ,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text2,
              style: const TextStyle(
                fontSize: 12,
                color: Mytheme.color_82869E,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans-Regular",
              ),
              children: <TextSpan>[
                TextSpan(
                  text: text3 ,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text4,
              style: const TextStyle(
                fontSize: 12,
                color: Mytheme.color_82869E,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans-Regular",
              ),
              children: <TextSpan>[
                TextSpan(
                  text: text5 ,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: text6,
              style: const TextStyle(
                fontSize: 12,
                color: Mytheme.color_82869E,
                fontWeight: FontWeight.bold,
                fontFamily: "OpenSans-Regular",
              ),
              children: <TextSpan>[
                TextSpan(
                  text: text7 ,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget extends StatelessWidget{

  final String? text0;
  final String? text1;
  final String? text2;

  const TextWidget({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget1 extends StatelessWidget{

  final String? text0;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;

  const TextWidget1({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
    this.text3,
    this.text4,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text3!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text4!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget2 extends StatelessWidget{

  final String? text0;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;

  const TextWidget2({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
    this.text3,
    this.text4,
    this.text5,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text3!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text4!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text5!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget3 extends StatelessWidget{

  final String? text0;
  final String? text1;
  final String? text2;
  final String? text3;
  final String? text4;
  final String? text5;
  final String? text6;

  const TextWidget3({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
    this.text3,
    this.text4,
    this.text5,
    this.text6,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text3!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text4!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text5!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text6!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget4 extends StatelessWidget{

  final String? text0;
  final String? text1;
  final String? text2;
  final String? text3;

  const TextWidget4({
    Key? key,
    this.text0,
    this.text1,
    this.text2,
    this.text3,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text2!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text3!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}

class TextWidget5 extends StatelessWidget{

  final String? text0;
  final String? text1;

  const TextWidget5({
    Key? key,
    this.text0,
    this.text1,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(
            text0!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
          Text(
            text1!,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ],
      ),
    );
  }
}
