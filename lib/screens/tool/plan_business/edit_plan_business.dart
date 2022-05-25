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
import '../../../models/tool/detail_tool.dart';
import '../../../models/tool/item_tool.dart';
import '../../../models/tool/store_data_tool_model.dart';
import '../../../models/tool/update_data_tool.dart';
import '../../../models/tool_model.dart';
import '../../../service/api_manager.dart';
import '../../../service/remote_service.dart';
import '../../../themes.dart';
import '../../../util.dart';

class EditPlaneBusinessToolScreen extends StatefulWidget {
  const EditPlaneBusinessToolScreen({Key? key}) : super(key: key);

  @override
  _EditPlaneBusinessToolScreenState createState() => _EditPlaneBusinessToolScreenState();
}

class _EditPlaneBusinessToolScreenState extends State<EditPlaneBusinessToolScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _namePlantBusinessController = TextEditingController();
  TextEditingController _whoAreYouController = TextEditingController();
  TextEditingController _idealPlanBusinessController = TextEditingController();
  TextEditingController _whatBusinessController = TextEditingController();

  TextEditingController _khachHangCuaBanController = TextEditingController();
  TextEditingController _doiThuCanhTranhController = TextEditingController();
  TextEditingController _theManhCanhTranhController = TextEditingController();

  TextEditingController _cachTiepThiSanPhamController = TextEditingController();

  TextEditingController _lietKeNhiemVuController = TextEditingController();
  TextEditingController _lietKeNguonLucController = TextEditingController();

  TextEditingController _nameBudgetController = TextEditingController();
  TextEditingController _thuNhapController = TextEditingController();
  TextEditingController _soTienController = TextEditingController();

  var formatter = NumberFormat('#,##,000');
  late ProgressDialog pr;
  List<DataUsers> dataUsers = [];
  ScrollController scrollController = ScrollController();
  int indexPlan = 0;
  String imgHeader = "assets/svg/img_plan_business_1.svg";
  bool selectDefault = true;
  int typeObj = 1;
  late ToolData data;
  ItemToolData? _itemToolData;

  @override
  void initState() {
    super.initState();
    data = Constants.toolData!;
    _itemToolData = Get.arguments;
    scrollController.addListener(() { //scroll listener
      double showoffset = 10.0; //Back to top botton will show on scroll offset 10.0

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
      loadDataTool(_itemToolData?.id.toString() ?? "0");
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Mytheme.colorBgMain,
        body: Column(
          children: <Widget>[
            AppbarWidget(
              text: "Kế hoạch kinh doanh",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 0, left: 0, right: 0, bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                  SvgPicture.asset(imgHeader, width: 450,),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 16, right: 16, bottom: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Visibility(
                                          visible: indexPlan == 0 ? true : false,
                                          child:  layouIndex1(),
                                        ),
                                        Visibility(
                                          visible: indexPlan == 1 ? true : false,
                                          child:  layouIndex2(),
                                        ),
                                        Visibility(
                                          visible: indexPlan == 2 ? true : false,
                                          child:  layouIndex3(),
                                        ),
                                        Visibility(
                                          visible: indexPlan == 3 ? true : false,
                                          child:  layouIndex4(),
                                        ),
                                        Visibility(
                                          visible: indexPlan == 4 ? true : false,
                                          child:  layouIndex5(),
                                        ),

                                        Container(
                                          margin:EdgeInsets.only(top: 60),
                                          child: Column(
                                            children: [
                                              Visibility(
                                                visible: indexPlan == 0 ? false : true,
                                                child:  InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      indexPlan = indexPlan - 1;
                                                      imgHeader = "assets/svg/img_plan_business_${indexPlan + 1}.svg";
                                                    });
                                                  },
                                                  child: Container(
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
                                                          "Quay lại",
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
                                              ),
                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                      // side: const BorderSide(color: Colors.red)
                                                    ),
                                                    primary: Mytheme.colorBgButtonLogin,
                                                    minimumSize:
                                                    Size(MediaQuery.of(context).size.width, 44)),
                                                child: Text(
                                                  indexPlan == 4 ? "Lưu" :"Tiếp tục",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "OpenSans-Regular",
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                onPressed: () {
                                                  if(indexPlan < 4) {
                                                    setState(() {
                                                      indexPlan = indexPlan + 1;
                                                      imgHeader = "assets/svg/img_plan_business_${indexPlan + 1}.svg";
                                                    });
                                                    scrollController.animateTo( //go to top of scroll
                                                        0,  //scroll offset to go
                                                        duration: Duration(milliseconds: 500), //duration of scroll
                                                        curve:Curves.fastOutSlowIn //scroll type
                                                    );
                                                  } else {

                                                    UpdateDataTool updateDataTool = UpdateDataTool();
                                                    updateDataTool.title = _namePlantBusinessController.text;
                                                    updateDataTool.userToolId = _itemToolData?.id;
                                                    updateDataTool.type = 1; // 1 plan business

                                                    List<UpdateDataToolUsers>? listData = [];
                                                    //bạn là ai
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "ban_la_ai",
                                                      value: _whoAreYouController.text,
                                                      type: 0,
                                                    ));

                                                    //ý tương kinh doanh
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "y_tuong_kinh_doanh",
                                                      value: _idealPlanBusinessController.text,
                                                      type: 0,
                                                    ));

                                                    //kinh doanh cái gì
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "kinh_doanh_cai_gi",
                                                      value: _whatBusinessController.text,
                                                      type: 0,
                                                    ));

                                                    //Khách hàng của bạn là ai
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "khach_hang_cua_ban",
                                                      value: _khachHangCuaBanController.text,
                                                      type: 0,
                                                    ));

                                                    //Đối thủ cạnh tranh
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "doi_thu_canh_tranh",
                                                      value: _doiThuCanhTranhController.text,
                                                      type: 0,
                                                    ));

                                                    //Thế mạnh cạnh tranh
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "the_manh_canh_tranh",
                                                      value: _theManhCanhTranhController.text,
                                                      type: 0,
                                                    ));

                                                    //Kế hoạch bán hàng
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "ke_hoach_ban_hang",
                                                      value: _cachTiepThiSanPhamController.text,
                                                      type: 0,
                                                    ));

                                                    //nhiệm vụ thuc hien
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "nhiem_vu_thuc_hien",
                                                      value: _lietKeNhiemVuController.text,
                                                      type: 0,
                                                    ));

                                                    //nguồn lực
                                                    listData.add(UpdateDataToolUsers(
                                                      key: "nguon_luc",
                                                      value: _lietKeNguonLucController.text,
                                                      type: 0,
                                                    ));

                                                    for(var i = 0; i<dataUsers.length; i++) {
                                                      if(dataUsers[i].type == 1 || dataUsers[i].type == 2) {
                                                        listData.add(UpdateDataToolUsers(
                                                            key: dataUsers[i].key,
                                                            type: dataUsers[i].type,
                                                            value: dataUsers[i].value
                                                        ));
                                                      }
                                                    }
                                                    updateDataTool.dataUsers = listData;
                                                    saveItemTool(jsonEncode(updateDataTool));
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
    );
  }



  layouIndex1() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Tên hoạt động sản xuất kinh doanh",
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
              hintText: "Tên hoạt động sản xuất kinh doanh",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _namePlantBusinessController.clear(),
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
              clickSuffixIcon: () =>
                  _whoAreYouController.clear(),
              textController: _whoAreYouController),
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Điểm mạnh, kinh nghiệm và điểm lợi thế mà bạn sẽ áp dụng vào hoạt động kinh doanh này",
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 12,
              color: Mytheme.color_82869E,
              fontWeight: FontWeight.w400,
              fontFamily: "OpenSans-Regular",
            ),
          ),
        ),

        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Ý tưởng kinh doanh",
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
              hintText: "Ý tưởng kinh doanh của bạn là",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _idealPlanBusinessController.clear(),
              textController: _idealPlanBusinessController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/svg_hint_text_plan.svg"),
        ),

        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Bạn kinh doanh cái gì ?",
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
              hintText: "Miêu tả sản phẩm hoặc dịch vụ",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _whatBusinessController.clear(),
              textController: _whatBusinessController),
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
            "Khách hàng của bạn là ai",
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
          height: 3 * 24.0,
          child: TextFieldWidget(
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Miêu tả khách hàng",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _khachHangCuaBanController.clear(),
              textController: _khachHangCuaBanController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/khach_hang_cua_ban_la_ai_hit.svg"),
        ),

        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Đối thủ cạnh tranh",
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
          height: 4 * 24.0,
          child: TextFieldWidget(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Đối thủ cạnh tranh của bạn là",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _doiThuCanhTranhController.clear(),
              textController: _doiThuCanhTranhController),
        ),

        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/doi_thu_canh_tranh.svg"),
        ),

        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Thế mạnh cạnh tranh",
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
          height: 4 * 24.0,
          child: TextFieldWidget(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Thế mạnh cạnh tranh của bạn là",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _theManhCanhTranhController.clear(),
              textController: _theManhCanhTranhController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/the_manh_canh_tranh.svg"),
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
            "Kế hoạch bán hàng",
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
          height: 4 * 24.0,
          child: TextFieldWidget(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Cách tiếp thị sản phẩm",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _cachTiepThiSanPhamController.clear(),
              textController: _cachTiepThiSanPhamController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/liet_ke_nhiem_vu.svg"),
        ),
      ],
    );
  }

  layouIndex4() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Chỉ ra các nhiệm vụ cần thực hiện và phân công người chịu trách nhiệm",
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
          height: 4 * 24.0,
          child: TextFieldWidget(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Liệt kê các nhiệm vụ và người chịu trách nhiệm cho công việc đó",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _lietKeNhiemVuController.clear(),
              textController: _lietKeNhiemVuController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/quan_ly_chung.svg"),
        ),

        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Xác định các nguồn lực cần thiết cho hoạt động kinh doanh",
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
          height: 4 * 24.0,
          child: TextFieldWidget(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              // inputFormatters: <TextInputFormatter>[
              //   FilteringTextInputFormatter
              //       .singleLineFormatter
              // ],
              textInputAction: TextInputAction.newline,
              obscureText: false,
              hintText: "Liệt kê các nguồn lực",
              // labelText: "Phone number",
              // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
              // suffixIcon: Icons.close,
              clickSuffixIcon: () =>
                  _lietKeNguonLucController.clear(),
              textController: _lietKeNguonLucController),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset("assets/svg/liet_ke_nguon_luc.svg"),
        ),

      ],
    );
  }

  layouIndex5() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
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
                    style:  TextStyle(
                      fontSize: 16,
                      color: selectDefault ? Mytheme.colorBgButtonLogin : Mytheme.color_82869E,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-SemiBold",
                    ),
                  ),
                ),
              ),

            ),
            Expanded(
              child: InkWell (
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
                    style:  TextStyle(
                      fontSize: 16,
                      color: !selectDefault ? Mytheme.colorBgButtonLogin : Mytheme.color_82869E,
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
              child:  Align(
                  alignment: Alignment.center,
                  child: Divider(
                    thickness: 2,
                    color: selectDefault ? Mytheme.colorBgButtonLogin : Mytheme.color_82869E,
                  )
              ),
            ),
            Expanded(
              child:  Align(
                  alignment: Alignment.center,
                  child: Divider(
                    thickness: 2,
                    color: !selectDefault ? Mytheme.colorBgButtonLogin : Mytheme.color_82869E,
                  )
              ),
            )
          ],
        ),

        // type thu nhap
        Visibility(
          visible: !selectDefault ? true: false,
          child: Padding(
            padding: const EdgeInsets.only( bottom: 30, top: 10, left: 16, right: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Xác định các nguồn thu của động sản xuất kinh doanh. Bạn có thể tham khảo các loại thu nhập được ví dụ ở đây và điều chỉnh cho phù hợp với hoạt động sản xuất kinh doanh của mình",
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
                          Expanded(
                            flex: 2,
                            child: Container(
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
                                  formNum(dataUsers[i].value ?? "0"),
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
        ),

        // chi phí ban dau
        Visibility(
          visible: selectDefault ? true: false,
          child: Padding(
            padding: const EdgeInsets.only( bottom: 30, top: 10, left: 16, right: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Xác định các loại chi phí ban đầu. Bạn có thể tham khảo các loại chi phí được ví dụ ở đây và điều chỉnh cho phù hợp với hoạt động sản xuất kinh doanh.",
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
                          Expanded(
                            flex: 2,
                            child: Container(
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
                                  formNum(dataUsers[i].value ?? "0"),
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
        ),

      ],
    );
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

  String calculatorTotalType1() {
    int total = 0;
    for(var i =0; i < dataUsers.length; i++) {
      if(dataUsers[i].type == 1) {
        total = total + int.parse(dataUsers[i].value??"0");
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
    APIManager.postAPICallNeedToken(RemoteServices.updateItemToolURL, obj).then(
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
                title: "Chúc mừng bạn đã cập nhật thành công kế hoạch SXKD của mình!",
                descriptions:
                "Trước khi bắt đầu thực hiện hoặc chuẩn bị đến Tổ chức tài chính để đăng ký vay vốn, đừng quên xem lại tất cả các thông tin. Hãy hỏi thêm lời khuyên từ cán bộ tín dụng nếu cần.",
                textButton: "Tiếp tục",
                onClickedConfirm: () {
                  Get.back(result: true);
                  Get.back(result: true);
                },
              ));
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

  Future<void> loadDataTool(String id) async {
    await pr.show();
    var param = jsonEncode(<String, String>{
      'user_tool_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.getDetailItemToolURL, param).then(
            (value) async {
          pr.hide();
          var data = DetailTool.fromJson(value);
          if (data.statusCode == 200) {
            setState(() {
              dataUsers = data.data!.dataUsers!;
              _namePlantBusinessController.text = data.data!.name!;
              for(var i =0; i< dataUsers.length; i++) {
                if(dataUsers[i].key == "ban_la_ai"){
                  _whoAreYouController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "y_tuong_kinh_doanh"){
                  _idealPlanBusinessController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "kinh_doanh_cai_gi"){
                  _whatBusinessController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "khach_hang_cua_ban"){
                  _khachHangCuaBanController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "doi_thu_canh_tranh"){
                  _doiThuCanhTranhController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "the_manh_canh_tranh"){
                  _theManhCanhTranhController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "ke_hoach_ban_hang"){
                  _cachTiepThiSanPhamController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "nhiem_vu_thuc_hien"){
                  _lietKeNhiemVuController.text = dataUsers[i].value.toString();
                } else if(dataUsers[i].key == "nguon_luc"){
                  _lietKeNguonLucController.text = dataUsers[i].value.toString();
                }
              }
            });
          }
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

}
