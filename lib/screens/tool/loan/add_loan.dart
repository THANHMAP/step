import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class AddLoanScreen extends StatefulWidget {
  const AddLoanScreen({Key? key}) : super(key: key);

  @override
  _AddLoanScreenState createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _nameLoanController = TextEditingController();
  TextEditingController _danhMucController = TextEditingController();
  late ProgressDialog pr;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Người đi vay'),
    Tab(text: 'Người đồng trả nợ'),
  ];
  late TabController _tabController;
  List<DataUsers> dataUsers = [];
  int typeObj = 1;
  late ToolData data;
  bool updateButton = false;

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
      loadDataSampleTool();
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
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .singleLineFormatter
                                        ],
                                        textInputAction: TextInputAction.done,
                                        obscureText: false,
                                        hintText: "Viết tên của khoản vay này",
                                        // labelText: "Phone number",
                                        // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                        suffixIcon: Icons.close,
                                        clickSuffixIcon: () =>
                                            _nameLoanController.clear(),
                                        textController: _nameLoanController),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 30,
                                                            top: 10,
                                                            left: 16,
                                                            right: 16),
                                                    child: Column(
                                                      children: [
                                                        for (var i = 0;
                                                            i <
                                                                dataUsers
                                                                    .length;
                                                            i++) ...[
                                                          if (dataUsers[i]
                                                                  .type ==
                                                              1) ...[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 12,
                                                                      bottom:
                                                                          12,
                                                                      left: 12,
                                                                      right:
                                                                          12),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 10),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (dataUsers[i].value == "0") {
                                                                                dataUsers[i].value = "1";
                                                                              } else {
                                                                                dataUsers[i].value = "0";
                                                                              }
                                                                            });
                                                                          },
                                                                          child: SvgPicture.asset(dataUsers[i].value == "0"
                                                                              ? "assets/svg/ic_checkbox_loan.svg"
                                                                              : "assets/svg/ic_checkbox_loan_select.svg"),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Text(
                                                                          dataUsers[i].key ??
                                                                              "",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontFamily: "OpenSans-Regular",
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  showDialogConfig(i);
                                                                                });
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: SvgPicture.asset("assets/svg/ic_remove.svg"),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                showDialogAddItemTool(dataUsers[i].key ?? "", i);
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: SvgPicture.asset("assets/svg/ic_pen.svg"),
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
                                                          ],
                                                        ],
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showDialogAddItemTool("", 0);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/svg/ic_add_blue.svg"),
                                                                ),
                                                                Text(
                                                                  "Thêm danh mục",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "OpenSans-Regular",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            left: 16,
                                                            right: 16,
                                                            bottom: 22),
                                                    child: Column(
                                                      children: [
                                                        for (var i = 0;
                                                            i <
                                                                dataUsers
                                                                    .length;
                                                            i++) ...[
                                                          if (dataUsers[i]
                                                                  .type ==
                                                              2) ...[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 12,
                                                                      bottom:
                                                                          12),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.5),
                                                                      spreadRadius:
                                                                          1,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: const Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 12,
                                                                      bottom:
                                                                          12,
                                                                      left: 12,
                                                                      right:
                                                                          12),
                                                                  child: Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 10),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (dataUsers[i].value == "0") {
                                                                                dataUsers[i].value = "1";
                                                                              } else {
                                                                                dataUsers[i].value = "0";
                                                                              }
                                                                            });
                                                                          },
                                                                          child: SvgPicture.asset(dataUsers[i].value == "0"
                                                                              ? "assets/svg/ic_checkbox_loan.svg"
                                                                              : "assets/svg/ic_checkbox_loan_select.svg"),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Text(
                                                                          dataUsers[i].key ??
                                                                              "",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              fontFamily: "OpenSans-Regular",
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            InkWell(
                                                                              onTap: () {
                                                                                showDialogConfig(i);
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: SvgPicture.asset("assets/svg/ic_remove.svg"),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 30,
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                showDialogAddItemTool(dataUsers[i].key ?? "", i);
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: SvgPicture.asset("assets/svg/ic_pen.svg"),
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
                                                          ],
                                                        ],
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10),
                                                          child: InkWell(
                                                            onTap: () async {
                                                              showDialogAddItemTool("", 0);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          10),
                                                                  child: SvgPicture
                                                                      .asset(
                                                                          "assets/svg/ic_add_blue.svg"),
                                                                ),
                                                                Text(
                                                                  "Thêm danh mục",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          "OpenSans-Regular",
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
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
                          StoreDataTool storeDataTool = StoreDataTool();
                          storeDataTool.title = _nameLoanController.text;
                          storeDataTool.toolId = data.id;
                          storeDataTool.type = 1;
                          storeDataTool.dataUsers = dataUsers;
                          print(jsonEncode(storeDataTool));
                          saveItemTool(jsonEncode(storeDataTool));
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }


  showDialogAddItemTool(String text, int position) async {
    if(text.isNotEmpty) {
      _danhMucController.text = text;
      setState(() {
        updateButton = true;
      });

    } else {
      _danhMucController.text = "";
      setState(() {
        updateButton = false;
      });
    }
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
              child: contentBox(context, position),
            ),
          );
        });
  }

  contentBox(context, int position) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0, right: 0, bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
                      controller: _danhMucController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Danh mục',
                      ),
                      onChanged: (value) {},
                    ),
                    SizedBox(
                      height: 24,
                    ),
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
                          border:
                              Border.all(color: Mytheme.colorBgButtonLogin)),
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
                      var thunhap = _danhMucController.text;
                      if(thunhap.isNotEmpty) {
                        if(updateButton) {
                          setState(() {
                            dataUsers[position].key = thunhap;
                          });
                          _danhMucController.clear();
                        } else {
                          setState(() {
                            dataUsers.add(DataUsers(
                                key: thunhap,
                                value: "0",
                                type: typeObj
                            ));
                          });
                        }
                      }
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
                      child:  Text(
                        updateButton == true ? "Cập nhật" : "Thêm",
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

  Future<void> loadDataSampleTool() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'tool_id': data.id.toString(),
    });
    APIManager.postAPICallNeedToken(RemoteServices.sampleDataURL, param).then(
        (value) async {
      pr.hide();
      var data = DataSampleTool.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          for (var i = 0; i < data.data!.length; i++) {
            dataUsers.add(DataUsers(
                key: data.data![i].name, value: "0", type: data.data![i].type));
          }
        });
      }
    }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
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

  showDialogConfig(int position) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: ConfirmDialogBoxWithIcon(
                title: "Bạn chắc chắn muốn xoá?",
                textButtonLeft: "Huỷ",
                textButtonRight: "Tiếp tục",
                onClickedConfirm: ()  {
                  setState(() {
                    dataUsers.removeAt(position);
                  });
                  Navigator.pop(context, "");
                },
                onClickedCancel: () {
                  Navigator.pop(context, "");
                },
              ));
        });
  }

}
