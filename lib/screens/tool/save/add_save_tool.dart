import 'dart:convert';

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
import '../../../compoment/dialog_success.dart';
import '../../../constants.dart';
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class DetailSaveToolScreen extends StatefulWidget {
  const DetailSaveToolScreen({Key? key}) : super(key: key);

  @override
  _DetailSaveToolScreenState createState() => _DetailSaveToolScreenState();
}

class _DetailSaveToolScreenState extends State<DetailSaveToolScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _nameSaveController = TextEditingController();
  TextEditingController _moneyWantSaveController = TextEditingController();
  TextEditingController _numberHasController = TextEditingController();
  TextEditingController _numberWeekController = TextEditingController();
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  late ToolData data;
  List<String> _listRepaymentCycle = ["2 tháng", "4 tháng", "6 tháng", "8 tháng", "12 tháng"];
  int currentRepaymentCycleIndex = 0;
  String dateFirst = "";
  String dateEnd = "";
  final minDate = DateTime.now();
  int moneySave = 0;
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
                  text: "Kế hoạch tiết kiệm",
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
                                          "Mục tiêu tiết kiệm của bạn",
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
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .singleLineFormatter
                                            ],
                                            textInputAction: TextInputAction.done,
                                            obscureText: false,
                                            hintText: "Nhập mục tiêu",
                                            // labelText: "Phone number",
                                            // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                            suffixIcon: Icons.close,
                                            clickSuffixIcon: () =>
                                                _nameSaveController.clear(),
                                            textController: _nameSaveController),
                                      ),
                                      //
                                      const SizedBox(height: 10),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Số tiền bạn muốn tiết kiệm",
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
                                        controller: _moneyWantSaveController,
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
                                          _moneyWantSaveController.value = TextEditingValue(
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
                                          "Số tiền bạn đang có",
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
                                        controller: _numberHasController,
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
                                          _numberHasController.value = TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                              offset: value.length,
                                            ),
                                          );
                                        },
                                      ),

                                      //
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: [
                                                  const Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "Ngày bắt đầu",
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
                                                                // DatePicker.showDatePicker(context,
                                                                //     theme: DatePickerTheme(
                                                                //       containerHeight: 210.0,
                                                                //     ),
                                                                //     showTitleActions: true,
                                                                //     minTime: DateTime(2022, 1, 1),
                                                                //     maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                                                                //       print('confirm $date');
                                                                //       // _date = '${date.year} - ${date.month} - ${date.day}';
                                                                //       setState(() {
                                                                //         dateFirst = '${date.day}/${date.month}/${date.year}';
                                                                //       });
                                                                //     }, currentTime: DateTime.now(), locale: LocaleType.vi);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              flex: 3,
                                              child: Column(
                                                children: [
                                                  const Align(
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
                                                              dateEnd,
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
                                                                showDatePickerEnd();
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                          )
                                        ],
                                      ),
//
                                      //
                                      const SizedBox(height: 10),
                                      const Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Tần suất tiết kiệm",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Mytheme.colorTextSubTitle,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "OpenSans-SemiBold",
                                          ),
                                        ),
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        obscureText: false,
                                        controller: _numberWeekController,
                                        enabled: true,
                                        textInputAction: TextInputAction.done,
                                        textAlignVertical: TextAlignVertical.center,
                                        decoration: InputDecoration(
                                            fillColor: const Color(0xFFEFF0FB), filled: true,
                                            hintText: "Nhập số tuần",
                                            hintStyle: const TextStyle(color: Color(0xFFA7ABC3)),
                                            // labelText: labelText,

                                            suffixIcon: IconButton(
                                                onPressed: (){},
                                                icon: SvgPicture.asset("assets/svg/ic_week.svg")
                                            ),
                                            enabledBorder:  OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(14)),

                                            focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.green, width: 1.7),
                                                borderRadius: BorderRadius.circular(14))),

                                      ),


                                      const SizedBox(height: 20),
                                      Container(
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
                                                  "Mỗi lần bạn phải tiết kiệm",
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
                                                  "${formNum(moneySave.toString())} VNĐ",
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

                                              InkWell(
                                                onTap: () {
                                                  var stringDateStart = dateFirst.split("-");
                                                  var stringDateEnd = dateEnd.split("-");
                                                  final dayStart = DateTime(int.parse(stringDateStart[2]), int.parse(stringDateStart[1]), int.parse(stringDateStart[0]));
                                                  final dayEnd = DateTime(int.parse(stringDateEnd[2]), int.parse(stringDateEnd[1]), int.parse(stringDateEnd[0]));
                                                  final differenceDay = daysBetween(dayStart, dayEnd);
                                                  if(differenceDay <= 0) {
                                                    Utils.showError("Ngày kết thúc không được nhỏ hơn hoặc bằng ngày bắt đầu", context);
                                                    return;
                                                  }
                                                  var calculatorWeek = int.parse(_numberWeekController.text)*7;
                                                  var solantietkiem = (differenceDay/calculatorWeek).toInt();
                                                  var soTienCanTietKiem = int.parse(_moneyWantSaveController.text.replaceAll(",", "")) - int.parse(_numberHasController.text.replaceAll(",", ""));
                                                  var result = (soTienCanTietKiem/solantietkiem).round();
                                                  // var result = int.parse(_moneyWantSaveController.text.replaceAll(",", "")) - int.parse(_numberHasController.text.replaceAll(",", "")) / numberSaver.round();
                                                  setState(() {
                                                    moneySave = result.round();
                                                  });
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
                                                        "Tính toán",
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
                                        ),

                                      ),

                                      const SizedBox(height: 10),
                                      Container(
                                        // color: const Color(0xFFEFF0FB),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFEFF0FB),
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 10, left: 12, right: 12, bottom: 10),
                                          child: Column(
                                            children:  [
                                              SvgPicture.asset("assets/svg/ic_text.svg",
                                                width: 320,)

                                            ],
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
                          "Lưu",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "OpenSans-Regular",
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          var stringDateStart = dateFirst.split("-");
                          var stringDateEnd = dateEnd.split("-");
                          final dayStart = DateTime(int.parse(stringDateStart[2]), int.parse(stringDateStart[1]), int.parse(stringDateStart[0]));
                          final dayEnd = DateTime(int.parse(stringDateEnd[2]), int.parse(stringDateEnd[1]), int.parse(stringDateEnd[0]));
                          final differenceDay = daysBetween(dayStart, dayEnd);
                          if(differenceDay <= 0) {
                            Utils.showError("Ngày kết thúc không được nhỏ hơn hoặc bằng ngày bắt đầu", context);
                            return;
                          }
                          // showDialogSuccess();
                          if(_nameSaveController.text.isEmpty) {
                            Utils.showError("Bạn chưa nhập tên", context);
                          } else {
                            StoreDataTool storeDataTool = StoreDataTool();
                            storeDataTool.title = _nameSaveController.text;
                            storeDataTool.toolId = data.id;
                            storeDataTool.type = 1;
                            //
                            //so tien bạn muốn tiết kiệm
                            dataUsers.add(DataUsers(
                              key: "money_want_save",
                              value: _moneyWantSaveController.text.replaceAll(',',
                                  ''),
                              type: 1,
                            ));
                            //
                            //so tien bạn có
                            dataUsers.add(DataUsers(
                              key: "money_has",
                              value: _numberHasController.text.replaceAll(',', ''),
                              type: 2,
                            ));
                            //
                            //ngày bắt dầu
                            dataUsers.add(DataUsers(
                              key: "day_start",
                              value: dateFirst,
                              type: 3,
                            ));
                            //ngày kết thúc
                            dataUsers.add(DataUsers(
                              key: "day_end",
                              value: dateEnd,
                              type: 4,
                            ));
                            //
                            //tần suất tiet kiem
                            dataUsers.add(DataUsers(
                              key: "repayment_cycle",
                              value: _numberWeekController.text,
                              type: 5,
                            ));
                            //
                            storeDataTool.dataUsers = dataUsers;
                            print(jsonEncode(storeDataTool));
                            saveItemTool(jsonEncode(storeDataTool));
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


  repaymentCycle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
      child: InkWell(
        onTap: () {
          _repaymentCycleEditModalBottomSheet(context);
        },
        child: Container(
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
                    getNameRepayment(currentRepaymentCycleIndex),
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
                    icon: Image.asset("assets/images/ic_arrow_down.png"),
                    // tooltip: 'Increase volume by 10',
                    iconSize: 50,
                    onPressed: () {
                      // _sexEditModalBottomSheet(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _repaymentCycleEditModalBottomSheet(context) {
    showModalBottomSheet(
        backgroundColor: Mytheme.kBackgroundColor,
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
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "Chọn chu kỳ trả nợ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Mytheme.color_434657,
                                fontWeight: FontWeight.w600,
                                fontFamily: "OpenSans-Semibold",
                                // decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: SizedBox(
                                width: 40,
                                child: IconButton(
                                  icon:
                                  Image.asset("assets/images/ic_close.png"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var i = 0; i < _listRepaymentCycle.length; i++) ...[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  currentRepaymentCycleIndex = i;
                                  this.setState(() {
                                    // user.gender = currentSexIndex;
                                  });
                                });
                              },
                              child: Container(
                                height: 60,
                                color: currentRepaymentCycleIndex == i
                                    ? Mytheme.color_DCDEE9
                                    : Mytheme.kBackgroundColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: Text(
                                        _listRepaymentCycle[i],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.color_434657,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-Semibold",
                                          // decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),

                                    // di chuyen item tối cuối
                                    const Spacer(),
                                    Visibility(
                                      visible: currentRepaymentCycleIndex == i ? true : false,
                                      child: const Padding(
                                        padding: EdgeInsets.only(right: 16),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/images/img_check.png'),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    )

                  ],
                ),
              ),
            );
          });
        });
  }

  String getNameRepayment(int index) {
    return _listRepaymentCycle[index];
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
            showDialogSuccess();
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  showDialogSuccess(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: SuccessDialogBox(
                title: "Chúc mừng bạn đã tạo thành công Kế hoạch tiết kiệm!",
                descriptions:
                "Việc thực hiện tiết kiệm và quản lý theo kế hoạch là rất quan trọng. Đừng ngần ngại tiết kiệm nhiều hơn nếu có thể. Hãy nhớ giữ tiền ở nơi an toàn và tránh chi tiêu không cần thiết trước khi đạt được mục tiêu nhé.",
                textButton: "Tiếp tục",
                onClickedConfirm: () {
                  Get.back(result: true);
                  Get.back(result: true);
                },
              ));
        }
    );
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
    );
    if(datePicked != null) {
      setState(() {
        dateFirst = '${datePicked.day}-${datePicked.month}-${datePicked.year}';
      });
    }
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
    );
    if(datePicked != null) {
      setState(() {
        dateEnd = '${datePicked.day}-${datePicked.month}-${datePicked.year}';
      });
    }
  }

}
