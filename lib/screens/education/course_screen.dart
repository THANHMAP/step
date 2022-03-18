import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/models/course_detail_model.dart';
import 'package:step_bank/models/faq_model.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/dialog_nomal.dart';
import '../../compoment/textfield_widget.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late ProgressDialog pr;
  List<InfoList> infoList = [];

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Future.delayed(Duration.zero, () {
      loadListEducation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Mytheme.kBackgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    AppbarWidget(
                      text: "Các khái niệm kinh doanh cơ bản",
                      onClicked: () => Get.back(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 24, right: 24),
                          child: Column(
                            children: [
                              for (var i = 0; i < infoList.length; i++) ...[
                                layoutTest(i, infoList[i])
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  layoutFAQ(int index, InfoList faqData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
      child: InkWell(
        onTap: () {},
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    faqData.collapsed = !faqData.collapsed!;
                  });
                },
                animationDuration: Duration(milliseconds: 200),
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: Text(
                          faqData.title.toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    },
                    body: ListTile(
                      title: Text(faqData.description.toString(),
                          style: TextStyle(color: Colors.black)),
                    ),
                    isExpanded: faqData.collapsed ?? false,
                    canTapOnHeader: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  layoutTest(int index, InfoList faqData) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 8, right: 8, bottom: 16),
      child: InkWell(
        onTap: () {},
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
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    faqData.collapsed = !faqData.collapsed!;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: faqData.collapsed == false
                        ? Colors.white
                        : Mytheme.color_0xFFCCECFB,
                    // borderRadius: BorderRadius.circular(8),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, left: 16, bottom: 18, right: 0),
                          child: Text(
                            faqData.title.toString(),
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
                            icon:
                                Image.asset("assets/images/ic_arrow_down.png"),
                            // tooltip: 'Increase volume by 10',
                            iconSize: 50,
                            onPressed: () {
                              setState(() {
                                faqData.collapsed = !faqData.collapsed!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Visibility(
                  visible: faqData.collapsed ?? false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 12, left: 16, bottom: 18, right: 16),
                    child: Text(
                      faqData.description.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Mytheme.colorBgButtonLogin,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    ),
                  ))

              // Expanded(
              //   flex: 1,
              //   child: Text(
              //     faqData.description.toString(),
              //     textAlign: TextAlign.start,
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Mytheme.colorBgButtonLogin,
              //       fontWeight: FontWeight.w400,
              //       fontFamily: "OpenSans-Regular",
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadListEducation() async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'type': '1',
    });
    APIManager.postAPICallNeedToken(RemoteServices.listCourseURL, param).then(
        (value) async {
      await pr.hide();
      var data = CourseDetailModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          infoList = data.data![0].infoList!;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
