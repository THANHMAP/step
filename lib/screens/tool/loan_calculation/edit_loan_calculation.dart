import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';

import 'package:step_bank/compoment/textfield_widget.dart';
import '../../../compoment/confirm_dialog_icon.dart';
import '../../../compoment/dialog_confirm.dart';
import '../../../constants.dart';
import '../../../models/loan/calculator_model.dart';
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/detail_tool.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool/update_data_tool.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class EditCalculatorLoanToolScreen extends StatefulWidget {
  const EditCalculatorLoanToolScreen({Key? key}) : super(key: key);

  @override
  _EditCalculatorLoanToolScreenState createState() => _EditCalculatorLoanToolScreenState();
}

class _EditCalculatorLoanToolScreenState extends State<EditCalculatorLoanToolScreen> with SingleTickerProviderStateMixin {
  TextEditingController _nameLoanController = TextEditingController();
  TextEditingController _moneyLoanRootController = TextEditingController();
  TextEditingController _tyLeLaiXuatController = TextEditingController();
  TextEditingController _kyHanVayController = TextEditingController();

  TextEditingController _numberMonthTienGocController = TextEditingController();
  TextEditingController _numberMonthTienLaiController = TextEditingController();
  TextEditingController _numberLaiSuatController = TextEditingController();
  late ProgressDialog pr;
  late ToolData data;
  int interest_amount = 0;
  int total = 0;
  bool showResult = false;
  String dateFirst = "";
  List<DataUsers> dataUsers = [];
  bool displayCalculation = true;
  bool selectDefault = true;
  List<DataCalculator> listLaiGiamDan = [];
  List<DataCalculator> listLaiPhang = [];
  var tongLaiGiamDan = 0;
  var tongLaiPhang = 0;
  ItemToolData? itemToolData;
  String currentDate = "";

  @override
  void initState() {
    super.initState();
    data = Constants.toolData!;
    itemToolData = Get.arguments;
    dateFirst = formatDate(int.parse(DateTime.now().day.toString()), int.parse(DateTime.now().month.toString()), int.parse(DateTime.now().year.toString()));
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    Future.delayed(Duration.zero, () {
      loadDataTool(itemToolData!.id.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Mytheme.colorBgMain,
            body: Column(
              children: <Widget>[
                AppbarWidget(
                  text: "Tính toán khoản vay",
                  onClicked: () {
                    Navigator.of(context).pop(false);
                    // if(displayCalculation) {
                    //   setState(() {
                    //     displayCalculation = false;
                    //   });
                    // } else {
                    //   Navigator.of(context).pop(false);
                    // }

                  },
                ),
                Expanded(
                  flex: 8,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 70),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Visibility(
                            visible: !displayCalculation,
                            child:  Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
                                    child: Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Tên khoản vay",
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
                                        SizedBox(
                                          child: TextFieldWidget(
                                              keyboardType: TextInputType.text,
                                              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.singleLineFormatter],
                                              textInputAction: TextInputAction.done,
                                              obscureText: false,
                                              hintText: "Viết tên của khoản vay này",
                                              // labelText: "Phone number",
                                              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                              suffixIcon: Icons.close,
                                              clickSuffixIcon: () => _nameLoanController.clear(),
                                              textController: _nameLoanController),
                                        ),
                                        const SizedBox(height: 10),
                                        //----------------------------------//
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Số tiền bạn cần vay ( Nợ gốc )",
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
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          obscureText: false,
                                          controller: _moneyLoanRootController,
                                          enabled: true,
                                          textInputAction: TextInputAction.done,
                                          textAlignVertical: TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              fillColor: const Color(0xFFEFF0FB),
                                              filled: true,
                                              hintText: "Nhập số tiền",
                                              hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                              // labelText: labelText,

                                              suffixIcon: IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/svg/ic_vnd.svg")),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                  borderRadius: BorderRadius.circular(14)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                  borderRadius: BorderRadius.circular(14))),
                                          onChanged: (value) {
                                            value = '${formNum(
                                              value.replaceAll(',', ''),
                                            )}';
                                            _moneyLoanRootController.value = TextEditingValue(
                                              text: value,
                                              selection: TextSelection.collapsed(
                                                offset: value.length,
                                              ),
                                            );
                                          },
                                        ),
                                        //----------------------------------//
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Tỷ lệ lãi suất năm",
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
                                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                      obscureText: false,
                                                      controller: _tyLeLaiXuatController,
                                                      enabled: true,
                                                      textInputAction: TextInputAction.done,
                                                      textAlignVertical: TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                          fillColor: const Color(0xFFEFF0FB),
                                                          filled: true,
                                                          hintText: "Nhập lãi suất",
                                                          hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                                          // labelText: labelText,

                                                          suffixIcon: IconButton(
                                                              onPressed: () {}, icon: SvgPicture.asset("assets/svg/ic_phantram.svg")),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                              borderRadius: BorderRadius.circular(14)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                              borderRadius: BorderRadius.circular(14))),
                                                    ),
                                                  ],
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Kỳ hạn vay",
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
                                                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                                      obscureText: false,
                                                      controller: _kyHanVayController,
                                                      enabled: true,
                                                      textInputAction: TextInputAction.done,
                                                      textAlignVertical: TextAlignVertical.center,
                                                      decoration: InputDecoration(
                                                          fillColor: const Color(0xFFEFF0FB),
                                                          filled: true,
                                                          hintText: "Nhập số tháng",
                                                          hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                                          // labelText: labelText,

                                                          suffixIcon: IconButton(
                                                              onPressed: () {}, icon: SvgPicture.asset("assets/svg/ic_thang.svg")),
                                                          enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                              borderRadius: BorderRadius.circular(14)),
                                                          focusedBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                              borderRadius: BorderRadius.circular(14))),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),

                                        //----------------------------------//
                                        const SizedBox(height: 10),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Phân kỳ trả tiền gốc",
                                            textAlign: TextAlign.left,
                                            // ignore: unnecessary_const
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
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          obscureText: false,
                                          controller: _numberMonthTienGocController,
                                          enabled: true,
                                          textInputAction: TextInputAction.done,
                                          textAlignVertical: TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              fillColor: const Color(0xFFEFF0FB),
                                              filled: true,
                                              hintText: "Nhập số tháng",
                                              hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                              // labelText: labelText,

                                              suffixIcon:
                                              IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/svg/ic_thang.svg")),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                  borderRadius: BorderRadius.circular(14)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                  borderRadius: BorderRadius.circular(14))),
                                        ),

                                        //----------------------------------//
                                        const SizedBox(height: 10),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Phân kỳ trả tiền lãi",
                                            textAlign: TextAlign.left,
                                            // ignore: unnecessary_const
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
                                          inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                          obscureText: false,
                                          controller: _numberMonthTienLaiController,
                                          enabled: true,
                                          textInputAction: TextInputAction.done,
                                          textAlignVertical: TextAlignVertical.center,
                                          decoration: InputDecoration(
                                              fillColor: const Color(0xFFEFF0FB),
                                              filled: true,
                                              hintText: "Nhập số tháng",
                                              hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                              // labelText: labelText,

                                              suffixIcon:
                                              IconButton(onPressed: () {}, icon: SvgPicture.asset("assets/svg/ic_thang.svg")),
                                              enabledBorder: OutlineInputBorder(
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
                                            "Ngày vay",
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
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: Mytheme.colorTextDivider,
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                                                  child: Text(
                                                    dateFirst,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Mytheme.colorBgButtonLogin,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "OpenSans-Semibold",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 0, left: 6, bottom: 0, right: 0),
                                                  child: IconButton(
                                                    icon: SvgPicture.asset("assets/svg/ic_calender.svg"),
                                                    // tooltip: 'Increase volume by 10',
                                                    iconSize: 50,
                                                    onPressed: () {
                                                      showDatePicker();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
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
                                              padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 16),
                                              child: Column(
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
                                                        fontFamily: "OpenSans-Regular",
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
                                                        fontFamily: "OpenSans-SemiBold",
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
                                                          border: Border.all(color: Mytheme.colorBgButtonLogin)),
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
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
                                                                        fontFamily: "OpenSans-Regular",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Text(
                                                                      formNum(interest_amount.toString()),
                                                                      textAlign: TextAlign.left,
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Mytheme.color_82869E,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "OpenSans-Regular",
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
                                                                  child: Align(
                                                                    alignment: Alignment.centerLeft,
                                                                    child: Text(
                                                                      "Tiền gốc",
                                                                      textAlign: TextAlign.left,
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Mytheme.color_82869E,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "OpenSans-Regular",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment: Alignment.centerRight,
                                                                    child: Text(
                                                                      _moneyLoanRootController.text.isNotEmpty
                                                                          ? formNum(_moneyLoanRootController.text.replaceAll(",", ""))
                                                                          : "",
                                                                      textAlign: TextAlign.left,
                                                                      style: const TextStyle(
                                                                        fontSize: 16,
                                                                        color: Mytheme.color_82869E,
                                                                        fontWeight: FontWeight.w400,
                                                                        fontFamily: "OpenSans-Regular",
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      )),
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
                          ),

                          Visibility(
                            visible: displayCalculation,
                            child:  Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
                                    child: Column(
                                      children: [
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Tên khoản vay",
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
                                            _nameLoanController.text,
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
                                        //----------------------------------//
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Số tiền gốc",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
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
                                            _moneyLoanRootController.text.isNotEmpty ? "${formNum(_moneyLoanRootController.text.replaceAll(",", ""))} VNĐ" : "",
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
                                        //----------------------------------//
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children:  [
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Lãi suất",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.color_82869E,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: "OpenSans-Regular",
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "${_tyLeLaiXuatController.text}% /năm",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.colorTextSubTitle,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "OpenSans-SemiBold",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Kỳ hạn vay",
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
                                                        "${_kyHanVayController.text} tháng",
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.colorTextSubTitle,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "OpenSans-SemiBold",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),

                                        //----------------------------------//
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Phân kỳ trả nợ gốc",
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
                                                        "Mỗi ${_numberMonthTienGocController.text} tháng",
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.colorTextSubTitle,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "OpenSans-SemiBold",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  children: [
                                                    const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Phân kỳ trả nợ tiền lãi",
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
                                                        "Mỗi ${_numberMonthTienLaiController.text} tháng",
                                                        textAlign: TextAlign.left,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.colorTextSubTitle,
                                                          fontWeight: FontWeight.w600,
                                                          fontFamily: "OpenSans-SemiBold",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                          ],
                                        ),
                                        //----------------------------------//
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Ngày bắt đầu",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
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
                                        const SizedBox(height: 20),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectDefault = true;
                                                  });
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Lãi phẳng",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: selectDefault
                                                          ? Mytheme.colorBgButtonLogin
                                                          : Mytheme.color_82869E,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "OpenSans-SemiBold",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    selectDefault = false;
                                                  });
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "Lãi trên dư nợ giảm dần",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: !selectDefault
                                                          ? Mytheme.colorBgButtonLogin
                                                          : Mytheme.color_82869E,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "OpenSans-SemiBold",
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: selectDefault
                                                        ? Mytheme.colorBgButtonLogin
                                                        : Mytheme.color_82869E,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Align(
                                                  alignment: Alignment.center,
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: !selectDefault
                                                        ? Mytheme.colorBgButtonLogin
                                                        : Mytheme.color_82869E,
                                                  )),
                                            )
                                          ],
                                        ),

                                        // lãi giam dan
                                        Visibility(
                                          visible: !selectDefault ? true : false,
                                          child:  Padding(
                                            padding: const EdgeInsets.only( bottom: 30, top: 0, left: 0, right: 16),
                                            child: Column(
                                              children: [

                                                Container(
                                                  height: 108,
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
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Bạn sẽ cần trả tổng tiền lãi",
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
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "${formNum(tongLaiGiamDan.toString())} vnđ",
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
                                                    ],
                                                  ),
                                                ),

                                                for (int i = 0; i < listLaiGiamDan.length; i++) ...[
                                                  layoutLai(true, listLaiGiamDan[i]),
                                                ]
                                              ],
                                            ),
                                          ),),

                                        // lãi phẳng
                                        Visibility(
                                          visible: selectDefault ? true : false,
                                          child:  Padding(
                                            padding: const EdgeInsets.only( bottom: 30, top: 0, left: 0, right: 16),
                                            child: Column(
                                              children: [

                                                Container(
                                                  height: 108,
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
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "Bạn sẽ cần trả tổng tiền lãi",
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
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.center,
                                                        child: Text(
                                                          "${formNum(tongLaiPhang.toString())} vnđ",
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
                                                    ],
                                                  ),
                                                ),

                                                for (int i = 0; i < listLaiPhang.length; i++) ...[
                                                  layoutLai(true, listLaiPhang[i]),
                                                ]
                                              ],
                                            ),
                                          ),),


                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                      padding: const EdgeInsets.only(top: 10, bottom: 20, left: 24, right: 24),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              // side: const BorderSide(color: Colors.red)
                            ),
                            primary: Mytheme.colorBgButtonLogin,
                            minimumSize: Size(MediaQuery.of(context).size.width, 44)),
                        child: Text(
                          displayCalculation ? "Lưu" : "Tính toán",
                          style: TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (displayCalculation) {
                            if(_nameLoanController.text.isEmpty) {
                              Utils.showError("Bạn chưa nhập tên khoản vay", context);
                            } else {
                              UpdateDataTool updateDataTool = UpdateDataTool();
                              updateDataTool.title = _nameLoanController.text;
                              updateDataTool.userToolId = int.parse(itemToolData!.id
                                  .toString());
                              updateDataTool.type = 1;
                              List<UpdateDataToolUsers>? listData = [];


                              //số tiền bạn cần vay
                              listData.add(UpdateDataToolUsers(
                                key: "tien_can_vay",
                                value: _moneyLoanRootController.text.replaceAll(
                                    ",", ""),
                                type: 0,
                              ));

                              //ty le lãi xuất năm
                              listData.add(UpdateDataToolUsers(
                                key: "ty_le_lai_suat",
                                value: _tyLeLaiXuatController.text,
                                type: 0,
                              ));

                              //kỳ hạn vay
                              listData.add(UpdateDataToolUsers(
                                key: "ky_han_vay",
                                value: _kyHanVayController.text,
                                type: 0,
                              ));

                              //phan kỳ trả tiền gốc
                              listData.add(UpdateDataToolUsers(
                                key: "phan_ky_tien_goc",
                                value: _numberMonthTienGocController.text,
                                type: 0,
                              ));

                              //phan kỳ trả tiền lãi
                              listData.add(UpdateDataToolUsers(
                                key: "phan_ky_tien_goc",
                                value: _numberMonthTienLaiController.text,
                                type: 0,
                              ));

                              //ngày vay
                              listData.add(UpdateDataToolUsers(
                                key: "ngay_vay",
                                value: dateFirst,
                                type: 0,
                              ));

                              updateDataTool.dataUsers = listData;
                              print(jsonEncode(updateDataTool));
                              saveItemTool(jsonEncode(updateDataTool));
                            }
                          } else {
                            setState(() {
                              displayCalculation = true;
                            });

                            currentDate = dateFirst;
                            calculatorLaiDuNoGiamDan();
                            currentDate = dateFirst;
                            calculatorLaiPhang();
                            return;
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



  layoutLai(bool collapsed, DataCalculator dataCalculator) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0, bottom: 16),
      child: InkWell(
        onTap: () {},
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
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    dataCalculator.collapsed = !dataCalculator.collapsed!;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: dataCalculator.collapsed == false
                        ? Colors.white
                        : Mytheme.color_0xFFCCECFB,
                    // borderRadius: BorderRadius.circular(8),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, left: 16, bottom: 18, right: 0),
                          child: Text(
                            dataCalculator.date ?? "",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              color: Mytheme.colorBgButtonLogin,
                              fontWeight: FontWeight.w600,
                              fontFamily: "OpenSans-Semibold",
                            ),
                          ),
                        ),
                      ),
                      Text(
                        dataCalculator.noGocConLai ?? "0",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.colorBgButtonLogin,
                          fontWeight: FontWeight.w400,
                          fontFamily: "OpenSans-Regular",
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 6, bottom: 0, right: 0),
                          child: IconButton(
                            icon:
                            Image.asset("assets/images/ic_arrow_down.png"),
                            // tooltip: 'Increase volume by 10',
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                dataCalculator.collapsed = !dataCalculator.collapsed!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                  visible: dataCalculator.collapsed ?? false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, left: 16, bottom: 18, right: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child:  Text(
                              "Nợ gốc còn lại",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.colorBgButtonLogin,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                              ),
                            ),),

                            Expanded(child:  Text(
                              dataCalculator.noGocConLai ?? "0",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.colorBgButtonLogin,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                              ),
                            ),)
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(child:  Text(
                              "Tổng tiền phải trả",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.colorBgButtonLogin,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                              ),
                            ),),

                            Expanded(child:  Text(
                              dataCalculator.tongTienPhaiTra ?? "0",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 16,
                                color: Mytheme.colorBgButtonLogin,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
                              ),
                            ),)
                          ],
                        ),

                        SizedBox(
                          height: 10,
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child:  Text(
                                        "Của nợ gốc",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorBgButtonLogin,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                      ),),

                                      Expanded(child:  Text(
                                        dataCalculator.noGoc ?? "0 vnđ",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorBgButtonLogin,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                      ),)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child:  Text(
                                        "Của tiền lãi",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorBgButtonLogin,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                      ),),

                                      Expanded(child:  Text(
                                        dataCalculator.tienLai ?? "0 vnđ",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorBgButtonLogin,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                      ),)
                                    ],
                                  ),
                                ],
                              ),
                            )

                        ),

                      ],
                    ),
                    // Text(
                    //   "calculatorLaiHangThang(index)",
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     color: Mytheme.colorBgButtonLogin,
                    //     fontWeight: FontWeight.w400,
                    //     fontFamily: "OpenSans-Regular",
                    //   ),
                    // ),
                  ))

              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     faqData.description.toString(),
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Mytheme.colorBgButtonLogin,
              //       fontWeight: FontWeight.w400,
              //       fontFamily: "OpenSans-Regular",
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  String showDay(){
    var dates = currentDate.split("/");
    var day = int.parse(dates[0]);
    var month = int.parse(dates[1]);
    var year = int.parse(dates[2]);
    var tempDay = day.toString();
    month = month + 1;
    if(day < 10) {
      tempDay = "0$day";
    }
    if(month > 12) {
      month = month - 12;
      year = year + 1;
    }
    var tempMonth = month.toString();
    if(month < 10) {
      tempMonth = "0$month";
    }
    currentDate = "${dates[0]}/${month}/${year}";
    return "${tempDay}/${tempMonth}/${year}";
  }

  var noGocTrathangtruoc;


  void calculatorLaiDuNoGiamDan() {
    bool thangLaiDauTien = false;
    listLaiGiamDan = [];
    tongLaiGiamDan = 0;
    var soThangVay = int.parse(_kyHanVayController.text);
    var soThangTraGoc = int.parse(_numberMonthTienGocController.text);
    var soThangTraLai = int.parse(_numberMonthTienLaiController.text);
    var soTienGoc = int.parse(_moneyLoanRootController.text.replaceAll(",", ""));
    var soLanTraGoc = int.parse(_kyHanVayController.text)/int.parse(_numberMonthTienGocController.text);
    var soLanTraLai = int.parse(_kyHanVayController.text)/int.parse(_numberMonthTienLaiController.text);
    var phanTramLaiHangThang = (int.parse(_tyLeLaiXuatController.text)/100);
    // var phanTramLaiHangThang = int.parse(_tyLeLaiXuatController.text);
    var noGocConLai = soTienGoc;
    for (int i = 0; i < soThangVay; i++) {
      DataCalculator dataCalculator = DataCalculator();
      dataCalculator.collapsed = false;
      dataCalculator.date = showDay();
      print("calculatorLaiDuNoGiamDan  ${dataCalculator.date}");
      var lai = 0;
      var noGocHangThang = 0;
      // tinh trả nợ gốc
      var number = i+1;


      if(number % soThangTraLai == 0) {
        if(!thangLaiDauTien) {
          thangLaiDauTien = true;
          lai = ((noGocConLai * phanTramLaiHangThang) / (12/soThangTraLai)).round();
          dataCalculator.tienLai = formNum(lai.toString()) + " vnđ";
        } else {
          lai = ((noGocConLai * phanTramLaiHangThang) / (12/soThangTraLai)).round();
          dataCalculator.tienLai = formNum(lai.toString()) + " vnđ";
        }
      }

      if(number % soThangTraGoc == 0) {
        noGocConLai = (noGocConLai - (soTienGoc/soLanTraGoc).round());
        noGocHangThang = (soTienGoc/soLanTraGoc).round();
        dataCalculator.noGoc = formNum(noGocHangThang.toString()) + " vnđ";
      }

      if (noGocConLai < 0) noGocConLai = 0;
      print(formNum(lai.toString()));
      tongLaiGiamDan = tongLaiGiamDan + lai;
      var tongPhaiTra = noGocHangThang + lai;
      dataCalculator.tongTienPhaiTra = formNum(tongPhaiTra.toString()) + " vnđ";
      dataCalculator.noGocConLai = formNum(noGocConLai.toString()) + " vnđ";
      listLaiGiamDan.add(dataCalculator);
    }
    setState(() {
      listLaiGiamDan;
    });
  }

  void calculatorLaiPhang() {
    listLaiPhang = [];
    tongLaiPhang = 0;
    var soThangVay = int.parse(_kyHanVayController.text);
    var soThangTraGoc = int.parse(_numberMonthTienGocController.text);
    var soThangTraLai = int.parse(_numberMonthTienLaiController.text);
    var soTienGoc = int.parse(_moneyLoanRootController.text.replaceAll(",", ""));
    var soLanTraGoc = int.parse(_kyHanVayController.text)/int.parse(_numberMonthTienGocController.text);
    var soLanTraLai = int.parse(_kyHanVayController.text)/int.parse(_numberMonthTienLaiController.text);
    var phanTramLaiHangThang = (int.parse(_tyLeLaiXuatController.text)/100)/12;

    var noGocConLai = soTienGoc;
    for (int i = 0; i < soThangVay; i++) {
      DataCalculator dataCalculator = DataCalculator();
      dataCalculator.collapsed = false;
      dataCalculator.date = showDay();
      print("calculatorLaiPhang  ${dataCalculator.date}");
      var lai = 0;
      var noGocHangThang = 0;
      // tinh trả nợ gốc
      var number = i+1;
      if(number % soThangTraGoc == 0) {
        noGocConLai = (noGocConLai - (soTienGoc/soLanTraGoc).round());
        noGocHangThang = (soTienGoc/soLanTraGoc).round();
        dataCalculator.noGoc = formNum(noGocHangThang.toString()) + " vnđ";
      }

      if (noGocConLai < 0) noGocConLai = 0;

      if(number % soThangTraLai == 0) {
        lai = (soTienGoc * phanTramLaiHangThang * soThangTraLai).round();
        dataCalculator.tienLai = formNum(lai.toString()) + " vnđ";
      }
      tongLaiPhang = tongLaiPhang + lai;
      var tongPhaiTra = noGocHangThang + lai;
      dataCalculator.tongTienPhaiTra = formNum(tongPhaiTra.toString()) + " vnđ";
      dataCalculator.noGocConLai = formNum(noGocConLai.toString()) + " vnđ";
      listLaiPhang.add(dataCalculator);
    }
    setState(() {
      listLaiPhang;
    });
  }


  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future<void> saveItemTool(String obj) async {
    await pr.show();
    APIManager.postAPICallNeedToken(RemoteServices.updateItemToolURL, obj).then(
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

  String formatDate(int day, int month, int year) {
    var tempDay = day.toString();
    var tempMonth = month.toString();
    var tempYear = year.toString();
    if(day < 10) {
      tempDay = "0$day";
    }
    if(month < 10) {
      tempMonth = "0$month";
    }

    return '$tempDay/$tempMonth/$tempYear';
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
              _nameLoanController.text = data.data!.name!;
              for(var i =0; i< dataUsers.length; i++) {
                if(dataUsers[i].key == "tien_can_vay"){
                  _moneyLoanRootController.text = formNum(dataUsers[i].value.toString());
                } else if(dataUsers[i].key == "ty_le_lai_suat"){
                  _tyLeLaiXuatController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "ky_han_vay"){
                  _kyHanVayController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "ngay_vay"){
                  dateFirst = dataUsers[i].value.toString();
                  currentDate = dateFirst;
                } else if(dataUsers[i].key == "phan_ky_tien_goc"){
                  _numberMonthTienGocController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "phan_ky_tien_lai"){
                  _numberMonthTienLaiController.text = dataUsers[i].value.toString();
                }
              }
              calculatorLaiDuNoGiamDan();
              currentDate = dateFirst;
              calculatorLaiPhang();
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  showDatePicker() async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
      dateFormat: "dd-MMMM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
      cancelText: "Hủy bỏ",
      confirmText: "Cập nhật",
      titleText: "Chọn ngày",
    );
    if(datePicked != null) {
      setState(() {
        // dateFirst = formatDate(int.parse(datePicked.day.toString()), int.parse(datePicked.month.toString()), int.parse(DateTime.now().year.toString()));
        dateFirst = '${datePicked.day}/${datePicked.month}/${datePicked.year}';
      });
    }
  }

}
