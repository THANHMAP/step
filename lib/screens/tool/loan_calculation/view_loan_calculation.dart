import 'dart:convert';

import 'package:flutter/foundation.dart';
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

class ViewCalculatorLoanToolScreen extends StatefulWidget {
  const ViewCalculatorLoanToolScreen({Key? key}) : super(key: key);

  @override
  _ViewCalculatorLoanToolScreenState createState() => _ViewCalculatorLoanToolScreenState();
}

class _ViewCalculatorLoanToolScreenState extends State<ViewCalculatorLoanToolScreen> with SingleTickerProviderStateMixin {
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

  @override
  void initState() {
    super.initState();
    data = Constants.toolData!;
    dateFirst = formatDate(int.parse(DateTime.now().day.toString()), int.parse(DateTime.now().month.toString()), int.parse(DateTime.now().year.toString()));
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
    return GestureDetector(
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
                      Container(
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
                                                DatePicker.showDatePicker(context,
                                                    theme: DatePickerTheme(
                                                      containerHeight: 210.0,
                                                    ),
                                                    showTitleActions: true,
                                                    minTime: DateTime(2022, 1, 1),
                                                    maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                                                      print('confirm $date');
                                                      // _date = '${date.year} - ${date.month} - ${date.day}';
                                                      setState(() {
                                                        dateFirst = '${date.day}/${date.month}/${date.year}';
                                                      });
                                                    }, currentTime: DateTime.now(), locale: LocaleType.vi);
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
                    child: const Text(
                      "Tính toán",
                      style: TextStyle(fontSize: 16, fontFamily: "OpenSans-Regular", fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      StoreDataTool storeDataTool = StoreDataTool();
                      storeDataTool.title = _nameLoanController.text;
                      storeDataTool.toolId = data.id;
                      storeDataTool.type = 1; // 1 plan business

                      //ten khoản vay
                      dataUsers.add(DataUsers(
                        key: "ten_khoan_vay",
                        value: _nameLoanController.text,
                        type: 0,
                      ));

                      //ten khoản vay
                      dataUsers.add(DataUsers(
                        key: "ten_khoan_vay",
                        value: _nameLoanController.text,
                        type: 0,
                      ));

                      //số tiền bạn cần vay
                      dataUsers.add(DataUsers(
                        key: "tien_can_vay",
                        value: _moneyLoanRootController.text.replaceAll(",", ""),
                        type: 0,
                      ));

                      //ty le lãi xuất năm
                      dataUsers.add(DataUsers(
                        key: "ty_le_lai_suat",
                        value: _tyLeLaiXuatController.text,
                        type: 0,
                      ));

                      //kỳ hạn vay
                      dataUsers.add(DataUsers(
                        key: "ky_han_vay",
                        value: _kyHanVayController.text,
                        type: 0,
                      ));

                      //phan kỳ trả tiền gốc
                      dataUsers.add(DataUsers(
                        key: "phan_ky_tien_goc",
                        value: _numberMonthTienGocController.text,
                        type: 0,
                      ));

                      //phan kỳ trả tiền lãi
                      dataUsers.add(DataUsers(
                        key: "phan_ky_tien_goc",
                        value: _numberMonthTienLaiController.text,
                        type: 0,
                      ));

                      //ngày vay
                      dataUsers.add(DataUsers(
                        key: "ngay_vay",
                        value: dateFirst,
                        type: 0,
                      ));

                      storeDataTool.dataUsers = dataUsers;


                    },
                  )),
            ),
          ],
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
    APIManager.postAPICallNeedToken(RemoteServices.storeDataItemToolURL, obj).then((value) async {
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
}
