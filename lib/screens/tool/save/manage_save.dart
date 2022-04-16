import 'dart:convert';

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

class ManageSaveToolScreen extends StatefulWidget {
  const ManageSaveToolScreen({Key? key}) : super(key: key);

  @override
  _ManageSaveToolScreenState createState() => _ManageSaveToolScreenState();
}

class _ManageSaveToolScreenState extends State<ManageSaveToolScreen>
    with WidgetsBindingObserver {
  late ProgressDialog pr;
  ItemToolData? _itemToolData;
  String dates = "";
  TextEditingController _moneyController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  List<DataUsers> dataUsers = [];

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
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 0, bottom: 0, right: 0),
                        child: CircularPercentIndicator(
                          radius: 90.0,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 15.0,
                          percent: 0.5,
                          center: Container(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                Text(
                                  "40%",
                                  style: TextStyle(
                                    fontSize: 36,
                                    color: Mytheme.colorBgButtonLogin,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "OpenSans-Semibold",
                                  ),
                                ),
                                Text(
                                  "40.000.000 VND",
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
                        "Mục tiêu đến: 31/12/2022",
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
                                      "100.000.000 VND",
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
                                      "Mục tiêu tiết kiệm",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                    Text(
                                      "100.000.000 VND",
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
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(left: 16, right: 16, bottom: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: Mytheme.colorBgButtonLogin)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 16, right: 16),
                        child: Text(
                          "Sửa",
                          style: TextStyle(
                            fontSize: 16,
                            color: Mytheme.color_434657,
                            fontWeight: FontWeight.w600,
                            fontFamily: "OpenSans-Semibold",
                          ),
                        ),
                      )),
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
                  height: MediaQuery.of(context).size.height * .73,
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
                            child: Container(
                              margin:
                                  const EdgeInsets.only(left: 0.0, right: 16.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Mytheme.kBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Mytheme.color_0xFFA9B0D1)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 12, right: 12, bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/svg/ic_radio_no_select.svg"),
                                    SizedBox(width: 10),
                                    Text(
                                      "Gửi vào",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
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
                                  const EdgeInsets.only(left: 0.0, right: 0.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Mytheme.kBackgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Mytheme.color_0xFFA9B0D1)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 12, right: 12, bottom: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        "assets/svg/ic_radio_no_select.svg"),
                                    SizedBox(width: 10),
                                    Text(
                                      "Rút ra",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ],
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
                          "Ngày kết thúc",
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
                                        dates =
                                            '${date.day}/${date.month}/${date.year}';
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
                    ],
                  ),
                ),
              ),
            );
          });
        });
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

        List<DataManage> dataManage = [];
        Map mapValue = value;
        mapValue['data'].forEach((key, value) {
          List<ItemManage> itemManage = [];
          if(value != null && !value.isBlank) {
            value.forEach((item) {
              itemManage.add(ItemManage.fromJson(item));
            });
            dataManage.add(DataManage(name: key, itemList: itemManage));
          }
        });

        print(dataManage);

      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
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

  ItemManage(
      {this.id,
      this.userToolId,
      this.withdraw,
      this.deposit,
      this.type,
      this.date,
      this.dateGroupMonth,
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
    return data;
  }
}
