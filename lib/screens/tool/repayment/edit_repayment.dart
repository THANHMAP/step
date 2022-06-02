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
import '../../../constants.dart';
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

class EditRepaymentScreen extends StatefulWidget {
  const EditRepaymentScreen({Key? key}) : super(key: key);

  @override
  _EditRepaymentScreenState createState() => _EditRepaymentScreenState();
}

class _EditRepaymentScreenState extends State<EditRepaymentScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _nameRepaymentController = TextEditingController();
  TextEditingController _moneyPaymentController = TextEditingController();
  TextEditingController _numberPaymentController = TextEditingController();
  TextEditingController _numberDayController = TextEditingController();
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  late ToolData data;
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
  int currentRepaymentCycleIndex = 0;
  String dateFirst = "";
  final minDate = DateTime.now();
  String userId = Get.arguments.toString();
  bool showEdit = false;
  String currentDate = "";

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
              text: data.name,
              onClicked: () {
                Get.back(result: false);
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
                      Visibility(
                        visible: !showEdit,
                        child: Container(
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
                                        _nameRepaymentController.text
                                            .toString(),
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
                                        _moneyPaymentController.text,
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
                                        getNameRepayment(
                                            currentRepaymentCycleIndex),
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
                                        _numberPaymentController.text,
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

                                    // const SizedBox(height: 10),
                                    // const Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Text(
                                    //     "Ngày trả nợ tiếp theo",
                                    //     textAlign: TextAlign.left,
                                    //     style: const TextStyle(
                                    //       fontSize: 16,
                                    //       color: Mytheme.color_82869E,
                                    //       fontWeight: FontWeight.w400,
                                    //       fontFamily: "OpenSans-Regular",
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(height: 4),
                                    // Align(
                                    //   alignment: Alignment.centerLeft,
                                    //   child: Text(
                                    //     currentDate.isNotEmpty == true ? nextDayRepayment():"",
                                    //     textAlign: TextAlign.left,
                                    //     style: const TextStyle(
                                    //       fontSize: 16,
                                    //       color: Mytheme.colorTextSubTitle,
                                    //       fontWeight: FontWeight.w600,
                                    //       fontFamily: "OpenSans-SemiBold",
                                    //     ),
                                    //   ),
                                    // ),
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
                                        _numberDayController.text,
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorTextSubTitle,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "OpenSans-SemiBold",
                                        ),
                                      ),
                                    ),

                                    Image.asset(
                                      "assets/images/schedule.png",
                                      width: 190,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: showEdit,
                        child: Container(
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
                                          hintText: "Lịch trả nợ món vay mới",
                                          // labelText: "Phone number",
                                          // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                          suffixIcon: Icons.close,
                                          clickSuffixIcon: () =>
                                              _nameRepaymentController.clear(),
                                          textController:
                                              _nameRepaymentController),
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
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xFFEFF0FB),
                                          filled: true,
                                          hintText: "Nhập số tiền",
                                          hintStyle: const TextStyle(
                                              color: Color(0xFFA7ABC3)),
                                          // labelText: labelText,

                                          suffixIcon: IconButton(
                                              onPressed: () {},
                                              icon: SvgPicture.asset(
                                                  "assets/svg/ic_vnd.svg")),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.green,
                                                  width: 1.7),
                                              borderRadius:
                                                  BorderRadius.circular(14))),
                                      onChanged: (value) {
                                        value = '${formNum(
                                          value.replaceAll(',', ''),
                                        )}';
                                        _moneyPaymentController.value =
                                            TextEditingValue(
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
                                        "Chu kỳ trả nợ",
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
                                    repaymentCycle(),

                                    //
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Column(
                                              children: [
                                                const Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Số lần trả nợ",
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Mytheme
                                                          .colorTextSubTitle,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          "OpenSans-SemiBold",
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                SizedBox(
                                                  child: TextFieldWidget(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      obscureText: false,
                                                      hintText: "Số lần",
                                                      // labelText: "Phone number",
                                                      // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                                      suffixIcon: Icons.close,
                                                      clickSuffixIcon: () =>
                                                          _numberPaymentController
                                                              .clear(),
                                                      textController:
                                                          _numberPaymentController),
                                                ),
                                              ],
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: Column(
                                              children: [
                                                const Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Ngày trả nợ đầu tiên",
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Mytheme
                                                          .colorTextSubTitle,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily:
                                                          "OpenSans-SemiBold",
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color: Mytheme
                                                        .colorTextDivider,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 1,
                                                        blurRadius: 7,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 12,
                                                                  left: 16,
                                                                  bottom: 18,
                                                                  right: 0),
                                                          child: Text(
                                                            dateFirst,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Mytheme
                                                                  .colorBgButtonLogin,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "OpenSans-Semibold",
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 0,
                                                                  left: 6,
                                                                  bottom: 0,
                                                                  right: 0),
                                                          child: IconButton(
                                                            icon: SvgPicture.asset(
                                                                "assets/svg/ic_calender.svg"),
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
                                              ],
                                            ))
                                      ],
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
                                      controller: _numberDayController,
                                      enabled: true,
                                      textInputAction: TextInputAction.done,
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                          fillColor: const Color(0xFFEFF0FB),
                                          filled: true,
                                          hintText: "Nhập số ngày",
                                          hintStyle: const TextStyle(
                                              color: Color(0xFFA7ABC3)),
                                          // labelText: labelText,

                                          suffixIcon: IconButton(
                                              onPressed: () {},
                                              icon: SvgPicture.asset(
                                                  "assets/svg/ic_day.svg")),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.grey, width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(14)),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.green,
                                                  width: 1.7),
                                              borderRadius:
                                                  BorderRadius.circular(14))),
                                    ),

                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Mytheme.color_DCDEE9,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            bottom: 10,
                                            left: 12,
                                            right: 12),
                                        child: Text(
                                          "Lưu ý: Bạn chỉ được sửa thông tin trước ngày nhắc nợ đầu tiên ",
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Mytheme.color_82869E,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "OpenSans-Regular",
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
                      !showEdit ? "Sửa" : "Lưu",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "OpenSans-Regular",
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (!showEdit) {
                        setState(() {
                          showEdit = true;
                        });
                      } else {
                        if(_nameRepaymentController.text.isEmpty) {
                          Utils.showError("Bạn chưa nhập tên", context);
                        } else {


                        UpdateDataTool updateDataTool = UpdateDataTool();
                        updateDataTool.title = _nameRepaymentController.text;
                        updateDataTool.userToolId = int.parse(userId);
                        updateDataTool.type = 1;
                        List<UpdateDataToolUsers>? listData = [];
                        //so tien can thanh toan moi kì
                        listData.add(UpdateDataToolUsers(
                          key: "payment_amount",
                          value:
                              _moneyPaymentController.text.replaceAll(',', ''),
                          type: 1,
                        ));

                        //Chu kì trả nợ
                        listData.add(UpdateDataToolUsers(
                          key: "repayment_cycle",
                          value:
                              _listRepaymentCycle[currentRepaymentCycleIndex],
                          type: currentRepaymentCycleIndex,
                        ));

                        //số lần trả nợ
                        listData.add(UpdateDataToolUsers(
                          key: "repayment_number",
                          value: _numberPaymentController.text,
                          type: 3,
                        ));

                        //ngày trả nợ
                        listData.add(UpdateDataToolUsers(
                          key: "repayment_day",
                          value: dateFirst,
                          type: 4,
                        ));

                        //ngày nhận thông báo trả nợ
                        listData.add(UpdateDataToolUsers(
                          key: "repayment_number_day",
                          value: _numberDayController.text,
                          type: 5,
                        ));

                        updateDataTool.dataUsers = listData;
                        print(jsonEncode(updateDataTool));
                        saveItemTool(jsonEncode(updateDataTool));
                        }
                      }
                    },
                  )),
            ),
          ],
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
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var i = 0;
                                i < _listRepaymentCycle.length;
                                i++) ...[
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
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
                                        visible: currentRepaymentCycleIndex == i
                                            ? true
                                            : false,
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  String nextDayRepayment() {
    var month = DateTime.now().month;
    var text = "";
    List<String> test = [];
    for (int i = 0; i < currentRepaymentCycleIndex + 1; i++) {
      test.add(showDay());
    }

    for (int i = 0; i < test.length; i++) {
      var dates = test[i].split("-");
      var montht = int.parse(dates[1]);
      if (montht >= month) {
        text = test[i];
        break;
      }
    }
    return text;
  }

  String showDay() {
    var dates = currentDate.replaceAll("-", "/").split("/");
    var month = int.parse(dates[1]);
    var year = int.parse(dates[2]);
    month = month + 1;
    if (month > 12) {
      month = month - 12;
      year = year + 1;
    }
    currentDate = "${dates[0]}/${month}/${year}";
    return "${dates[0]}-${month}-${year}";
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
          _nameRepaymentController.text = data.data!.name!;
          for (var i = 0; i < dataUsers.length; i++) {
            if (dataUsers[i].key == "payment_amount") {
              _moneyPaymentController.text =
                  formNum(dataUsers[i].value.toString());
            } else if (dataUsers[i].key == "repayment_cycle") {
              currentRepaymentCycleIndex = dataUsers[i].type!;
            } else if (dataUsers[i].key == "repayment_number") {
              _numberPaymentController.text = dataUsers[i].value.toString();
            } else if (dataUsers[i].key == "repayment_day") {
              dateFirst = dataUsers[i].value.toString();
              currentDate = dateFirst;
            } else if (dataUsers[i].key == "repayment_number_day") {
              _numberDayController.text = dataUsers[i].value.toString();
            }
          }
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
    );
    if (datePicked != null) {
      setState(() {
        dateFirst = '${datePicked.day}/${datePicked.month}/${datePicked.year}';
      });
    }
  }
}
