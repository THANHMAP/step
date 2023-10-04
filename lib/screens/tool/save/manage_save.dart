import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
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
import '../../../compoment/dialog_content.dart';
import '../../../compoment/dialog_success.dart';
import '../../../compoment/info_dialog.dart';
import '../../../models/tool/detail_tool.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../themes.dart';
import '../../../util.dart';

class ManageSaveToolScreen extends StatefulWidget {
  const ManageSaveToolScreen({Key? key}) : super(key: key);

  @override
  _ManageSaveToolScreenState createState() => _ManageSaveToolScreenState();
}

class _ManageSaveToolScreenState extends State<ManageSaveToolScreen>
    with WidgetsBindingObserver {
  late ProgressDialog pr;
  // ItemToolData? _itemToolData;
  var userIdTool;
  var name = "";
  String dates = "";
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  List<DataUsers> dataUsers = [];
  bool selectItem = true;
  List<DataManage> dataManage = [];
  String moneySaveTarget = "0";
  String moneyHasSave = "0";
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
    userIdTool = Get.arguments;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadDataTool(userIdTool.toString());
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
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Mytheme.colorBgMain,
            body: Column(
              children: <Widget>[
                AppbarWidget(
                  text: name,
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
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 0, bottom: 0, right: 0),
                            child: CircularPercentIndicator(
                              radius: 90.0,
                              animation: true,
                              animationDuration: 1200,
                              lineWidth: 15.0,
                              percent: present,
                              center: Container(
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          presentShow,
                                          style: TextStyle(
                                            fontSize: 36,
                                            color: Mytheme.colorBgButtonLogin,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "OpenSans-Semibold",
                                          ),
                                        ),
                                        Text(
                                          "${formNum(moneyHasSave)} VNĐ",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Mytheme.colorTextSubTitle,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans-Regular",
                                          ),
                                        ),
                                      ])),
                              circularStrokeCap: CircularStrokeCap.butt,
                              backgroundColor: Mytheme.color_DCDEE9,
                              progressColor: Mytheme.color_0xFF003A8C,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Mục tiêu đến: $dayEnd",
                            style: TextStyle(
                              fontSize: 16,
                              color: Mytheme.colorTextSubTitle,
                              fontWeight: FontWeight.w400,
                              fontFamily: "OpenSans-Regular",
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 16.0, right: 16.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Mytheme.kBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 11, left: 12, right: 12, bottom: 11),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Mục tiêu tiết kiệm",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Mytheme.colorTextSubTitle,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans-Regular",
                                          ),
                                        ),
                                        Text(
                                          "${formNum(moneySaveTarget)} VNĐ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Mytheme.colorBgButtonLogin,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "OpenSans-SemiBold",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                  const EdgeInsets.only(left: 0.0, right: 16.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: Mytheme.kBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 11, left: 12, right: 12, bottom: 11),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Còn lại",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Mytheme.colorTextSubTitle,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans-Regular",
                                          ),
                                        ),
                                        Text(
                                          "${formNum((int.parse(moneySaveTarget)-int.parse(moneyHasSave)).toString())} VNĐ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Mytheme.colorBgButtonLogin,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "OpenSans-SemiBold",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
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
                              InkWell(
                                onTap: (){

                                },
                                child:  Container(
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
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                dataManage[i].itemList![po].deposit == "1" ? "Gửi vào" : "Rút ra",
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
                                                dataManage[i].itemList![po].date ?? "",
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
                                                "${formNum(dataManage[i].itemList![po].withdraw ?? "0")}",
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
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Ghi chú: ${dataManage[i].itemList![po].note}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.colorTextSubTitle,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "OpenSans-Regular",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [

                                            Expanded(
                                              child:  InkWell(
                                                onTap: (){
                                                  _editModalBottomSheet(context, dataManage[i].itemList![po]);
                                                },
                                                child: Container(
                                                  height: 31,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Mytheme.color_0xFFBDE8FF,
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
                                                    padding: const EdgeInsets.only(
                                                        top: 5, left: 12, bottom: 5, right: 12),
                                                    child:     Align(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "Sửa",
                                                        // textAlign: TextAlign.start,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Mytheme.color_121212,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: "OpenSans-Regular",
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: InkWell(
                                                onTap: (){
                                                  showDialogConfigDelete(dataManage[i].itemList![po].id.toString(), dataManage[i].itemList![po].userToolId.toString());
                                                },
                                                child:   Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 16),
                                                    child: Container(
                                                      height: 31,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.rectangle,
                                                        color: Mytheme.color_0xFFFFCFC9,
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
                                                        padding: const EdgeInsets.only(
                                                            top: 5, left: 0, bottom: 5, right: 0),
                                                        child:     Align(
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            "Xóa",
                                                            // textAlign: TextAlign.start,
                                                            style: const TextStyle(
                                                              fontSize: 16,
                                                              color: Mytheme.color_121212,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily: "OpenSans-Regular",
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    )
                                                ),
                                              ),
                                            ),

                                          ],
                                        )
                                      ],
                                    ),

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
                      //     Get.toNamed("/editSaveToolScreen", arguments: _itemToolData?.id);
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
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
              child: StatefulBuilder(builder: (BuildContext context,
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
                                            "Gửi vào",
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
                                            "Rút ra",
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
                                      onPressed: () async {
                                        showDatePicker();
                                        // var datePicked = await DatePicker.showSimpleDatePicker(
                                        //   context,
                                        //   initialDate: DateTime.now(),
                                        //   firstDate: DateTime(1960),
                                        //   lastDate: DateTime(2050),
                                        //   dateFormat: "dd-MMMM-yyyy",
                                        //   locale: DateTimePickerLocale.en_us,
                                        //   looping: true,
                                        //   cancelText: "Hủy bỏ",
                                        //   confirmText: "Cập nhật",
                                        //   titleText: "Chọn ngày",
                                        // );
                                        // if(datePicked != null) {
                                        //   setState(() {
                                        //     dates = formatDate(int.parse(datePicked.day.toString()), int.parse(datePicked.month.toString()), int.parse(datePicked.year.toString()));
                                        //   });
                                        // }
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
                              "Ghi chú",
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
                            keyboardType: TextInputType.multiline,
                            minLines: 1,
                            //Normal textInputField will be displayed
                            maxLines: 5,
                            // when user presses enter it will adapt to it
                            controller: _noteController,
                            textInputAction: TextInputAction.done,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                                fillColor: const Color(0xFFEFF0FB),
                                filled: true,
                                hintText: "Ghi chú về số tiền",
                                hintStyle:
                                const TextStyle(color: Color(0xFFA7ABC3)),
                                enabledBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(8)),
                                focusedBorder: OutlineInputBorder(
                                  // borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                    borderRadius: BorderRadius.circular(8))),
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
                                  if(selectItem) {
                                    text = "1"; // thu nhap
                                  } else {
                                    text = "2";
                                    if(int.parse(_moneyController.text.replaceAll(",", "")) > int.parse(moneyHasSave)) {
                                      setState(() {
                                        validate = true;
                                      });

                                      return;
                                    }// rút ra
                                  }
                                  Navigator.of(context).pop();
                                  addDataDrawTool(
                                      userIdTool.toString(),
                                      "1",
                                      _moneyController.text.replaceAll(",", ""),
                                      text,
                                      dates,
                                      _noteController.text.toString()
                                  );
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              }),
          );
        });
  }

  showDatePicker() async {
    var datePicked = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
      dateFormat: "dd-MM-yyyy",
      locale: DateTimePickerLocale.en_us,
      looping: true,
      cancelText: "Hủy bỏ",
      confirmText: "Cập nhật",
      titleText: "Chọn ngày",
    );
    if(datePicked != null) {
      setState(() {
        dates = formatDate(int.parse(datePicked.day.toString()), int.parse(datePicked.month.toString()), int.parse(datePicked.year.toString()));
      });
    }
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
          name = data.data!.name ?? "";
          dataUsers = data.data!.dataUsers!;
          for(var i =0; i< dataUsers.length; i++) {
            if(dataUsers[i].key == "money_want_save"){
              moneySaveTarget = dataUsers[i].value.toString();
            } else if(dataUsers[i].key == "money_has"){
              moneyHasSave = dataUsers[i].value.toString();
              moneyHasSaveRoot = dataUsers[i].value.toString();
            }else if(dataUsers[i].key == "day_end"){
              var data = dataUsers[i].value.toString();
              if(data.isNotEmpty) {
                var days = data.split("-");
                if(days.length == 3){
                  dayEnd = formatDate(int.parse(days[0].toString()) , int.parse(days[1].toString()), int.parse(days[2].toString()));
                }
              }


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
          totalMonth = 0;
          for(var i = 0; i < dataManage.length; i++) {
            if(dataManage[i].itemList != null && dataManage[i].itemList!.isNotEmpty) {
              for(var ii = 0; ii < dataManage[i].itemList!.length; ii++) {
                if(dataManage[i].itemList![ii].deposit == "1") {
                  totalMonth = totalMonth + int.parse(dataManage[i].itemList![ii].withdraw.toString());
                } else if(dataManage[i].itemList![ii].deposit == "2") {
                  totalMonth = totalMonth - int.parse(dataManage[i].itemList![ii].withdraw.toString());
                }
              }
            }
          }
          moneyHasSave = (int.parse(moneyHasSaveRoot) + totalMonth).toString();
          if(int.parse(moneyHasSave)/ int.parse(moneySaveTarget) > 1) {
            present = 1;
          } else {
            if (int.parse(moneyHasSave)/ int.parse(moneySaveTarget) < 0) {
              present = 0;
            } else {
              present = int.parse(moneyHasSave)/ int.parse(moneySaveTarget);
            }
          }
          if(dataUsers.isNotEmpty) {
            presentShow = "${(int.parse(moneyHasSave)/int.parse(moneySaveTarget)*100).round().toString()}%";
          }
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
        if(itemList[i].deposit == "1") {
          total = total + int.parse(itemList[i].withdraw.toString());
        } else {
          total = total - int.parse(itemList[i].withdraw.toString());
        }
      }
      totalMonth = totalMonth + total;
      return total.toString();
    }
    return "0";
  }

  String calculatorPresent() {
    if(dataUsers.isNotEmpty) {
      return "${(int.parse(moneyHasSave)/int.parse(moneySaveTarget)*100).round().toString()}%";
    }
   return "0";
  }

  showDatePickerEnd() async {
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
        dates = formatDate(int.parse(datePicked.day.toString()), int.parse(datePicked.month.toString()), int.parse(datePicked.year.toString()));
      });
    }
  }

  showDialogConfigDelete(String id, String user_tool_id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
            child: WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: ConfirmDialogBoxWithIcon(
                  title: "Bạn chắc chắn muốn xoá?",
                  textButtonLeft: "Huỷ",
                  textButtonRight: "Tiếp tục",
                  onClickedConfirm: () {
                    Navigator.pop(context, "");
                    deleteDataDrawTool(id, user_tool_id);
                  },
                  onClickedCancel: () {
                    Navigator.pop(context, "");
                  },
                )),
          );
        });
  }

  Future<void> deleteDataDrawTool(String id, String user_tool_id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{'user_tool_withdraw_id': id});
    APIManager.postAPICallNeedToken(
        RemoteServices.deleteDrawFilterToolURL, param)
        .then((value) async {
      int statusCode = value['status_code'];
      if (statusCode == 200) {
        if (statusCode == 200) {
          loadDataDrawTool(user_tool_id);
        }
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> editDataDrawTool(
      String user_tool_id,
      String id,
      String type,
      String withdraw,
      String deposit,
      String date,
      String note,
      String noteText) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      "user_tool_withdraw_id": id,
      "type": type,
      "withdraw": withdraw,
      "deposit": deposit,
      "date": date.replaceAll("/", "-"),
      "note": note,
      "note_text": noteText
    });
    APIManager.postAPICallNeedToken(RemoteServices.updateWithDrawToolURL, param)
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

  void _editModalBottomSheet(context, ItemManage item) {
    var money = "";
    if(item.withdraw != "0") {
      money = item.withdraw.toString();
    } else {
      money = item.deposit.toString();
    };
    _moneyController.text = formNum(money);
    _noteController.text = item.note.toString();
    var selectTab = int.parse(item.deposit.toString());
    var date = item.date.toString();
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
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
            child: StatefulBuilder(builder: (BuildContext context,
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
                                    selectTab = 1;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0, right: 16.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: selectTab == 1
                                        ? Mytheme.color_0xFFCCECFB
                                        : Mytheme.kBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: selectTab != 1
                                        ? Border.all(
                                        color: Mytheme.kBackgroundColor)
                                        : null,
                                    boxShadow: selectTab == 1? null : [
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
                                          "Gửi vào",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectTab == 1
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
                                    selectTab = 2;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 0.0, right: 0.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: selectTab != 1 ? Mytheme.color_0xFFCCECFB: Mytheme.kBackgroundColor,
                                    borderRadius: BorderRadius.circular(8),
                                    border: selectTab != 1 ? null : Border.all(color: Mytheme.kBackgroundColor) ,
                                    boxShadow: selectTab != 1?  null : [
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
                                          "Rút ra",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: selectTab != 1 ? Mytheme.color_0xFF2655A6 : Mytheme.color_82869E,
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
                                    date,
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
                                    onPressed: () async {
                                      var datePicked = await DatePicker.showSimpleDatePicker(
                                        context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1960),
                                        lastDate: DateTime(2050),
                                        dateFormat: "dd-MM-yyyy",
                                        locale: DateTimePickerLocale.en_us,
                                        looping: true,
                                        cancelText: "Hủy bỏ",
                                        confirmText: "Cập nhật",
                                        titleText: "Chọn ngày",
                                      );
                                      if(datePicked != null) {
                                        setState(() {
                                          date = formatDate(int.parse(datePicked.day.toString()), int.parse(datePicked.month.toString()), int.parse(datePicked.year.toString()));
                                        });
                                      }
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
                            "Ghi chú",
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
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          //Normal textInputField will be displayed
                          maxLines: 5,
                          // when user presses enter it will adapt to it
                          controller: _noteController,
                          textInputAction: TextInputAction.done,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              fillColor: const Color(0xFFEFF0FB),
                              filled: true,
                              hintText: "Ghi chú về số tiền",
                              hintStyle:
                              const TextStyle(color: Color(0xFFA7ABC3)),
                              enabledBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                // borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                  borderRadius: BorderRadius.circular(8))),
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
                                if(selectTab == 1) {
                                  text = "1"; // thu nhap

                                } else {
                                  text = "2";
                                  if(int.parse(_moneyController.text.replaceAll(",", "")) > int.parse(moneyHasSave)) {
                                    setState(() {
                                      validate = true;
                                    });
                                    return;
                                  }// rút ra
                                }

                                Navigator.of(context).pop();
                                editDataDrawTool(
                                    userIdTool.toString(),
                                    item.id.toString(),
                                    "1",
                                    _moneyController.text.replaceAll(",", ""),
                                    text,
                                    date,
                                    _noteController.text.toString(),
                                    ""
                                );

                              },
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }

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
        this.note,
      this.createdAt});

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
    data['note'] = note;
    return data;
  }


}
