import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';

import 'package:step_bank/compoment/textfield_widget.dart';
import '../../../compoment/confirm_dialog_icon.dart';
import '../../../compoment/dialog_confirm.dart';
import '../../../constants.dart';
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class CalculatorSaveMoneyScreen extends StatefulWidget {
  const CalculatorSaveMoneyScreen({Key? key}) : super(key: key);

  @override
  _CalculatorSaveMoneyScreenState createState() => _CalculatorSaveMoneyScreenState();
}

class _CalculatorSaveMoneyScreenState extends State<CalculatorSaveMoneyScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _moneyPaymentController = TextEditingController();
  TextEditingController _numberMonthController = TextEditingController();
  TextEditingController _numberPercentController = TextEditingController();
  late ProgressDialog pr;
  late ToolData data;
  int interest_amount = 0;
  int total = 0;
  bool showResult = false;
  @override
  void initState() {
    super.initState();
    data = Constants.toolData!;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    Future.delayed(Duration.zero, () {
      // loadDataSampleTool();
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
                  text: "Tính lãi tiết kiệm",
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
                                          "Số tiền tiết kiệm ban đầu",
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
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        obscureText: false,
                                        controller: _moneyPaymentController,
                                        enabled: true,
                                        textInputAction: TextInputAction.done,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xFFEFF0FB), filled: true,
                                            hintText: "Nhập số tiền",
                                            hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                            // labelText: labelText,

                                            suffixIcon: IconButton(
                                                onPressed: (){},
                                                icon: SvgPicture.asset("assets/svg/ic_vnd.svg")
                                            ),
                                            enabledBorder:  OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(14)),

                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                borderRadius: BorderRadius.circular(14))),
                                        onChanged: (value) {
                                          value = '${formNum(
                                            value.replaceAll(',', ''),
                                          )}';
                                          _moneyPaymentController.value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                              offset: value.length,
                                            ),
                                          );
                                        },
                                      ),
                                      //
                                      const SizedBox(height: 10),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Số tháng tiết kiệm",
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
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        obscureText: false,
                                        controller: _numberMonthController,
                                        enabled: true,
                                        textInputAction: TextInputAction.done,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xFFEFF0FB), filled: true,
                                            hintText: "Nhập số tháng",
                                            hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                            // labelText: labelText,

                                            suffixIcon: IconButton(
                                                onPressed: (){},
                                                icon: SvgPicture.asset("assets/svg/ic_thang.svg")
                                            ),
                                            enabledBorder:  OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(14)),

                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                borderRadius: BorderRadius.circular(14))),
                                      ),

                                      //
                                      const SizedBox(height: 10),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Lãi suất 1 năm",
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
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        obscureText: false,
                                        controller: _numberPercentController,
                                        enabled: true,
                                        textInputAction: TextInputAction.done,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xFFEFF0FB), filled: true,
                                            hintText: "Nhập lãi suất",
                                            hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                            // labelText: labelText,

                                            suffixIcon: IconButton(
                                                onPressed: (){},
                                                icon: SvgPicture.asset("assets/svg/ic_phantram.svg")
                                            ),
                                            enabledBorder:  OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(14)),

                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                borderRadius: BorderRadius.circular(14))),
                                      ),
                                      const SizedBox(height: 20),
                                      Visibility(
                                        visible: showResult,
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
                                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16 ),
                                            child:  Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [

                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Cuối kỳ gửi tiết kiệm, bạn nhận được:",
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
                                                  height: 10,
                                                ),

                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    formNum(total.toString()),
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
                                                  height: 10,
                                                ),

                                                Container(
                                                    margin: EdgeInsets.all(10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(8),
                                                        border: Border.all(color: Mytheme.colorBgButtonLogin)
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    "Tiền lãi",
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
                                                                flex: 3,
                                                                child:  Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text(
                                                                    formNum(interest_amount.toString()),
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
                                                                flex: 2,
                                                                child:  Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    "Tiền gốc",
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
                                                                flex: 3,
                                                                child:  Align(
                                                                  alignment: Alignment.centerRight,
                                                                  child: Text(
                                                                    _moneyPaymentController.text.isNotEmpty ? formNum(_moneyPaymentController.text.replaceAll(",", "")) : "",
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
                                                        ],
                                                      ),
                                                    )
                                                ),



                                              ],
                                            ),
                                          ),

                                        ),
                                      ),

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
                Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 20, left: 24, right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // side: const BorderSide(color: Colors.red)
                            ),
                            primary: Mytheme.colorBgButtonLogin,
                            minimumSize:
                            Size(MediaQuery.of(context).size.width, 44)),
                        child: Text(
                          "Tính toán",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_moneyPaymentController.text.isNotEmpty &&
                              _numberMonthController.text.isNotEmpty &&
                              _numberPercentController.text.isNotEmpty) {
                            showResult = true;
                            var goc = int.parse(_moneyPaymentController.text.replaceAll(",", ""));
                            var month = int.parse(_numberMonthController.text);
                            var precent = int.parse(_numberPercentController.text)/100;
                            var result = ((goc*month*precent)/12).round();
                            setState(() {
                              interest_amount = result;
                              total = result + goc;
                            });
                            print(result);
                          } else {

                          }

                        },
                      )),
                ),
              ],
            ),
          ),
        ),
    );
  }


  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future<void> saveItemTool(String obj) async {
    await pr.show();
    APIManager.postAPICallNeedToken(RemoteServices.storeDataItemToolURL, obj).then(
            (value) async {
          pr.hide();
          if (value['status_code'] == 200) {
            Get.back(result: true);
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }





}
