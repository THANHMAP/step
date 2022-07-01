import 'dart:convert';

import 'package:charts_flutter/flutter.dart' as charts;
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
import '../../../compoment/dialog_success.dart';
import '../../../constants.dart';
import '../../../models/report/detail_report.dart';
import '../../../models/report/report_chart.dart';
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class DetailReportFlowMoneyScreen extends StatefulWidget {
  const DetailReportFlowMoneyScreen({Key? key}) : super(key: key);

  @override
  _DetailReportFlowMoneyScreenState createState() => _DetailReportFlowMoneyScreenState();
}

class _DetailReportFlowMoneyScreenState extends State<DetailReportFlowMoneyScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  bool selectDefault = true;
  List<DetailReportData> detailReportData = [];
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


  var sumTienVao = 0;
  var sumTienRa = 0;
  List<Item> listItemTienVao = [];
  List<Item> listItemTienRa = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      selectDefault = Constants.selectDefault;
    });
    detailReportData = Get.arguments;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    calculatorTienVao();
    calculatorTienRa();
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
                  text: "Theo dõi dòng tiền",
                  onClicked: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 0, right: 0, bottom: 70),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
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
                                      "Thu nhập",
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
                                      "Chi tiêu",
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
                          Visibility(
                            visible: selectDefault ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30, top: 10, left: 16, right: 16),
                              child: Column(
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
                                                      child:  Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          "Thu nhập",
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
                                                  ],
                                                ),

                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${formNum(sumTienVao.toString())} VND",
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


                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                  ),

                                  for(int i = 0; i < listItemTienVao.length; i++)...[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
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
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 0),
                                              child: Text(
                                                listItemTienVao[i].precent ?? "",
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
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 0),
                                              child: Text(
                                                listItemTienVao[i].name ?? "",
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
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 10),
                                              child: Text(
                                                formNum(listItemTienVao[i].total ?? ""),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.colorBgButtonLogin,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "OpenSans-Semibold",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],

                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !selectDefault ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30, top: 10, left: 16, right: 16),
                              child: Column(
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
                                                      child:  Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          "Chi tiêu",
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
                                                  ],
                                                ),

                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    "${formNum(sumTienRa.toString())} VND",
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


                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),

                                  ),

                                  for(int i = 0; i < listItemTienRa.length; i++)...[
                                    Container(
                                      margin: EdgeInsets.only(bottom: 10),
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
                                            flex: 1,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 0),
                                              child: Text(
                                                listItemTienRa[i].precent ?? "",
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
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 0),
                                              child: Text(
                                                listItemTienRa[i].name ?? "",
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
                                              padding: EdgeInsets.only(
                                                  top: 12, left: 16, bottom: 18, right: 10),
                                              child: Text(
                                                formNum(listItemTienRa[i].total ?? ""),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Mytheme.colorBgButtonLogin,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "OpenSans-Semibold",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
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
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }





 void calculatorTienVao(){
    for(int i = 0; i < detailReportData.length; i++) {
      sumTienVao = sumTienVao + int.parse(detailReportData[i].deposit ?? "0");
    }
    for(int i = 0; i < cashIn.length; i++) {
      var name = cashIn[i];
      var total = 0;
      for(int ii = 0; ii < detailReportData.length; ii++) {
          if(name == detailReportData[ii].note) {
            total = total + int.parse(detailReportData[ii].deposit ?? "0");
          }
      }
      if(total > 0) {
        var phanTram = ((total/sumTienVao)*100).round();
        listItemTienVao.add(Item("$phanTram%", name, total.toString()));
      }
    }
 }


  void calculatorTienRa(){
    for(int i = 0; i < detailReportData.length; i++) {
      sumTienRa = sumTienRa + int.parse(detailReportData[i].withDraw ?? "0");
    }
    for(int i = 0; i < cashOut.length; i++) {
      var name = cashOut[i];
      var total = 0;
      for(int ii = 0; ii < detailReportData.length; ii++) {
        if(name == detailReportData[ii].note) {
          total = total + int.parse(detailReportData[ii].withDraw ?? "0");
        }
      }
      if(total > 0) {
        var phanTram = ((total/sumTienRa)*100).round();
        listItemTienRa.add(Item("$phanTram%", name, total.toString()));
      }
    }
  }


  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }
}

class Item {
  String? precent;
  String? name;
  String? total;

  Item(this.precent, this.name, this.total);

}
