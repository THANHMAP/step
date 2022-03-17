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

import '../../controllers/question_controller.dart';
import '../../themes.dart';
import '../../util.dart';

class ResultQuizScreen extends StatefulWidget {
  const ResultQuizScreen({Key? key}) : super(key: key);

  @override
  _ResultQuizScreenState createState() => _ResultQuizScreenState();
}

class _ResultQuizScreenState extends State<ResultQuizScreen> {
  final QuestionController _qnController = Get.put(QuestionController());
  late ProgressDialog pr;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    sendListExercise();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.kBackgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 9,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppbarWidget(
                      hideBack: true,
                      text: _qnController.nameTitle,
                      onClicked: () => Get.back(),
                    ),
                    Padding(
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
                            height: 300,
                            child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0,
                                children: List.generate(
                                    _qnController.resultQuestion.length,
                                    (index) {
                                  return SizedBox(
                                    width: 300,
                                    height: 100,
                                    child: Card(
                                      color: _qnController.resultQuestion[index]
                                                  .isCorrect ==
                                              1
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
                                            child: SvgPicture.asset(_qnController
                                                        .resultQuestion[index]
                                                        .isCorrect ==
                                                    1
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
                                                  color:
                                                      Mytheme.kBackgroundColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily:
                                                      "OpenSans-SemiBold",
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
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            // side: const BorderSide(color: Colors.red)
                          ),
                          primary: Mytheme.colorBgButtonLogin,
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 44)),
                      child: const Text(
                        "Hoàn Thành",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "OpenSans-Regular",
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        // pr.show();
                        // Future.delayed(Duration(seconds: 3)).then((value) {
                        //   pr.hide();
                        // });
                        Get.offAndToNamed("/");
                      },
                    )
                ),
              ),
            ],
          ),
        ));
  }

  String textResult() {
    if (_qnController.numOfCorrectAns >=
        _qnController.resultQuestion.length / 2) {
      return "Chúc mừng!\n Bạn đã đúng ${_qnController.numOfCorrectAns}/${_qnController.resultQuestion.length} câu hỏi";
    } else {
      return "Rát tiếc!\n Bạn chỉ đúng ${_qnController.numOfCorrectAns}/${_qnController.resultQuestion.length} câu hỏi";
    }
  }


  Future<void> sendListExercise() async {
    await pr.show();
    APIManager.postAPICallNeedToken(RemoteServices.submitQuizURL, _qnController.result).then(
            (value) async {
          await pr.hide();
          if (value["status_code"] == 200) {
            setState(() {
              var test = value["data"]["result"];
            });
          }
        }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}
