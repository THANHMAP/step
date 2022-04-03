import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/request_status.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../constants.dart';
import '../../controllers/question_controller.dart';
import '../../models/result.dart';
import '../../themes.dart';
import '../../util.dart';

class ResultQuizScreen extends StatefulWidget {
  const ResultQuizScreen({Key? key}) : super(key: key);

  @override
  _ResultQuizScreenState createState() => _ResultQuizScreenState();
}

class _ResultQuizScreenState extends State<ResultQuizScreen> {
  late ProgressDialog pr;
  Result _dataResult = Get.arguments;
  String resultText = "";
  String urlImage = "";

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Future.delayed(Duration.zero, () {
      sendListExercise();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.color_0xFFD8F1FF,
          body: Column(
            children: <Widget>[
              AppbarWidget(
                hideBack: true,
                text: "Kết Quả",
                onClicked: () => Get.back(),
              ),
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 30, left: 24, right: 24),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            textResult(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24,
                                color: Mytheme.color_0xFF003A8C,
                                fontFamily: "OpenSans-SemiBold",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: GridView.count(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              padding: EdgeInsets.all(4.0),
                              childAspectRatio: 8.0 / 5.0,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              children: List.generate(
                                  _dataResult.listQuestion!.length, (index) {
                                return SizedBox(
                                  width: 300,
                                  height: 100,
                                  child: Card(
                                    color: _dataResult.listQuestion![index]
                                                .isCorrect ==
                                            true
                                        ? Mytheme.color_0xFF30CD60
                                        : Mytheme.color_0xFFE6706C,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12,
                                              left: 16,
                                              bottom: 18,
                                              right: 5),
                                          child: SvgPicture.asset(_dataResult
                                                      .listQuestion![index]
                                                      .isCorrect ==
                                                  true
                                              ? "assets/svg/ic_correct.svg"
                                              : "assets/svg/ic_wrong.svg"),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 12,
                                                left: 0,
                                                bottom: 18,
                                                right: 0),
                                            child: Text(
                                              "Câu ${index + 1}",
                                              textAlign: TextAlign.end,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Mytheme.kBackgroundColor,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "OpenSans-SemiBold",
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child:  Stack(
                children: <Widget>[
                  Container(
                    height: 126,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrlResult()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          resultText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            color: Mytheme.kBackgroundColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: "OpenSans-SemiBold",
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 130, left: 0, right: 0),
                    child: Container(
                      height: 100,
                      color: Mytheme.kBackgroundColor,
                      child: Center(
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 0, left: 24, right: 24),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // side: const BorderSide(color: Colors.red)
                                  ),
                                  primary: Mytheme.colorBgButtonLogin,
                                  minimumSize: Size(
                                      MediaQuery.of(context).size.width, 44)),
                              child: const Text(
                                "Hoàn Thành",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "OpenSans-Regular",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                            )),
                      ),
                    ),
                  ),
                ],
              ),)

              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     color: Mytheme.kBackgroundColor,
              //     child: Center(
              //       child: Padding(
              //           padding: const EdgeInsets.only(
              //               bottom: 0, left: 24, right: 24),
              //           child: ElevatedButton(
              //             style: ElevatedButton.styleFrom(
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                   // side: const BorderSide(color: Colors.red)
              //                 ),
              //                 primary: Mytheme.colorBgButtonLogin,
              //                 minimumSize:
              //                     Size(MediaQuery.of(context).size.width, 44)),
              //             child: const Text(
              //               "Hoàn Thành",
              //               style: TextStyle(
              //                   fontSize: 16,
              //                   fontFamily: "OpenSans-Regular",
              //                   fontWeight: FontWeight.bold),
              //             ),
              //             onPressed: () {
              //               // pr.show();
              //               // Future.delayed(Duration(seconds: 3)).then((value) {
              //               //   pr.hide();
              //               // });
              //               Get.offAndToNamed("/");
              //             },
              //           )),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }

  String textResult() {
    if (_dataResult.numOfCorrectAns! >= _dataResult.listQuestion!.length / 2) {
      return "Chúc mừng!\n Bạn đã đúng ${_dataResult.numOfCorrectAns!}/${_dataResult.listQuestion!.length} câu hỏi";
    } else {
      return "Rát tiếc!\n Bạn chỉ đúng ${_dataResult.numOfCorrectAns!}/${_dataResult.listQuestion!.length} câu hỏi";
    }
  }

  String imageUrlResult() {
    if (_dataResult.numOfCorrectAns! == 0) {
      return "assets/images/bg_chuadat.png";
    } else if (_dataResult.numOfCorrectAns! ==
        _dataResult.listQuestion!.length) {
      return "assets/images/bg_dat.png";
    } else if (_dataResult.numOfCorrectAns! >=
        _dataResult.listQuestion!.length / 2) {
      return "assets/images/bg_dat_kha.png";
    } else if (_dataResult.numOfCorrectAns! <=
        _dataResult.listQuestion!.length / 2) {
      return "assets/images/bg_chuadat_2sao.png";
    } else if (_dataResult.numOfCorrectAns! <=
        _dataResult.listQuestion!.length / 3) {
      return "assets/images/bg_chuadat_1sao.png";
    }
    return "assets/images/bg_chuadat.png";
  }

  Future<void> sendListExercise() async {
    await pr.show();
    APIManager.postAPICallNeedToken(
            RemoteServices.submitQuizURL, _dataResult.result)
        .then((value) async {
      await pr.hide();
      if (value["status_code"] == 200) {
        setState(() {
          resultText = value["data"]["result"];
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
