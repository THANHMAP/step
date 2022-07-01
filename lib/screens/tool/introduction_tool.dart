
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../models/tool_model.dart';
import '../../themes.dart';

class IntroductionToolScreen extends StatefulWidget {
  const IntroductionToolScreen({Key? key}) : super(key: key);

  @override
  _IntroductionToolScreenState createState() => _IntroductionToolScreenState();
}

class _IntroductionToolScreenState extends State<IntroductionToolScreen> {

  ToolData? data;

  @override
  void initState() {
    super.initState();
    data = Get.arguments;
  }


  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: Scaffold(
          backgroundColor: Mytheme.kYellowColor,
          body: Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background_home_quiz.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: 20, left: 24, right: 24),
                      child: null,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              data?.name ?? "",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: Mytheme.color_0xFF003A8C,
                                  fontFamily: "OpenSans-SemiBold",
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 44, right: 44),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                data?.description ?? "",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Mytheme.colorTextSubTitle,
                                    fontFamily: "OpenSans-Regular",
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 20, left: 10, right: 10),
                              child: Image.network(
                                  data?.thumbnail ?? ""),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only( top: 40,
                          bottom: 20, left: 24, right: 24),
                      child: Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // side: const BorderSide(color: Colors.red)
                                ),
                                primary: Mytheme.colorBgButtonLogin,
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width,
                                    44)
                            ),
                            child:  const Text(
                              "Tiếp tục",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSans-Regular",
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              if(data?.id == 1) {
                                Get.offAndToNamed('/toolBudgetScreen', arguments: data);
                              } else if(data?.id == 2) {
                                Get.offAndToNamed('/planeBusinessToolScreen', arguments: data);
                              } else if(data?.id == 3) {
                                Get.offAndToNamed('/saveToolScreen', arguments: data);
                              } else if(data?.id == 5) {
                                Get.offAndToNamed('/portfolioOfLoanScreen', arguments: data);
                              } else if(data?.id == 4) {
                                Get.offAndToNamed('/repaymentScheduleScreen', arguments: data);
                              } else if(data?.id == 6) {
                                Get.offAndToNamed('/mainLoanCalculatorToolScreen', arguments: data);
                              }
                              else  {
                                Get.offAndToNamed('/mainFlowMoneyScreen', arguments: data);
                              }
                            },
                          )
                        ],
                      ),

                    ),
                  ),
                ],
              ), /* add child content here */
            ),
          ),
        ),
    );
  }
}
