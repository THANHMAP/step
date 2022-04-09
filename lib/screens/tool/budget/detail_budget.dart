import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';

import 'package:step_bank/compoment/textfield_widget.dart';
import '../../../constants.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class DetailBudgetScreen extends StatefulWidget {
  const DetailBudgetScreen({Key? key}) : super(key: key);

  @override
  _DetailBudgetScreenState createState() => _DetailBudgetScreenState();
}

class _DetailBudgetScreenState extends State<DetailBudgetScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  TextEditingController _nameBudgetController = TextEditingController();
  TextEditingController _thuNhapController = TextEditingController();
  TextEditingController _soTienController = TextEditingController();
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Thu nhập'),
    Tab(text: 'Chi phí'),
  ];
  late TabController _tabController;
  List<DataUsers> dataUsers = [];
  var formatter = NumberFormat('#,##,000');
  int typeObj = 1;
  int totalType1 = 0;
  int totalType2 = 0;
  late ToolData data;
  bool showCalculator = true;
  bool showBudget = false;

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
    _tabController = TabController(vsync: this, length: myTabs.length);
    _tabController.addListener(_handleTabSelection);
    Future.delayed(Duration.zero, () {
      // loadListItemTool();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          typeObj = 1;
          break;
        case 1:
          typeObj = 2;
          break;
      }
    }
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
                if(showCalculator) {
                  Navigator.of(context).pop(false);
                } else {
                  setState(() {
                    showCalculator = true;
                    showBudget = false;
                  });
                }

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
                        visible: showCalculator,
                        child:  Container(
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 30, left: 24, right: 24),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Đây là ngân sách cho",
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
                                          hintText: "Viết tên của ngân sách này",
                                          // labelText: "Phone number",
                                          // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                          suffixIcon: Icons.close,
                                          clickSuffixIcon: () =>
                                              _nameBudgetController.clear(),
                                          textController: _nameBudgetController),
                                    ),
                                  ],
                                ),
                              ),
                              DefaultTabController(
                                length: 2,
                                child: SizedBox(
                                  height: 500.0,
                                  child: Column(
                                    children: <Widget>[
                                      TabBar(
                                        controller: _tabController,
                                        labelColor: Mytheme.color_active,
                                        unselectedLabelColor: Colors.grey,
                                        labelStyle: TextStyle(
                                          fontSize: 16,
                                          color: Mytheme.colorTextSubTitle,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "OpenSans-Regular",
                                        ),
                                        tabs: myTabs,
                                      ),
                                      Expanded(
                                        child: TabBarView(
                                          controller: _tabController,
                                          children: <Widget>[
                                            Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only( bottom: 30, top: 10, left: 16, right: 16),
                                                      child: Column(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(
                                                              "Hãy nhập nguồn thu của bạn. Bạn có thể điều chỉnh các nguồn thu này nếu cần",
                                                              textAlign: TextAlign.left,
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                color: Mytheme.color_82869E,
                                                                fontWeight: FontWeight.w400,
                                                                fontFamily:
                                                                "OpenSans-Regular",
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                          Align(
                                                            alignment: Alignment.centerRight,
                                                            child: Text(
                                                              "Đơn vị: VND",
                                                              textAlign: TextAlign.left,
                                                              style: const TextStyle(
                                                                fontSize: 14,
                                                                color: Mytheme.color_82869E,
                                                                fontWeight: FontWeight.w400,
                                                                fontFamily:
                                                                "OpenSans-Regular",
                                                              ),
                                                            ),
                                                          ),

                                                          for(var i=0; i< dataUsers.length; i++) ... [
                                                            if(dataUsers[i].type == 1)...[
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () async {
                                                                        setState(() {
                                                                          dataUsers.removeAt(i);
                                                                        });
                                                                      },
                                                                      child: Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.only(right: 10),
                                                                            child: SvgPicture.asset("assets/svg/ic_delete.svg"),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex:2,
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(right: 10.0),
                                                                        height: 44,
                                                                        decoration: BoxDecoration(
                                                                          shape: BoxShape.rectangle,
                                                                          color: Mytheme.colorTextDivider,
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.all(10),
                                                                          child: Align(
                                                                            alignment: Alignment.centerLeft,
                                                                            child: Text(
                                                                              dataUsers[i].key ?? "",
                                                                              textAlign: TextAlign.left,
                                                                              style: const TextStyle(
                                                                                fontSize: 16,
                                                                                color: Mytheme.colorTextSubTitle,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily:
                                                                                "OpenSans-Regular",
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),

                                                                      ),),
                                                                    Expanded(child: Container(
                                                                      height: 44,
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.rectangle,
                                                                        color: Mytheme.colorTextDivider,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: Text(
                                                                            formatter.format(int.parse(dataUsers[i].value ?? "0")),
                                                                            textAlign: TextAlign.left,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Mytheme.colorTextSubTitle,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily:
                                                                              "OpenSans-Regular",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ),)
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ],

                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 10),
                                                            child: InkWell(
                                                              onTap: () async {
                                                                showDialogAddItemTool();
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(right: 10),
                                                                    child: SvgPicture.asset("assets/svg/ic_add_blue.svg"),
                                                                  ),
                                                                  Text(
                                                                    "Thêm thu nhập khác",
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontFamily: "OpenSans-Regular",
                                                                        fontWeight: FontWeight.bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                              padding: const EdgeInsets.only(
                                                                  top: 20),
                                                              child: Container(
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
                                                                        "Tổng thu nhập",
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
                                                                        calculatorTotalType1(),
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
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        top: 10, left: 16, right: 16),
                                                    child: Column(
                                                      children:   [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            "Hãy nhập các chi phí của bạn. Bạn có thể điều chỉnh các chi phí này nếu cần",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Mytheme.color_82869E,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily:
                                                              "OpenSans-Regular",
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text(
                                                            "Đơn vị: VND",
                                                            textAlign: TextAlign.left,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Mytheme.color_82869E,
                                                              fontWeight: FontWeight.w400,
                                                              fontFamily:
                                                              "OpenSans-Regular",
                                                            ),
                                                          ),
                                                        ),

                                                        for(var i=0; i< dataUsers.length; i++) ... [
                                                          if(dataUsers[i].type == 2)...[
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 10),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () async {
                                                                      setState(() {
                                                                        dataUsers.removeAt(i);
                                                                      });
                                                                    },
                                                                    child: Row(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 10),
                                                                          child: SvgPicture.asset("assets/svg/ic_delete.svg"),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:2,
                                                                    child: Container(
                                                                      margin: const EdgeInsets.only(right: 10.0),
                                                                      height: 44,
                                                                      decoration: BoxDecoration(
                                                                        shape: BoxShape.rectangle,
                                                                        color: Mytheme.colorTextDivider,
                                                                        borderRadius: BorderRadius.circular(8),
                                                                      ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(10),
                                                                        child: Align(
                                                                          alignment: Alignment.centerLeft,
                                                                          child: Text(
                                                                            dataUsers[i].key ?? "",
                                                                            textAlign: TextAlign.left,
                                                                            style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: Mytheme.colorTextSubTitle,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily:
                                                                              "OpenSans-Regular",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                    ),),
                                                                  Expanded(child: Container(
                                                                    height: 44,
                                                                    decoration: BoxDecoration(
                                                                      shape: BoxShape.rectangle,
                                                                      color: Mytheme.colorTextDivider,
                                                                      borderRadius: BorderRadius.circular(8),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(10),
                                                                      child: Align(
                                                                        alignment: Alignment.centerRight,
                                                                        child: Text(
                                                                          formatter.format(int.parse(dataUsers[i].value ?? "0")),
                                                                          textAlign: TextAlign.left,
                                                                          style: const TextStyle(
                                                                            fontSize: 16,
                                                                            color: Mytheme.colorTextSubTitle,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontFamily:
                                                                            "OpenSans-Regular",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                  ),)
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ],

                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showDialogAddItemTool();
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.only(right: 10),
                                                                  child: SvgPicture.asset("assets/svg/ic_add_blue.svg"),
                                                                ),
                                                                Text(
                                                                  "Thêm chi phí khác",
                                                                  style: TextStyle(
                                                                      fontSize: 16,
                                                                      fontFamily: "OpenSans-Regular",
                                                                      fontWeight: FontWeight.bold),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: const EdgeInsets.only(
                                                                top: 20),
                                                            child: Container(
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
                                                                      "Tổng chi phí",
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
                                                                      calculatorTotalType2(),
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
                                                            )
                                                        )

                                                      ],
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
                            ],
                          ),
                        ),
                      ),

                      Visibility(
                        visible: showBudget,
                        child:  Padding(
                              padding: const EdgeInsets.only(top: 40, left: 24, right: 24 ),
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
                                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16 ),
                                  child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Tổng thu nhập",
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
                                            child:  Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                totalThuNhap(),
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
                                            child:  Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Tổng chi tiêu",
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
                                            child:  Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                totalChiPhi(),
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
                                        thickness: 1,
                                        color: Mytheme.color_BCBFD6,
                                      ),
                                      const SizedBox(
                                        height: 12,
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

                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          calculatorTotal(),
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
                                        height: 16,
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
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: SvgPicture.asset("assets/svg/ic_infomation.svg"),
                                                ),
                                                Expanded(child: Text(
                                                  "Bạn có thể sử dụng số tiền này cho các khoản chi tiêu ngoài dự kiến hoặc tiết kiệm cho tương lai.",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: "OpenSans-Regular",
                                                      fontWeight: FontWeight.w400),
                                                )),

                                              ],
                                            ),
                                          )

                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  ),
                                ),

                              )
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
                  padding:
                  const EdgeInsets.only(top: 10, bottom: 20, left: 24, right: 24),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          // side: const BorderSide(color: Colors.red)
                        ),
                        primary: Mytheme.colorBgButtonLogin,
                        minimumSize:
                        Size(MediaQuery.of(context).size.width, 44)),
                    child:  Text(
                      showCalculator == true ? "Tính toán" : "Lưu",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "OpenSans-Regular",
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      setState(() {
                        if(showCalculator) {
                          showCalculator = false;
                          showBudget = true;
                        } else {
                          StoreDataTool storeDataTool = StoreDataTool();
                          storeDataTool.title = _nameBudgetController.text;
                          storeDataTool.toolId = data.id;
                          storeDataTool.type = 1;
                          storeDataTool.dataUsers = dataUsers;
                          print(jsonEncode(storeDataTool));
                          saveItemTool(jsonEncode(storeDataTool));
                        }
                      });
                      // StoreDataTool storeDataTool = StoreDataTool();
                      // storeDataTool.title = _nameBudgetController.text;
                      // storeDataTool.toolId = data.id;
                      // storeDataTool.dataUsers = dataUsers;
                      // print(jsonEncode(storeDataTool));
                      // Get.offAndToNamed("/calculatorBudgetScreen", arguments: storeDataTool);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String calculatorTotalType1() {
    int total = 0;
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 1) {
        total = total + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(total.toString())} VNĐ";
  }

  String calculatorTotalType2() {
    int total = 0;
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 2) {
        total = total + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(total.toString())} VNĐ";
  }


  showDialogEditItemTool(DataUsers dataUser) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Dialog(
                insetPadding: EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.padding),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: contentBox(context),
              ),
          );
        }
    );

  }

  showDialogAddItemTool() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Dialog(
              insetPadding: EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.padding),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: contentBox(context),
            ),
          );
        }
    );

  }

  contentBox(context) {

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: 0,
              right: 0,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // boxShadow:  [
            //   BoxShadow(
            //       color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            // ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.only(top: 30, left: 10, bottom: 8, right: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _thuNhapController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Thu nhập',
                      ),
                      onChanged: (value) {

                      },
                    ),
                    SizedBox(
                      height: 34,
                    ),
                    TextField(
                      controller: _soTienController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Số tiền',
                      ),
                      onChanged: (value) {
                        value = '${formNum(
                          value.replaceAll(',', ''),
                        )}';
                        _soTienController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(
                            offset: value.length,
                          ),
                        );
                      },
                    )
                  ],
                ),

              ),

              SizedBox(
                height: 34,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, "");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 44,
                      width: 135,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Mytheme.colorBgButtonLogin)
                      ),
                      child: const Text(
                        "Hủy",
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.color_434657,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var thunhap = _thuNhapController.text;
                      var sotien = _soTienController.text.replaceAll(',', '');
                      setState(() {
                        dataUsers.add(DataUsers(
                          key: thunhap,
                          value: sotien,
                          type: typeObj
                        ));
                      });
                      _thuNhapController.clear();
                      _soTienController.clear();
                      print(thunhap);
                      Navigator.pop(context, "");
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(10),
                      height: 44,
                      width: 135,
                      decoration: BoxDecoration(
                        color: Mytheme.colorBgButtonLogin,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Thêm",
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.kBackgroundColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  String totalThuNhap() {
    totalType1 = 0;
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 1) {
        totalType1 = totalType1 + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(totalType1.toString())} VNĐ";
  }

  String totalChiPhi() {
    totalType2 = 0;
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 2) {
        totalType2 = totalType2 + int.parse(dataUsers[i].value??"0");
      }
    }
    return "${formNum(totalType2.toString())} VNĐ";
  }

  String calculatorTotal() {
    return "${formNum((totalType1 - totalType2).toString())} VNĐ";
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
