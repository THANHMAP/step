import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';

import 'package:step_bank/compoment/textfield_widget.dart';
import '../../../constants.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class CalculatorBudgetScreen extends StatefulWidget {
  const CalculatorBudgetScreen({Key? key}) : super(key: key);

  @override
  _CalculatorBudgetScreenState createState() => _CalculatorBudgetScreenState();
}

class _CalculatorBudgetScreenState extends State<CalculatorBudgetScreen> {
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  var formatter = NumberFormat('#,##,000');
  StoreDataTool data = Get.arguments;
  int totalType1 = 0;
  int totalType2 = 0;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    dataUsers = data.dataUsers!;
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      // loadListItemTool();
    });
  }

  @override
  void dispose() {
    super.dispose();
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
                  text: "Lập ngân sách",
                  onClicked: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 70),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 40, left: 24, right: 24 ),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16 ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Tổng thu nhập",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.color_82869E,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  "OpenSans-Regular",
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child:  Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                calculatorTotalType1(),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.color_82869E,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  "OpenSans-Regular",
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Tổng thu nhập",
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.color_82869E,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  "OpenSans-Regular",
                                                ),
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            child:  Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                calculatorTotalType2(),
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.color_82869E,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily:
                                                  "OpenSans-Regular",
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),

                                      Divider(
                                        thickness: 1,
                                        color: Mytheme.color_BCBFD6,
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Số dư",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Mytheme.color_82869E,
                                            fontWeight: FontWeight.w400,
                                            fontFamily:
                                            "OpenSans-Regular",
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          calculatorTotal(),
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            color: Mytheme.colorBgButtonLogin,
                                            fontWeight: FontWeight.w600,
                                            fontFamily:
                                            "OpenSans-SemiBold",
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Mytheme.color_BCBFD6,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 7,
                                                offset: const Offset(0, 3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset("assets/svg/ic_infomation.svg"),
                                                ),
                                                Expanded(child: Text(
                                                  "Bạn có thể sử dụng số tiền này cho các khoản chi tiêu ngoài dự kiến hoặc tiết kiệm cho tương lai.",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "OpenSans-Regular",
                                                      fontWeight: FontWeight.w400),
                                                )),

                                              ],
                                            ),
                                          )

                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),

                              )
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10, bottom: 20, left: 24, right: 24),
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
                          "Lưu",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          saveItemTool();
                        },
                      )),
                ),
              ],
            ),
          ),
        ),
    );
  }

  String calculatorTotalType1() {
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 1) {
        totalType1 = totalType1 + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(totalType1.toString())} VNĐ";
  }

  String calculatorTotalType2() {
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 2) {
        totalType2 = totalType2 + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(totalType2.toString())} VNĐ";
  }

  String calculatorTotal() {
    return "${formNum((totalType1 - totalType2).toString())} VNĐ";
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future<void> saveItemTool() async {
    await pr.show();
    APIManager.postAPICallNeedToken(RemoteServices.storeDataItemToolURL, jsonEncode(data)).then(
            (value) async {
          pr.hide();
          if (value['status_code'] == 200) {
            Get.offAllNamed("/detailBudgetScreen");
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}
