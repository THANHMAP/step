import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../shared/SPref.dart';

class IntroductionScreenPage extends StatefulWidget {
  const IntroductionScreenPage({Key? key}) : super(key: key);
  @override
  _IntroductionScreenPageState createState() => _IntroductionScreenPageState();
}

class _IntroductionScreenPageState extends State<IntroductionScreenPage> {

  @override
  void initState() {
    super.initState();
    SPref.instance.addBoolToSF("loginFirst", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/img_background_splash.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    onPressed: () {
                      Get.offAndToNamed('/login');
                    },
                    child: Text('login'),
                  )
                ),
              ),
            ],
          ),
          // child: SvgPicture.asset("assets/svg/ic_logo.svg"),
        ),
      ),
    );
  }

}