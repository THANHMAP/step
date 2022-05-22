import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/constants.dart';
import 'package:step_bank/models/education_model.dart';
import 'package:step_bank/models/news_model.dart';
import 'package:step_bank/models/tool_model.dart';
import 'package:step_bank/screens/tool/budget/detail_budget.dart';
import 'package:step_bank/screens/tool/loan/add_loan.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../../compoment/card_education.dart';
import '../../../compoment/card_item_tool.dart';
import '../../../compoment/card_setting.dart';
import '../../../compoment/confirm_dialog_icon.dart';
import '../../../compoment/dialog_success.dart';
import '../../../models/tool/detail_tool.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../themes.dart';
import '../../../util.dart';

class ViewFlowMoneyScreen extends StatefulWidget {
  const ViewFlowMoneyScreen({Key? key}) : super(key: key);

  @override
  _ViewFlowMoneyScreenState createState() => _ViewFlowMoneyScreenState();
}

class _ViewFlowMoneyScreenState extends State<ViewFlowMoneyScreen>
    with WidgetsBindingObserver {
  late ProgressDialog pr;
  ItemToolData? _itemToolData;
  String dates = "";
  String danhMuc = "";
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  List<DataUsers> dataUsers = [];
  bool selectItem = true;
  List<DataManage> dataManage = [];
  String moneySaveTarget = "0";
  int moneyHasSave = 0;
  int moneyTienRa = 0;
  String moneyHasSaveRoot = "0";
  String presentShow = "";
  String dayEnd = "";
  double present = 0;
  var totalMonth = 0;
  bool validate = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _itemToolData = Get.arguments;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadDataTool(_itemToolData?.id.toString() ?? "0");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("onResumed");
        break;
      case AppLifecycleState.inactive:
        print("onPaused()");
        break;
      case AppLifecycleState.paused:
        print("onInactive()");
        break;
      case AppLifecycleState.detached:
        print("detached()");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Mytheme.colorBgMain,
        body: Column(
          children: <Widget>[
            AppbarWidget(
              text: _itemToolData?.name ?? "",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 70),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      Container(
                        margin: EdgeInsets.all(16),
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
                              Padding(
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
                                              "Tiền vào",
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
                                              "${formNum(moneyHasSave.toString())} VND",
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
                                              "Tiền ra",
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
                                              "${formNum(moneyTienRa.toString())} VND",
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
                                        color: Mytheme.color_BCBFD6
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

                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "${formNum((moneyHasSave - moneyTienRa).toString())} VND",
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
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed("/reportFlowMoneyScreen", arguments: _itemToolData?.id.toString() ?? "0");
                                      },
                                      child: Container(
                                          margin: EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Mytheme.colorBgButtonLogin)
                                          ),
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(top: 10, bottom: 10, left: 0, right: 0),
                                            child: Text(
                                              "Báo cáo chi tiêu tháng",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Mytheme.color_434657,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "OpenSans-Semibold",
                                              ),
                                            ),
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),

                      ),

                      SizedBox(height: 10),

                      for(var i = 0; i < dataManage.length; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 0.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/svg/ic_calender.svg"),
                                  SizedBox(width: 5,),
                                  Text(
                                    dataManage[i].name ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Mytheme.colorTextSubTitle,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "OpenSans-Regular",
                                    ),
                                  ),
                                ],
                              ),

                            ),
                            Spacer(),
                            Padding(
                              padding:
                              const EdgeInsets.only(right: 16),
                              child:  Text(
                                "${formNum(calculatorTotalMonth(dataManage[i].itemList!))} VNĐ",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorBgButtonLogin,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-SemiBold",
                                ),
                              ),
                            ),

                          ],
                        ),
                        for(var po = 0; po < dataManage[i].itemList!.length; po++)...[
                          Container(
                            margin: const EdgeInsets.only(
                                left: 16.0, right: 16.0, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Mytheme.color_DCDEE9,
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
                              padding: const EdgeInsets.only(top: 10, left: 12, right: 12, bottom: 10),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      dataManage[i].itemList![po].note?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      convert(dataManage[i].itemList![po].date ?? "").replaceAll("-", "/"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      dataManage[i].itemList![po].type == 1? "+ ${formNum(dataManage[i].itemList![po].deposit ?? "0")}" : "- ${formNum(dataManage[i].itemList![po].withdraw ?? "0")}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                          ),
                        ],

                      ],




                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     Get.offAndToNamed("/editSaveToolScreen", arguments: _itemToolData?.id);
                  //   },
                  //   child: Container(
                  //       margin: EdgeInsets.only(left: 16, right: 16, bottom: 5),
                  //       alignment: Alignment.center,
                  //       decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           borderRadius: BorderRadius.circular(8),
                  //           border:
                  //           Border.all(color: Mytheme.colorBgButtonLogin)),
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(
                  //             top: 10, bottom: 10, left: 16, right: 16),
                  //         child: Text(
                  //           "Sửa",
                  //           style: TextStyle(
                  //             fontSize: 16,
                  //             color: Mytheme.color_434657,
                  //             fontWeight: FontWeight.w600,
                  //             fontFamily: "OpenSans-Semibold",
                  //           ),
                  //         ),
                  //       )),
                  // ),

                  Padding(
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 16, right: 16),
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
                          "Thêm giao dịch mới",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          selectItem = true;
                          validate = false;
                          _moneyController.clear();
                          _noteController.clear();
                          dates = formatDate(int.parse(DateTime.now().day.toString()), int.parse(DateTime.now().month.toString()), int.parse(DateTime.now().year.toString()));
                          _sexEditModalBottomSheet(context);
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String convert(String date) {
    return DateFormat("dd-MM-yyyy").format(DateTime.parse(date));
  }

  void _sexEditModalBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topLeft: Radius.circular(10),
              bottomRight: Radius.zero,
              topRight: Radius.circular(10)),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: 20,
                    left: 16,
                    right: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .67,
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 38,
                        alignment: Alignment.center,
                        child: Stack(
                          children: <Widget>[
                            Align(
                                alignment: Alignment.centerRight,
                                child: SizedBox(
                                  width: 40,
                                  child: IconButton(
                                    icon: Image.asset(
                                        "assets/images/ic_close.png"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectItem = true;
                                  _selectedFruit = 0;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 0.0, right: 16.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: selectItem
                                      ? Mytheme.color_0xFFCCECFB
                                      : Mytheme.kBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: !selectItem
                                      ? Border.all(
                                      color: Mytheme.kBackgroundColor)
                                      : null,
                                  boxShadow: selectItem? null : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 12, right: 12, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Thu nhập",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: selectItem
                                              ? Mytheme.color_0xFF2655A6
                                              : Mytheme.color_82869E,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-SemiBold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectItem = false;
                                  _selectedFruit = 0;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 0.0, right: 0.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: !selectItem ? Mytheme.color_0xFFCCECFB: Mytheme.kBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: !selectItem ? null : Border.all(color: Mytheme.kBackgroundColor) ,
                                  boxShadow: !selectItem? null : [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16, left: 12, right: 12, bottom: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Chi tiêu",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: !selectItem ? Mytheme.color_0xFF2655A6 : Mytheme.color_82869E,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-SemiBold",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ngày",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Mytheme.colorTextSubTitle,
                            fontWeight: FontWeight.w600,
                            fontFamily: "OpenSans-SemiBold",
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Mytheme.colorTextDivider,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
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
                                padding: EdgeInsets.only(
                                    top: 12, left: 16, bottom: 18, right: 0),
                                child: Text(
                                  dates,
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
                                  icon: SvgPicture.asset(
                                      "assets/svg/ic_calender.svg"),
                                  // tooltip: 'Increase volume by 10',
                                  iconSize: 50,
                                  onPressed: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                          containerHeight: 210.0,
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime(2022, 1, 1),
                                        maxTime: DateTime(2030, 12, 31),
                                        onConfirm: (date) {
                                          print('confirm $date');
                                          // _date = '${date.year} - ${date.month} - ${date.day}';
                                          setState(() {
                                            dates = formatDate(int.parse(date.day.toString()), int.parse(date.month.toString()), int.parse(date.year.toString()));
                                          });
                                        },
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.vi);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Số tiền",
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
                        controller: _moneyController,
                        enabled: true,
                        textInputAction: TextInputAction.done,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            fillColor: const Color(0xFFEFF0FB),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            errorBorder: validate ? OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red, width: 1),
                                borderRadius: BorderRadius.circular(8)) : OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            errorText: validate ? "Tiền rút ra không được lớn hơn tiền đang có" : "",
                            filled: true,
                            hintText: "Nhập số tiền",
                            hintStyle:
                            const TextStyle(color: Color(0xFFA7ABC3)),
                            isDense: true,
                            // Added this
                            contentPadding: EdgeInsets.all(8),
                            // labelText: labelText,

                            suffixIcon: IconButton(
                                onPressed: () {},
                                icon:
                                SvgPicture.asset("assets/svg/ic_vnd.svg")),
                            enabledBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                              // borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                borderRadius: BorderRadius.circular(8))),
                        onChanged: (value) {
                          value = '${formNum(
                            value.replaceAll(',', ''),
                          )}';
                          _moneyController.value = TextEditingValue(
                            text: value,
                            selection: TextSelection.collapsed(
                              offset: value.length,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Danh mục",
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
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Mytheme.colorTextDivider,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: InkWell(
                                onTap: () {
                                  _showDialog(
                                    CupertinoPicker(
                                      magnification: 1.22,
                                      squeeze: 1.2,
                                      useMagnifier: true,
                                      itemExtent: _kItemExtent,
                                      // This is called when selected item is changed.
                                      onSelectedItemChanged: (int selectedItem) {
                                        setState(() {
                                          _selectedFruit = selectedItem;
                                        });
                                      },
                                      children:
                                      List<Widget>.generate(!selectItem ?cashOut.length : cashIn.length, (int index) {
                                        return Center(
                                          child: Text(
                                            !selectItem ? cashOut[index]: cashIn[index],
                                          ),
                                        );
                                      },
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 12, left: 16, bottom: 18, right: 0),
                                  child: Text(
                                    !selectItem ? cashOut[_selectedFruit] : cashIn[_selectedFruit],
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

                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 6, bottom: 0, right: 0),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                      "assets/svg/arow_down.svg"),
                                  // tooltip: 'Increase volume by 10',
                                  iconSize: 50,
                                  onPressed: () {
                                    _showDialog(
                                      CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: _kItemExtent,
                                        // This is called when selected item is changed.
                                        onSelectedItemChanged: (int selectedItem) {
                                          setState(() {
                                            _selectedFruit = selectedItem;
                                          });
                                        },
                                        children:
                                        List<Widget>.generate(!selectItem ?cashOut.length : cashIn.length, (int index) {
                                          return Center(
                                            child: Text(
                                              !selectItem ? cashOut[index]: cashIn[index],
                                            ),
                                          );
                                        },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 40, bottom: 0, left: 0, right: 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  // side: const BorderSide(color: Colors.red)
                                ),
                                primary: Mytheme.colorBgButtonLogin,
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width, 44)),
                            child: Text(
                              "Lưu thay đổi",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "OpenSans-Regular",
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {

                              if(_moneyController.text.isEmpty) {
                                Utils.showError("Vui lòng nhập số tiền", context);
                                return;
                              }

                              var text = "";
                              Navigator.of(context).pop();
                              if(selectItem) {
                                text = "1"; // thu nhap
                                addDataDrawTool(
                                    _itemToolData?.id.toString() ?? "0",
                                    text,
                                    "0",
                                    _moneyController.text.replaceAll(",", ""),
                                    dates,
                                    !selectItem ? cashOut[_selectedFruit] : cashIn[_selectedFruit]
                                );
                              } else {
                                text = "2";
                                addDataDrawTool(
                                    _itemToolData?.id.toString() ?? "0",
                                    text,
                                    _moneyController.text.replaceAll(",", ""),
                                    "0",
                                    dates,
                                    !selectItem ? cashOut[_selectedFruit] : cashIn[_selectedFruit]
                                );
                              }


                            },
                          )),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  int _selectedFruit = 0;

  static const double _kItemExtent = 32.0;
  static const List<String> cashOut = <String>[
    'Gửi tiết kiệm',
    'Ăn uống',
    'Bảo hiểm',
    'Chi phí đi lại',
    'Đầu tư',
    'Hóa đơn tiện ích',
    'Gia đình',
    'Giáo dục',
    'Giải trí',
    'Quần áo, mua sắm',
    'Thuế',
    'Y tế/Sức khỏe',
    'Chi phí khác',
    'Du lịch',
    'Kinh doanh',
    'Thuê nhà',
  ];

  static const List<String> cashIn = <String>[
    'Lương làm thuê',
    'Lương vợ/chồng',
    'Thu nhập tiền cho thuê',
    'Tiền thưởng',
    'Tiền lãi/gốc tiết kiệm',
    'Các khoản chuyển tiền được nhận',
    'Bán đồ cũ',
    'Các nguồn thu nhập khác',
  ];

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
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
    APIManager.postAPICallNeedToken(RemoteServices.getDetailItemToolURL, param)
        .then((value) async {
      pr.hide();
      var data = DetailTool.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          dataUsers = data.data!.dataUsers!;
          for(var i =0; i< dataUsers.length; i++) {
            if(dataUsers[i].key == "money_has"){
              moneyHasSave = int.parse(dataUsers[i].value.toString());
              moneyHasSaveRoot = dataUsers[i].value.toString();
            }
          }
        });
        loadDataDrawTool(id);
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadDataDrawTool(String id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.listWithDrawToolURL, param)
        .then((value) async {
      pr.hide();
      int statusCode = value['status_code'];
      if (statusCode == 200) {
        final parsedJson = value['data'];
        print(parsedJson);
        dataManage.clear();

        Map mapValue = value;
        var data = mapValue['data'].toString();

        if (data != "[]") {
          mapValue['data'].forEach((key, value) {
            List<ItemManage> itemManage = [];
            if (value != null && value.toString() != "[]") {
              value.forEach((item) {
                itemManage.add(ItemManage.fromJson(item));
              });
              dataManage.add(DataManage(name: key, itemList: itemManage));
            }
          });
        }

        setState(() {
          dataManage;
          moneyTienRa = 0;
          moneyHasSave = 0;
          totalMonth = 0;
          // dataManage = (dataManage..sort()).reversed.toList();
          dataManage.sort((a, b) => b.name!.compareTo(a.name ?? ""));
          for(var i = 0; i < dataManage.length; i++) {
            if(dataManage[i].itemList != null && dataManage[i].itemList!.isNotEmpty) {
              for(var ii = 0; ii < dataManage[i].itemList!.length; ii++) {
                var item = dataManage[i].itemList![ii];
                if(item.type == 1) {
                  moneyHasSave = moneyHasSave + int.parse(item.deposit.toString());
                  totalMonth = totalMonth + int.parse(item.deposit.toString());
                } else {
                  moneyTienRa = moneyTienRa + int.parse(item.withdraw.toString());
                  totalMonth = totalMonth - int.parse(item.withdraw.toString());
                }
              }
            }
          }
          // if(int.parse(moneyHasSave)/ int.parse(moneySaveTarget) > 1) {
          //   present = 1;
          // } else {
          //   present = int.parse(moneyHasSave)/ int.parse(moneySaveTarget);
          // }
          // if(dataUsers.isNotEmpty) {
          //   presentShow = "${(int.parse(moneyHasSave)/int.parse(moneySaveTarget)*100).round().toString()}%";
          // }
        });

        print(dataManage);
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

  Future<void> addDataDrawTool(String user_tool_id, String type,
      String withdraw, String deposit, String date, String note) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      "user_tool_id": user_tool_id,
      "type":type,
      "withdraw":withdraw,
      "deposit": deposit,
      "date":date.replaceAll("/", "-"),
      "note":note
    });
    APIManager.postAPICallNeedToken(RemoteServices.storeWithDrawToolURL, param)
        .then((value) async {
      pr.hide();
      int statusCode = value['status_code'];
      if (statusCode == 200) {
        loadDataDrawTool(user_tool_id);
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  String calculatorTotalMonth(List<ItemManage> itemList) {
    var total = 0;
    if(itemList.isNotEmpty) {
      for(var i=0; i<itemList.length; i++) {
        if(itemList[i].type == 1) {
          total = total + int.parse(itemList[i].deposit.toString());
        } else {
          total = total - int.parse(itemList[i].withdraw.toString());
        }
      }
      totalMonth = totalMonth + total;
      return total.toString();
    }
    return "0";
  }

  // String calculatorPresent() {
  //   if(dataUsers.isNotEmpty) {
  //     return "${(int.parse(moneyHasSave)/int.parse(moneySaveTarget)*100).round().toString()}%";
  //   }
  //   return "0";
  // }

}

class DataManage {
  final String? name;
  final List<ItemManage>? itemList;

  DataManage({this.name, this.itemList});
}

class ItemManage {
  int? id;
  int? userToolId;
  String? withdraw;
  String? deposit;
  int? type;
  String? date;
  String? dateGroupMonth;
  String? createdAt;
  String? note;

  ItemManage(
      {this.id,
        this.userToolId,
        this.withdraw,
        this.deposit,
        this.type,
        this.date,
        this.dateGroupMonth,
        this.createdAt,
        this.note});

  ItemManage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userToolId = json['user_tool_id'];
    withdraw = json['withdraw'];
    deposit = json['deposit'];
    type = json['type'];
    date = json['date'];
    dateGroupMonth = json['date_group_month'];
    createdAt = json['createdAt'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_tool_id'] = this.userToolId;
    data['withdraw'] = this.withdraw;
    data['deposit'] = this.deposit;
    data['type'] = this.type;
    data['date'] = this.date;
    data['date_group_month'] = this.dateGroupMonth;
    data['createdAt'] = this.createdAt;
    data['note'] = this.note;
    return data;
  }
}
