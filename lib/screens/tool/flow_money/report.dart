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
import '../../../models/report/month_chart.dart';
import '../../../models/report/report_chart.dart';
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class ReportFlowMoneyScreen extends StatefulWidget {
  const ReportFlowMoneyScreen({Key? key}) : super(key: key);

  @override
  _ReportFlowMoneyScreenState createState() => _ReportFlowMoneyScreenState();
}

class _ReportFlowMoneyScreenState extends State<ReportFlowMoneyScreen>
    with SingleTickerProviderStateMixin {
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  bool selectDefault = true;
  List<String> _listRepaymentCycle = [
    "Tháng 1",
    "Tháng 2",
    "Tháng 3",
    "Tháng 4",
    "Tháng 5",
    "Tháng 6",
    "Tháng 7",
    "Tháng 8",
    "Tháng 9",
    "Tháng 10",
    "Tháng 11",
    "Tháng 12"
  ];

  List<String> _listYeah = [
    "Năm 2000",
    "Năm 2001",
    "Năm 2002",
    "Năm 2003",
    "Năm 2004",
    "Năm 2005",
    "Năm 2006",
    "Năm 2007",
    "Năm 2008",
    "Năm 2009",
    "Năm 2010",
    "Năm 2011",
    "Năm 2012",
    "Năm 2013",
    "Năm 2014",
    "Năm 2015",
    "Năm 2016",
    "Năm 2017",
    "Năm 2018",
    "Năm 2019",
    "Năm 2020",
    "Năm 2021",
    "Năm 2022",
    "Năm 2023",
    "Năm 2024",
    "Năm 2025",
  ];

  int currentYear = 0;
  int currentRepaymentCycleIndex = 0;
  List<ReportChartData> reportData = [];
  List<MonthChartData> monthdata = [];
  String idUserTool = "";
  bool? animate;

  @override
  void initState() {
    super.initState();
    idUserTool = Get.arguments;
    var month = DateTime.now().month;
    setState(() {
      currentRepaymentCycleIndex = month - 1;
    });
    var year = DateTime.now().year;
    for(int i = 0; i < _listYeah.length; i++) {
      if(_listYeah[i].contains(year.toString())) {
        currentYear = i;
      }
    }

    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    Future.delayed(Duration.zero, () {
      loadDataDraw(
          idUserTool,
          month.toString(),
          DateTime.now().year.toString());
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
                                  "Tháng",
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
                                if(monthdata.isEmpty) {
                                  loadDataDrawMonth(
                                      idUserTool,
                                      "",
                                      DateTime.now().year.toString());
                                }
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Năm",
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
                              month(),
                              loadChart(),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Constants.selectDefault = true;
                                  loadDetailDataDraw(idUserTool, (currentRepaymentCycleIndex + 1).toString(), DateTime.now().year.toString());
                                },
                                child: Image.asset("assets/images/img_tienvao.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Constants.selectDefault = false;
                                  loadDetailDataDraw(idUserTool, (currentRepaymentCycleIndex + 1).toString(), DateTime.now().year.toString());
                                },
                                child: Image.asset("assets/images/img_tienra.png"),
                              ),

                            ],
                          ),
                        ),
                      ),

                      //nam
                      Visibility(
                        visible: !selectDefault ? true : false,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 30, top: 10, left: 16, right: 16),
                          child: Column(
                            children: [
                              yeah(),
                              loadChartYear(),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Constants.selectDefault = true;
                                  loadDetailDataDraw(idUserTool, (currentRepaymentCycleIndex + 1).toString(), DateTime.now().year.toString());
                                },
                                child: Image.asset("assets/images/img_tienvao.png"),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Constants.selectDefault = false;
                                  loadDetailDataDraw(idUserTool, (currentRepaymentCycleIndex + 1).toString(), DateTime.now().year.toString());
                                },
                                child: Image.asset("assets/images/img_tienra.png"),
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
          ],
        ),
      ),
    );
  }

  month() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
      child: InkWell(
        onTap: () {
          _monthModalBottomSheet(context);
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
                    getNameMonth(currentRepaymentCycleIndex),
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
                      _monthModalBottomSheet(context);
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

  yeah() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
      child: InkWell(
        onTap: () {
          _yeahModalBottomSheet(context);
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
                    getNameYeah(currentYear),
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
                      _yeahModalBottomSheet(context);
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

  loadChart() {
    if(reportData.isNotEmpty) {
      List<charts.Series<ReportChartData, String>> _createSampleData() {
        return [
          charts.Series<ReportChartData, String>(
            id: 'TienVao',
            domainFn: (ReportChartData sales, _) =>
            "${sales.startDate}\n-${sales.endDate}",
            measureFn: (ReportChartData sales, _) => sales.totalDeposit,
            data: reportData!,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault,
          ),
          charts.Series<ReportChartData, String>(
            id: 'TienRa',
            measureFn: (ReportChartData sales, _) => -sales.totalWithDraw!,
            data: reportData!,
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (ReportChartData sales, _) =>
            "${sales.startDate}\n-${sales.endDate}",
          ),
        ];
      }
      return Container(
        height: 400,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: charts.BarChart(_createSampleData(), animate: true, defaultRenderer: new charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 1.0),),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  loadChartYear() {
    if(monthdata.isNotEmpty) {
      List<charts.Series<MonthChartData, String>> _createSampleData() {
        return [
          charts.Series<MonthChartData, String>(
            id: 'TienVao',
            domainFn: (MonthChartData sales, _) => "${sales.month}",
            measureFn: (MonthChartData sales, _) => sales.totalDeposit,
            data: monthdata!,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            fillColorFn: (_, __) =>
            charts.MaterialPalette.blue.shadeDefault,
          ),
          charts.Series<MonthChartData, String>(
            id: 'TienRa',
            measureFn: (MonthChartData sales, _) => -sales.totalWithDraw!,
            data: monthdata!,
            colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
            domainFn: (MonthChartData sales, _) => "${sales.month}",
          ),
        ];
      }
      return Container(
        height: 400,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: charts.BarChart(_createSampleData(), animate: true, defaultRenderer: new charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.stacked, strokeWidthPx: 1.0),),
                )
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  void _monthModalBottomSheet(context) {
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
                              "Chọn tháng",
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
                                    Navigator.of(context).pop();
                                    loadDataDraw(
                                        idUserTool,
                                        (currentRepaymentCycleIndex + 1)
                                            .toString(),
                                        "2022");
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

  void _yeahModalBottomSheet(context) {
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
                              "Chọn năm",
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
                            i < _listYeah.length;
                            i++) ...[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    currentYear = i;
                                    Navigator.of(context).pop();
                                    loadDataDrawMonth(
                                        idUserTool,
                                        "",
                                        _listYeah[i].replaceAll("Năm ", ""));
                                    this.setState(() {
                                      // user.gender = currentSexIndex;
                                    });
                                  });
                                },
                                child: Container(
                                  height: 60,
                                  color: currentYear == i
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
                                          _listYeah[i],
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
                                        visible: currentYear == i
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

  String getNameMonth(int index) {
    return _listRepaymentCycle[index];
  }

  String getNameYeah(int index) {
    return _listYeah[index];
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future<void> loadDetailDataDraw(String idUser, String month, String year) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': idUser,
      'month': month,
      'year': year,
    });
    APIManager.postAPICallNeedToken(RemoteServices.reportDetailDataDrawToolURL, param)
        .then((value) async {
      pr.hide();
      var data = DetailReportModel.fromJson(value);
      if (data.statusCode == 200) {
        if(data.data!.isNotEmpty) {
          Get.toNamed("/detailReportFlowMoneyScreen", arguments: data.data);
        }
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadDataDraw(String idUser, String month, String year) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': idUser,
      'month': month,
      'year': year,
    });
    APIManager.postAPICallNeedToken(RemoteServices.reportDataDrawToolURL, param)
        .then((value) async {
      pr.hide();
      var data = ReportChartModel.fromJson(value);
      if (data.statusCode == 200) {
          setState(() {
            reportData = data.data!;
          });
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadDataDrawMonth(String idUser, String month, String year) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': idUser,
      'month': month,
      'year': year,
    });
    APIManager.postAPICallNeedToken(RemoteServices.reportDataDrawToolURL, param)
        .then((value) async {
      pr.hide();
      var data = MonthChartModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          monthdata = data.data!;
        });
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
