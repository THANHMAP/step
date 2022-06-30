import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/education_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/models/tool_model.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../compoment/card_education.dart';
import '../../compoment/card_setting.dart';
import '../../themes.dart';
import '../../util.dart';

class MyToolScreen extends StatefulWidget {
  const MyToolScreen({Key? key}) : super(key: key);

  @override
  _MyToolScreenState createState() => _MyToolScreenState();
}

class _MyToolScreenState extends State<MyToolScreen> {
  late ProgressDialog pr;
  List<ToolData> _toolList = [];

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadListTool();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Mytheme.colorBgMain,
            body: Column(
              children: <Widget>[
                AppbarWidget(
                  hideBack: false,
                  text: "Công cụ",
                  onClicked: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 70),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 0, right: 0, bottom: 0),
                                  child: Column(
                                    children: [
                                      layoutCourse(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // headerLayout(),
                          // layoutCourse(),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  layoutCourse() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        children: [
          if (_toolList.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: 16, left: 16, right: 16, bottom: 0),
              child: Column(
                children: [
                  for (var i = 0; i < _toolList.length; i++) ...[
                    const SizedBox(height: 15),
                    CardEducatonWidget(
                      title: _toolList[i].name,
                      numberLesson: "",
                      linkUrl: _toolList[i].icon,
                      onClicked: () {
                        var data = _toolList[i];
                        if(data.id == 1) {
                          Get.toNamed('/toolBudgetScreen', arguments: data);
                        } else if(data.id == 2) {
                          Get.toNamed('/planeBusinessToolScreen', arguments: data);
                        } else if(data.id == 3) {
                          Get.toNamed('/saveToolScreen', arguments: data);
                        } else if(data.id == 5) {
                          Get.toNamed('/portfolioOfLoanScreen', arguments: data);
                        } else if(data.id == 4) {
                          Get.toNamed('/repaymentScheduleScreen', arguments: data);
                        } else if(data.id == 6) {
                          Get.toNamed('/mainLoanCalculatorToolScreen', arguments: data);
                        }
                        else  {
                          Get.toNamed('/mainFlowMoneyScreen', arguments: data);
                        }

                        // Get.toNamed('/introductionToolScreen',
                        //     arguments: _toolList[i]);
                      },
                    ),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


  Future<void> loadListTool() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'my_tool': "true",
    });
    APIManager.postAPICallNeedToken(RemoteServices.listToolURL, param).then(
            (value) async {
          pr.hide();
          var data = ToolModel.fromJson(value);
          if (data.statusCode == 200) {
            setState(() {
              _toolList = data.data!;
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
