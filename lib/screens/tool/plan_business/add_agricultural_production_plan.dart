import 'dart:convert';

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
import '../../../models/tool/data_sample.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class AddAgriculturalProductionPlanToolScreen extends StatefulWidget {
  const AddAgriculturalProductionPlanToolScreen({Key? key}) : super(key: key);

  @override
  _AddAgriculturalProductionPlanToolScreenState createState() =>
      _AddAgriculturalProductionPlanToolScreenState();
}

class _AddAgriculturalProductionPlanToolScreenState
    extends State<AddAgriculturalProductionPlanToolScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _namePlantBusinessController = TextEditingController();
  TextEditingController _whoAreYouController = TextEditingController();
  TextEditingController _trongCayNuoiConGiController = TextEditingController();

  TextEditingController _nhaCungCapDichVuController = TextEditingController();
  TextEditingController _nguonNhanCongController = TextEditingController();

  TextEditingController _banChoAiController = TextEditingController();
  TextEditingController _banNhuTheNaoController = TextEditingController();

  TextEditingController _thuNhapController = TextEditingController();
  TextEditingController _soTienController = TextEditingController();
  TextEditingController _editMoneyController = TextEditingController();

  var formatter = NumberFormat('#,##,000');
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  ScrollController scrollController = ScrollController();
  int indexPlan = 0;
  String imgHeader = "assets/svg/img_plan_agricultural_1.svg";
  bool selectDefault = true;
  int typeObj = 2;
  late ToolData data;

  @override
  void initState() {
    super.initState();
    data = Constants.toolData!;
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      // if(scrollController.offset > showoffset){
      //   showbtn = true;
      //   setState(() {
      //     //update state
      //   });
      // }else{
      //   showbtn = false;
      //   setState(() {
      //     //update state
      //   });
      // }
    });
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();

    Future.delayed(Duration.zero, () {
      loadDataSampleTool();
    });
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
          resizeToAvoidBottomInset: true,
          backgroundColor: Mytheme.colorBgMain,
          body: Column(
            children: <Widget>[
              AppbarWidget(
                text: "Kế hoạch sản xuất nông nghiệp",
                onClicked: () {
                  Navigator.of(context).pop(false);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 0, right: 0),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      imgHeader,
                                      width: 450,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 16,
                                          right: 16,
                                          bottom: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Visibility(
                                            visible:
                                                indexPlan == 0 ? true : false,
                                            child: layouIndex1(),
                                          ),
                                          Visibility(
                                            visible:
                                                indexPlan == 1 ? true : false,
                                            child: layouIndex2(),
                                          ),
                                          Visibility(
                                            visible:
                                                indexPlan == 2 ? true : false,
                                            child: layouIndex3(),
                                          ),
                                          Visibility(
                                            visible:
                                                indexPlan == 3 ? true : false,
                                            child: layouIndex4(),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 60),
                                            child: Column(
                                              children: [
                                                Visibility(
                                                  visible: indexPlan == 0
                                                      ? false
                                                      : true,
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        indexPlan =
                                                            indexPlan - 1;
                                                        imgHeader =
                                                            "assets/svg/img_plan_business_${indexPlan + 1}.svg";
                                                      });
                                                    },
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                                color: Mytheme
                                                                    .colorBgButtonLogin)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10,
                                                                  bottom: 10,
                                                                  left: 0,
                                                                  right: 0),
                                                          child: Text(
                                                            "Quay lại",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Mytheme
                                                                  .color_434657,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  "OpenSans-Semibold",
                                                            ),
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            // side: const BorderSide(color: Colors.red)
                                                          ),
                                                          primary: Mytheme
                                                              .colorBgButtonLogin,
                                                          minimumSize: Size(
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width,
                                                              44)),
                                                  child: Text(
                                                    indexPlan == 3
                                                        ? "Lưu"
                                                        : "Tiếp tục",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontFamily:
                                                            "OpenSans-Regular",
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  onPressed: () {
                                                    if (indexPlan < 3) {
                                                      if (_namePlantBusinessController
                                                          .text.isEmpty) {
                                                        Utils.showError(
                                                            "Bạn chưa nhập tên cho kế hoạch",
                                                            context);
                                                        return;
                                                      }
                                                      setState(() {
                                                        indexPlan =
                                                            indexPlan + 1;
                                                        imgHeader =
                                                            "assets/svg/img_plan_agricultural_${indexPlan + 1}.svg";
                                                      });
                                                      scrollController
                                                          .animateTo(
                                                              //go to top of scroll
                                                              0,
                                                              //scroll offset to go
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              //duration of scroll
                                                              curve: Curves
                                                                  .fastOutSlowIn //scroll type
                                                              );
                                                    } else {
                                                      if (_namePlantBusinessController
                                                          .text.isEmpty) {
                                                        Utils.showError(
                                                            "Bạn chưa nhập tên cho kế hoạch",
                                                            context);
                                                      } else {
                                                        StoreDataTool
                                                            storeDataTool =
                                                            StoreDataTool();
                                                        storeDataTool.title =
                                                            _namePlantBusinessController
                                                                .text;
                                                        storeDataTool.toolId =
                                                            data.id;
                                                        storeDataTool.type =
                                                            2; // 2 plan business

                                                        //bạn là ai
                                                        dataUsers.add(DataUsers(
                                                          key: "ban_la_ai",
                                                          value:
                                                              _whoAreYouController
                                                                  .text,
                                                          type: 0,
                                                        ));

                                                        //trong cay nuoi con gi
                                                        dataUsers.add(DataUsers(
                                                          key:
                                                              "trong_cay_nuoi_gi",
                                                          value:
                                                              _trongCayNuoiConGiController
                                                                  .text,
                                                          type: 0,
                                                        ));

                                                        //nha cung cap dich vu
                                                        dataUsers.add(DataUsers(
                                                          key:
                                                              "nha_cung_cap_dich_vu",
                                                          value:
                                                              _nhaCungCapDichVuController
                                                                  .text,
                                                          type: 0,
                                                        ));

                                                        //nguon nhan cong
                                                        dataUsers.add(DataUsers(
                                                          key:
                                                              "nguon_nhan_cong",
                                                          value:
                                                              _nguonNhanCongController
                                                                  .text,
                                                          type: 0,
                                                        ));

                                                        //ban cho ai
                                                        dataUsers.add(DataUsers(
                                                          key: "ban_cho_ai",
                                                          value:
                                                              _banChoAiController
                                                                  .text,
                                                          type: 0,
                                                        ));

                                                        //ban nhu the nào
                                                        dataUsers.add(DataUsers(
                                                          key:
                                                              "ban_nhu_the_nao",
                                                          value:
                                                              _banNhuTheNaoController
                                                                  .text,
                                                          type: 0,
                                                        ));
                                                        storeDataTool
                                                                .dataUsers =
                                                            dataUsers;
                                                        saveItemTool(jsonEncode(
                                                            storeDataTool));
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //
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
            ],
          ),
        ),
      ),
    );
  }

  layouIndex1() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Tên hoạt động sản xuất nông nghiệp",
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
                FilteringTextInputFormatter.singleLineFormatter
              ],
              textInputAction: TextInputAction.done,
              obscureText: false,
              hintText: "Tên hoạt động sản xuất kinh doanh",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _namePlantBusinessController.clear(),
              textController: _namePlantBusinessController),
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bạn là ai?",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Mô tả về bạn",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _whoAreYouController.clear(),
              textController: _whoAreYouController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: SvgPicture.asset("assets/svg/diem_manh.svg", height: 100, fit: BoxFit.fill)
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bạn trồng cây/nuôi con gì",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Sản phẩm dự kiến sản xuất của bạn là",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _trongCayNuoiConGiController.clear(),
              textController: _trongCayNuoiConGiController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/nuoi_con_gi.svg", height: 80, fit: BoxFit.fill)
        ),
      ],
    );
  }

  layouIndex2() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Những nhà cung cấp dịch  vụ của bạn?",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Nhà cung cấp dịch vụ của bạn là",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _nhaCungCapDichVuController.clear(),
              textController: _nhaCungCapDichVuController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/nhung_nha_cung_cap.svg", height: 130, fit: BoxFit.fill)
        ),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Nguồn nhân công",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Nguồn nhân công của bạn",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _nguonNhanCongController.clear(),
              textController: _nguonNhanCongController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/nguon_nhan_cong.svg", height: 40, fit: BoxFit.fill)
        ),
      ],
    );
  }

  layouIndex3() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bạn bán hàng đi đâu và cho ai",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Khách hàng và địa điểm của bạn",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _banChoAiController.clear(),
              textController: _banChoAiController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/ban_cho_ai_va_di_dau.svg", height: 60, fit: BoxFit.fill)
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bán hàng như thế nào",
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
          height: 5 * 24.0,
          child: TextFieldWidget(
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Cách thức bán hàng",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () => _banNhuTheNaoController.clear(),
              textController: _banNhuTheNaoController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/ban_hang_nhu_the_nao.svg", height: 60, fit: BoxFit.fill)
        ),
      ],
    );
  }

  layouIndex4() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    selectDefault = true;
                    typeObj = 2;
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Chi phí ban đầu",
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
                    typeObj = 1;
                  });
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Thu nhập",
                    textAlign: TextAlign.left,
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

        // type thu nhap
        Visibility(
          visible: !selectDefault ? true : false,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 16, right: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Xác định các nguồn thu hoạt động sản xuất kinh doanh. Bạn có thể tham khảo các loại thu nhập được ví dụ ở đây và điều chỉnh cho phù hợp với hoạt động sản xuất kinh doanh của mình",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
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
                      fontFamily: "OpenSans-Regular",
                    ),
                  ),
                ),
                for (var i = 0; i < dataUsers.length; i++) ...[
                  if (dataUsers[i].type == 1) ...[
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
                                  child: SvgPicture.asset(
                                      "assets/svg/ic_delete.svg"),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10.0),
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
                                      fontFamily: "OpenSans-Regular",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Mytheme.colorTextDivider,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showDialogEditTool(
                                      dataUsers[i].value ?? "0", i);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formNum(dataUsers[i].value ?? "0"),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
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
                    padding: const EdgeInsets.only(top: 20),
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
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
                                fontFamily: "OpenSans-Regular",
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
                                fontFamily: "OpenSans-SemiBold",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),

        // chi phí ban dau
        Visibility(
          visible: selectDefault ? true : false,
          child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, top: 10, left: 16, right: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Xác định các loại chi phí ban đầu. Bạn có thể tham khảo các loại chi phí được ví dụ ở đây và điều chỉnh cho phù hợp với hoạt động sản xuất nông nghiệp",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
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
                      fontFamily: "OpenSans-Regular",
                    ),
                  ),
                ),
                for (var i = 0; i < dataUsers.length; i++) ...[
                  if (dataUsers[i].type == 2) ...[
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
                                  child: SvgPicture.asset(
                                      "assets/svg/ic_delete.svg"),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10.0),
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
                                      fontFamily: "OpenSans-Regular",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Mytheme.colorTextDivider,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showDialogEditTool(
                                      dataUsers[i].value ?? "0", i);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formNum(dataUsers[i].value ?? "0"),
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans-Regular",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
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
                    padding: const EdgeInsets.only(top: 20),
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Tổng chi phí ban đầu",
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Mytheme.color_82869E,
                                fontWeight: FontWeight.w400,
                                fontFamily: "OpenSans-Regular",
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
                                fontFamily: "OpenSans-SemiBold",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ],
    );
  }

  String calculatorTotalType2() {
    int total = 0;
    for (var i = 0; i < dataUsers.length; i++) {
      if (dataUsers[i].type == 2) {
        total = total + int.parse(dataUsers[i].value ?? "0");
      }
    }
    return "${formNum(total.toString())} VNĐ";
  }

  String calculatorTotalType1() {
    int total = 0;
    for (var i = 0; i < dataUsers.length; i++) {
      if (dataUsers[i].type == 1) {
        total = total + int.parse(dataUsers[i].value ?? "0");
      }
    }
    return "${formNum(total.toString())} VNĐ";
  }

  String formNum(String s) {
    return NumberFormat.decimalPattern().format(
      int.parse(s),
    );
  }

  Future<void> saveItemTool(String obj) async {
    await pr.show();
    APIManager.postAPICallNeedToken(RemoteServices.storeDataItemToolURL, obj)
        .then((value) async {
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

  showDialogSuccess() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: SuccessDialogBox(
                title:
                    "Chúc mừng bạn đã tạo thành công kế hoạch SXNN của mình!",
                descriptions:
                    "Trước khi bắt đầu thực hiện hoặc chuẩn bị đến Tổ chức tài chính để đăng ký vay vốn, đừng quên xem lại tất cả các thông tin. Hãy hỏi thêm lời khuyên từ cán bộ tín dụng nếu cần.",
                textButton: "Tiếp tục",
                onClickedConfirm: () {
                  Get.back(result: true);
                  Get.back(result: true);
                },
              ));
        });
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
        });
  }

  contentBox(context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0, right: 0, bottom: Constants.padding),
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
                        labelText: typeObj == 2 ? 'Chi phí' : 'Thu nhập',
                      ),
                      onChanged: (value) {},
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
                      var thunhap = _thuNhapController.text;
                      var sotien = "";
                      if (_soTienController.text.isNotEmpty) {
                        sotien = _soTienController.text.replaceAll(',', '');
                      }
                      if (sotien.isEmpty || thunhap.isEmpty) {
                        Utils.showError(
                            "Vui lòng nhập đầy đủ thông tin", context);
                        return;
                      }

                      if (sotien.isNotEmpty && thunhap.isNotEmpty) {
                        setState(() {
                          dataUsers.add(DataUsers(
                              key: thunhap, value: sotien, type: typeObj));
                        });
                      }

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

  showDialogEditTool(String text, int position) async {
    if (text.isNotEmpty) {
      _editMoneyController.text = text;
      // setState(() {
      //   updateButton = true;
      // });
    } else {
      _editMoneyController.text = "";
      // setState(() {
      //   updateButton = false;
      // });
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
              child: contentEditBox(context, position),
            ),
          );
        });
  }

  contentEditBox(context, int position) {
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
                      controller: _editMoneyController,
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
                        _editMoneyController.value = TextEditingValue(
                          text: value,
                          selection: TextSelection.collapsed(
                            offset: value.length,
                          ),
                        );
                      },
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
                      var thunhap = _editMoneyController.text;
                      if (thunhap.isNotEmpty) {
                        setState(() {
                          dataUsers[position].value =
                              thunhap.replaceAll(",", "");
                        });
                      } else {
                        dataUsers[position].value = "0";
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
                      child: Text(
                        // updateButton == true ? "Cập nhật" : "Thêm",
                        "Cập nhật",
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
}
