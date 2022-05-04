import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import '../../../models/tool/detail_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class NotificationRepaymentScreen extends StatefulWidget {
  const NotificationRepaymentScreen({Key? key}) : super(key: key);

  @override
  _NotificationRepaymentScreenState createState() => _NotificationRepaymentScreenState();
}

class _NotificationRepaymentScreenState extends State<NotificationRepaymentScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  List<String> _listRepaymentCycle = [
    "1 tháng",
    "2 tháng",
    "3 tháng",
    "4 tháng",
    "5 tháng",
    "6 tháng",
    "7 tháng",
    "8 tháng",
    "9 tháng",
    "10 tháng",
    "11 tháng",
    "12 tháng"
  ];
  String title = "Lịch trả nợ";
  String nameSchedule = "";
  String payment_amount = "";
  int currentRepaymentCycleIndex = 0;
  String dateFirst = "";
  String repaymentCycle = "";
  String repaymentNumber = "";
  String numberDay = "";

  String userId = Get.arguments.toString();
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
      loadDataTool(userId);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Mytheme.colorBgMain,
        body: Column(
          children: <Widget>[
            AppbarWidget(
              text: title,
              onClicked: () {
                Get.back(result: false);
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
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30, left: 24, right: 24),
                              child: Column(
                                children: [
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Lịch trả nợ món vay mới",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      nameSchedule,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
                                  //
                                  const SizedBox(height: 10),
                                  //
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Số tiền bạn phải thanh toán mỗi kỳ",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      payment_amount,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
                                  //
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Chu kỳ trả nợ",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      repaymentCycle,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
                                  //
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Số lần trả nợ",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                   Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      repaymentNumber,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Ngày trả nợ đầu tiên",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      dateFirst,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
//
                                  const SizedBox(height: 10),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Số ngày nhận thông báo trước hẹn",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.color_82869E,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      numberDay,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),

                                  Image.asset("assets/images/schedule.png", width: 190,),

                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




  String getNameRepayment(int index) {
    return _listRepaymentCycle[index];
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }


  Future<void> loadDataTool(String id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.getDetailItemToolURL, param).then(
            (value) async {
          pr.hide();
          var data = DetailTool.fromJson(value);
          if (data.statusCode == 200) {
            setState(() {
              dataUsers = data.data!.dataUsers!;
              nameSchedule = data.data!.name!;
              for(var i =0; i< dataUsers.length; i++) {
                if(dataUsers[i].key == "payment_amount"){
                  payment_amount = "${formNum(dataUsers[i].value.toString())} VNĐ";
                } else if(dataUsers[i].key == "repayment_cycle"){
                  repaymentCycle = getNameRepayment(dataUsers[i].type!);
                } else if(dataUsers[i].key == "repayment_number"){
                  repaymentNumber = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "repayment_day"){
                  dateFirst = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "repayment_number_day"){
                  numberDay = dataUsers[i].value.toString();
                }
              }
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}