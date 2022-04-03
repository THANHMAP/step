import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../../compoment/card_education.dart';
import '../../../compoment/card_item_tool.dart';
import '../../../compoment/card_setting.dart';
import '../../../compoment/confirm_dialog_icon.dart';
import '../../../models/tool/item_tool.dart';
import '../../../themes.dart';
import '../../../util.dart';

class ToolBudgetScreen extends StatefulWidget {
  const ToolBudgetScreen({Key? key}) : super(key: key);

  @override
  _ToolBudgetScreenState createState() => _ToolBudgetScreenState();
}

class _ToolBudgetScreenState extends State<ToolBudgetScreen> with WidgetsBindingObserver  {
  late ProgressDialog pr;
  ToolData? data;
  List<ItemToolData> _listItemToolData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    data = Get.arguments;
    Constants.toolData = data;
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadListItemTool();
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Mytheme.colorBgMain,
        body: Column(
          children: <Widget>[
            AppbarWidget(
              text: data?.name,
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: 70),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      headerLayout(),
                      Padding(
                        padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 16, right: 16, bottom: 0),
                              child: Column(
                                children: [
                                  layoutCourse(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // layoutCourse(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  layoutCourse() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 0, right: 0),
      child: Column(
        children: [
          if (_listItemToolData.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 16, right: 16, bottom: 0),
              child: Column(
                children: [
                  for (var i = 0; i < _listItemToolData.length; i++) ...[
                    const SizedBox(height: 15),
                    CardItemToolWidget(
                      title: _listItemToolData[i].name,
                      date: _listItemToolData[i].createdAt,
                      onClickedDelete: () {
                        showDialogConfig(_listItemToolData[i].id ?? 0, i);
                        // deleteItemTool(_listItemToolData[i].id ?? 0, i);
                      },
                      onClickedView: () {
                        Get.toNamed("/editBudgetScreen", arguments: _listItemToolData[i].id);
                      },
                    ),
                  ]
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  headerLayout() {
    return Stack(
      children: <Widget>[
        Container(
          height: 206,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_home.png"),
              fit: BoxFit.cover,
            ),
          ),
          // child: Column(
          //   children: const <Widget>[],
          // ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 56, left: 16, right: 0),
          child: Container(
            width: 216,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    data?.name ?? "",
                    style: TextStyle(
                      fontSize: 23,
                      color: Mytheme.colorBgButtonLogin,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans-Bold",
                      // decoration: TextDecoration.underline,
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 116, left: 16, right: 0),
          child: SizedBox(
            width: 200,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    // side: const BorderSide(color: Colors.red)
                  ),
                  primary: Mytheme.colorBgButtonLogin,
                  minimumSize: const Size(44, 44)),
              child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset("assets/svg/ic_add.svg"),
                  ),

                  Text(
                    "Lập ngân sách mới",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "OpenSans-Regular",
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailBudgetScreen(),
                  ),
                ).then((value) {
                  print(value);
                  if(value) {
                    loadListItemTool();
                  }
                  // _reload();
                });
                // Get.toNamed("/detailBudgetScreen", arguments: data);
              },
            ),
          ),
        ),

        Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.only(top: 56, right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Image.network(
                  data?.thumbnail ??"",
                  width: 130,
                ),
              )
          ),
        )


      ],
    );
  }

  Future<void> loadListItemTool() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'tool_id': data?.id.toString() ?? "",
    });
    APIManager.postAPICallNeedToken(RemoteServices.listItemToolURL, param).then(
            (value) async {
          pr.hide();
          var data = ItemTool.fromJson(value);
          if (data.statusCode == 200) {
            setState(() {
              _listItemToolData = data.data!;
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> deleteItemTool(int id, int position) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': id.toString() ?? "",
    });
    APIManager.postAPICallNeedToken(RemoteServices.deleteItemToolURL, param).then(
            (value) async {
          pr.hide();
          if (value['status_code'] == 200) {
            setState(() {
              _listItemToolData.removeAt(position);
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  showDialogConfig(int id, int position) {
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
                  Navigator.pop(context, "");
                  deleteItemTool(id, position);
                },
                onClickedCancel: () {
                  Navigator.pop(context, "");
                },
              ));
        });
  }

}
