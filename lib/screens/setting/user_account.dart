import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/models/city_model.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/models/user_group.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/custom_exception.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../compoment/button_wiget.dart';
import '../../compoment/dialog_nomal.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

enum ImageSourceType { gallery, camera }

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late ProgressDialog pr;
  late UserData user = UserData();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _userBodController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController providerEditingController = TextEditingController();
  bool _isDisableUsername = true;
  bool _isDisableDob = true;
  String urlActionUsername = "assets/images/ic_edit.png";
  String urlActionBirthday = "assets/images/ic_edit.png";
  List<UserGroupData>? userGroupData;

  // city
  List<CityData> cityData = [];
  List<CityData> _tempListCity = [];

  // provider

  List<Provinces> _providersData = [];
  List<Provinces> _tempProvidersData = [];

  bool isChecked = false;
  List<int> selectedUserGroupList = [];
  String textUserGroup = "";
  List<String> sexList = ["Nam", "Nữ", "Khác"];
  int currentSexIndex = 0;
  int currentCityIndex = 0;
  int currentWardIndex = 0;
  final TextEditingController textController = new TextEditingController();
  var imagePicker;
  var _image;
  String _date = "Not set";

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    loadSharedPrefs();
    _userBodController.text = user.dob.toString();
    _usernameController.text = user.name.toString();
    _usernameController.addListener(() => setState(() {}));
    loadGroup();
    loadCity();
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
              text: "Thông tin cá nhân",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      loadImage(user),
                      infoUser(),
                      sexUser(),
                      birthUser(),
                      cityUser(),
                      districtUser(),
                      memberUser(),
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10, left: 24, right: 24, bottom: 24),
                        child: ButtonWidget(
                            text: StringText.text_save,
                            color: Mytheme.colorBgButtonLogin,
                            onClicked: () => {
                              // saveInfoUser()
                              if(_image != null){
                                saveImage(_image),

                              } else {
                                saveInfoUser()
                              }
                            }),
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

  infoUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: Container(
        height: 50,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Họ và tên",
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 13, right: 0),
                child: TextField(
                  readOnly: _isDisableUsername,
                  controller: _usernameController,
                  autofocus: true,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: user.name ?? "Thêm thông tin",
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 6, bottom: 0, right: 0),
                child: IconButton(
                  icon: Image.asset(urlActionUsername),
                  // tooltip: 'Increase volume by 10',
                  iconSize: 50,
                  onPressed: () {
                    if (_isDisableUsername == true) {
                      setState(() {
                        _isDisableUsername = false;
                        _usernameController.text = user.name.toString();
                        urlActionUsername = "assets/images/ic_delete.png";
                      });
                    } else {
                      setState(() {
                        _isDisableUsername = true;
                        _usernameController.text = user.name.toString();
                        urlActionUsername = "assets/images/ic_edit.png";
                      });

                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double heightOfModalBottomSheet = 30;

  sexUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {
          _sexEditModalBottomSheet(context);
        },
        child: Container(
          height: 50,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                  child: Text(
                    "Giới tính",
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
                flex: 3,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 16, bottom: 18, right: 0),
                    child: Text(
                      getNameSex(currentSexIndex),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Mytheme.color_82869E,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    )),
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
                      _sexEditModalBottomSheet(context);
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

  birthUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Sinh nhật",
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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 13, right: 0),
                child: TextField(
                  keyboardType: TextInputType.datetime,
                  readOnly: _isDisableDob,
                  controller: _userBodController,
                  autofocus: true,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.color_82869E,
                    fontWeight: FontWeight.w400,
                    fontFamily: "OpenSans-Regular",
                  ),
                  decoration: InputDecoration.collapsed(
                    border: InputBorder.none,
                    hintText: user.dob ?? "Ngày sinh",
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 0, left: 6, bottom: 0, right: 0),
                child: IconButton(
                  icon: Image.asset(urlActionBirthday),
                  // tooltip: 'Increase volume by 10',
                  iconSize: 50,
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        theme: DatePickerTheme(
                          containerHeight: 210.0,
                        ),
                        showTitleActions: true,
                        minTime: DateTime(1930, 1, 1),
                        maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                          print('confirm $date');
                          _date = '${date.year} - ${date.month} - ${date.day}';
                          setState(() {
                            _userBodController.text = '${date.day} - ${date.month} - ${date.year}';
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.vi);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cityUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {
          _cityEditModalBottomSheet(context);
        },
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                  child: Text(
                    "Tỉnh / thành phố",
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
                        top: 12, left: 10, bottom: 18, right: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            _nameCity(currentCityIndex),
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Mytheme.color_82869E,
                              fontWeight: FontWeight.w400,
                              fontFamily: "OpenSans-Regular",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: IconButton(
                            icon:
                                Image.asset("assets/images/ic_arrow_down.png"),
                            // tooltip: 'Increase volume by 10',
                            iconSize: 0,
                            onPressed: () {
                              _cityEditModalBottomSheet(context);
                            },
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  districtUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {
          _providerEditModalBottomSheet(context);
        },
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                flex: 1,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
                  child: Text(
                    "Huyện /quận",
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
                      top: 12, left: 16, bottom: 18, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          _nameProvider(currentCityIndex, currentWardIndex),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Mytheme.color_82869E,
                            fontWeight: FontWeight.w400,
                            fontFamily: "OpenSans-Regular",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: Image.asset("assets/images/ic_arrow_down.png"),
                          // tooltip: 'Increase volume by 10',
                          iconSize: 0,
                          onPressed: () {
                            _providerEditModalBottomSheet(context);
                          },
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
    );
  }

  memberUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {
          _userGroupEditModalBottomSheet(context);
        },
        child: Container(
          // height: 100,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 0),
                  child: Column(
                    children: const [
                      Text(
                        "Thành viên / khách hàng của tổ chức tín dụng",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          color: Mytheme.colorBgButtonLogin,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans-Semibold",
                        ),
                      ),
                      // Text(
                      //   textUserGroup,
                      //   textAlign: TextAlign.start,
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     color: Mytheme.color_82869E,
                      //     fontWeight: FontWeight.w400,
                      //     fontFamily: "OpenSans-Regular",
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          textUserGroup,
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Mytheme.color_82869E,
                            fontWeight: FontWeight.w400,
                            fontFamily: "OpenSans-Regular",
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: IconButton(
                          icon: Image.asset("assets/images/ic_arrow_down.png"),
                          // tooltip: 'Increase volume by 10',
                          iconSize: 0,
                          onPressed: () {
                            _userGroupEditModalBottomSheet(context);
                          },
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
    );
  }

  void _sexEditModalBottomSheet(context) {
    showModalBottomSheet(
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
                height: MediaQuery.of(context).size.height * .33,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "Chọn Giới tính",
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
                    for (var i = 0; i < sexList.length; i++) ...[
                      InkWell(
                        onTap: () {
                          setState(() {
                            currentSexIndex = i;
                            this.setState(() {
                              user.gender = currentSexIndex;
                            });
                          });
                        },
                        child: Container(
                          height: 60,
                          color: currentSexIndex == i
                              ? Mytheme.color_DCDEE9
                              : Mytheme.kBackgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  sexList[i],
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
                                visible: currentSexIndex == i ? true : false,
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
            );
          });
        });
  }

  void _userGroupEditModalBottomSheet(context) {
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
                height: MediaQuery.of(context).size.height * .48,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 48,
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 60, right: 60),
                              child: Text(
                                "Chọn Thành viên / khách hàng của tổ chức tín dụng",
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
                    if (userGroupData != null) ...[
                      for (var i = 0; i < userGroupData!.length; i++) ...[
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (!selectedUserGroupList
                                  .contains(userGroupData![i].id)) {
                                selectedUserGroupList
                                    .add(userGroupData![i].id!);
                              } else {
                                selectedUserGroupList
                                    .remove(userGroupData![i].id);
                              }
                            });

                            this.setState(() {
                              selectedUserGroupList;
                              textUserGroup = _userGroupValue(
                                  selectedUserGroupList,
                                  userGroupData!);
                            });
                          },
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: SvgPicture.asset( !selectedUserGroupList.contains(userGroupData![i].id) ?
                                  "assets/svg/ic_not_check_gray.svg":
                                  "assets/svg/checkbox_check_correct.svg"),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    userGroupData![i].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Mytheme.color_434657,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "OpenSans-Semibold",
                                      // decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            );
          });
        });
  }

  void _cityEditModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topLeft: Radius.circular(10),
              bottomRight: Radius.zero,
              topRight: Radius.circular(10)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .68,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "Chọn Tỉnh / thành phố",
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        child: TextField(
                          controller: cityEditingController,
                          decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)))),
                          onChanged: (value) {
                            setState(() {
                              _tempListCity = _buildSearchCityList(value);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 468,
                        child: Stack(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: (_tempListCity.isNotEmpty)
                                  ? _tempListCity.length
                                  : cityData.length,
                              itemBuilder: (context, index) {
                                return (_tempListCity.isNotEmpty)
                                    ? _showBottomSheetCityWithSearch(
                                        index, _tempListCity)
                                    : _showBottomSheetCityWithSearch(
                                        index, cityData);
                                //   ListTile(
                                //   title: Text('${(_tempListCity.isNotEmpty) ? _tempListCity[index].name : cityData[index].name}'),
                                // );
                              },
                            )
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

  void _providerEditModalBottomSheet(context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.zero,
              topLeft: Radius.circular(10),
              bottomRight: Radius.zero,
              topRight: Radius.circular(10)),
        ),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .68,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 38,
                      alignment: Alignment.center,
                      child: Stack(
                        children: <Widget>[
                          const Center(
                            child: Text(
                              "Chọn Quận / huyện",
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Container(
                        child: TextField(
                          controller: providerEditingController,
                          decoration: const InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)))),
                          onChanged: (value) {
                            setState(() {
                              _tempProvidersData =
                                  _buildSearchProviderList(value);
                            });
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      child: SizedBox(
                        height: 468,
                        child: Stack(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: (_tempProvidersData.isNotEmpty)
                                  ? _tempProvidersData.length
                                  : _providersData.length,
                              itemBuilder: (context, index) {
                                return (_tempProvidersData.isNotEmpty)
                                    ? _showBottomSheetProviderWithSearch(
                                        index, _tempProvidersData)
                                    : _showBottomSheetProviderWithSearch(
                                        index, _providersData);
                                //   ListTile(
                                //   title: Text('${(_tempListCity.isNotEmpty) ? _tempListCity[index].name : cityData[index].name}'),
                                // );
                              },
                            )
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

  Color setColorSex(int sex, String text) {
    if (text == getNameSex(sex)) {
      return Mytheme.color_DCDEE9;
    }
    return Mytheme.kBackgroundColor;
  }

  bool visibleCheck(int sex, String text) {
    if (text == getNameSex(sex)) {
      return true;
    }
    return false;
  }

  String getNameSex(int sex) {
    if (sex == 0) {
      return "Nam";
    } else if (sex == 1) {
      return "Nữ";
    }
    return "khác";
  }

  String valueSex(int sexValue) {
    if (sexValue == 0) {
      return "Nam";
    } else if (sexValue == 1) {
      return "Nữ";
    }
    return "Khác";
  }

  Widget loadImage(UserData user) {
    if (user.avatar != null && user.avatar.toString().isNotEmpty) {
      return Stack(
        children: <Widget>[
          if(_image != null)...[
            ClipRRect(
              borderRadius: BorderRadius.circular(60.0),
              child: _image != null
                  ? Image.file(
                _image,
                fit: BoxFit.fill,
                height: 125.0,
                width: 125.0,
              )
                  : Image.asset(
                "assets/images/no_image.png",
                fit: BoxFit.fill,
                height: 125.0,
                width: 125.0,
              ),
            ),
          ] else ...[
            Container(
                width: 116.0,
                height: 116.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(user.avatar.toString())))),
          ],

          Padding(
            padding:
                const EdgeInsets.only(top: 70, left: 84, bottom: 8, right: 0),
            child: InkWell(
              onTap: () async {
                XFile image = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/ic_camera.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      ;
    }
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(60.0),
          child: _image != null
              ? Image.file(
                  _image,
                  fit: BoxFit.fill,
                  height: 125.0,
                  width: 125.0,
                )
              : Image.asset(
                  "assets/images/no_image.png",
                  fit: BoxFit.fill,
                  height: 125.0,
                  width: 125.0,
                ),
        ),

        Padding(
          padding:
              const EdgeInsets.only(top: 70, left: 84, bottom: 8, right: 0),
          child: InkWell(
            onTap: () async {
              XFile image = await imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                  preferredCameraDevice: CameraDevice.front);
              setState(() {
                _image = File(image.path);
              });
            },
            child: Container(
              height: 44,
              width: 44,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_camera.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> loadGroup() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.listUserGroupURL).then(
        (value) async {
      await pr.hide();
      var userGroup = UserGroupModel.fromJson(value);
      if (userGroup.statusCode == 200) {
        setState(() {
          userGroupData = userGroup.data;
          textUserGroup =
              _userGroupValue(selectedUserGroupList, userGroupData!);
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadCity() async {
    final String response = await rootBundle.loadString('assets/city.json');
    final data = await json.decode(response);
    var listCitys = CityModel.fromJson(data);
    setState(() {
      cityData = listCitys.data!;
    });
  }

  loadSharedPrefs() async {
    try {
      var isLogged = await SPref.instance.get("info_login");
      var response = json.decode(isLogged.toString());
      setState(() {
        user = UserData.fromJson(response);
        currentSexIndex = user.gender ?? 0;
        currentCityIndex = user.cityId ?? 0;
        currentWardIndex = user.provinceId ?? 0;
        if(!user.dob.toString().isNotEmpty) {
          _userBodController.text = "Thêm thông tin";
        } else {
          _userBodController.text = user.dob.toString();
        }

        _usernameController.text = user.name.toString();
        user.userGroup?.forEach((element) {
          selectedUserGroupList.add(int.parse(element.id.toString()));
        });
      });
      print(response);
    } on FetchDataException catch (e) {
      print('error caught: $e');
    }
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.green;
    }
    return Colors.green;
  }

  Widget _showBottomSheetCityWithSearch(
      int index, List<CityData> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          currentCityIndex = listOfCities[index].id!;
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 60,
        color: currentCityIndex == listOfCities[index].id!
            ? Mytheme.color_DCDEE9
            : Mytheme.kBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                listOfCities[index].name.toString(),
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
              visible:
                  currentCityIndex == listOfCities[index].id! ? true : false,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Image(
                    image: AssetImage('assets/images/img_check.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showBottomSheetProviderWithSearch(
      int index, List<Provinces> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          currentWardIndex = int.parse(listOfCities[index].id ?? "0");
          Navigator.of(context).pop();
        });
      },
      child: Container(
        height: 60,
        color: currentWardIndex == listOfCities[index].id!
            ? Mytheme.color_DCDEE9
            : Mytheme.kBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                listOfCities[index].name.toString(),
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
              visible:
                  currentWardIndex == listOfCities[index].id! ? true : false,
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Image(
                    image: AssetImage('assets/images/img_check.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CityData> _buildSearchCityList(String userSearchTerm) {
    List<CityData> _searchList = [];

    for (int i = 0; i < cityData.length; i++) {
      String name = cityData[i].name.toString();
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(cityData[i]);
      }
    }
    return _searchList;
  }

  List<Provinces> _buildSearchProviderList(String userSearchTerm) {
    List<Provinces> _searchList = [];

    for (int i = 0; i < _providersData.length; i++) {
      String name = _providersData[i].name.toString();
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_providersData[i]);
      }
    }
    return _searchList;
  }

  String _nameCity(int cityId) {
    var nameCity = "Chưa lựa chọn";
    for (var city in cityData) {
      if (cityId == city.id) {
        nameCity = city.name.toString();
        break;
      }
    }
    return nameCity;
  }

  String _nameProvider(int idCity, int idProvider) {
    var nameProvider = "Chưa lựa chọn";
    if (idCity == 0) {
      return nameProvider;
    }
    for (var city in cityData) {
      if (idCity == city.id) {
        _providersData = city.provinces!;
        if (idProvider == 0) {
          break;
        }
        for (var provider in city.provinces!) {
          if (idProvider == int.parse(provider.id ?? "0")) {
            nameProvider = provider.name.toString();
          }
        }
      }
    }

    return nameProvider;
  }

  String _userGroupValue(List<int> arrayList, List<UserGroupData> data) {
    var userGroup = "";
    if (arrayList.isEmpty) {
      userGroup = "Chưa lựa chọn";
    } else {
      for (var id in arrayList) {
        for (var element in data) {
          if (id == element.id) {
            userGroup = userGroup + element.name.toString() + " & ";
            break;
          }
        }
      }
    }
    if (kDebugMode) {
      print(userGroup);
    }
    return userGroup;
  }

  Future<void> saveInfoUser() async {
    if(!pr.isShowing())
      await pr.show();
    user.name = _usernameController.text;
    user.gender = currentSexIndex;
    user.dob = _userBodController.text;
    user.cityId = currentCityIndex;
    user.provinceId = currentWardIndex;

    var param = jsonEncode(<String, String>{
      'name': user.name.toString(),
      'dob': user.dob.toString(),
      'gender': user.gender.toString(),
      'city_id': user.cityId.toString(),
      'city_id': user.cityId.toString(),
      'province_id': user.provinceId.toString(),
      'groups': selectedUserGroupList
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
    });

    APIManager.postAPICallNeedToken(RemoteServices.updateUserURL, param).then(
        (value) async {

      var loginModel = LoginModel.fromJson(value);
      if (loginModel.statusCode == 200) {
        await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
        await SPref.instance.set("info_login", json.encode(loginModel.data));
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: NormalDialogBox(
                      descriptions: "Cập nhật thông tin thành công",
                      onClicked: () {
                        Navigator.pop(context);
                      }
                  ));
            });
        // Get.offAllNamed("/home");
      }
    }, onError: (error) async {
      var statuscode = error.toString();
      if (statuscode.contains("Unauthorised:")) {
        var unauthorised = "Unauthorised:";
        var test = statuscode.substring(unauthorised.length, statuscode.length);
        var response = json.decode(test.toString());
        var message = response["message"];
        Utils.showAlertDialogOneButton(context, message);
      } else {
        print("Error == $error");
        Utils.showAlertDialogOneButton(context, error);
      }
    });
    await pr.hide();
  }

  Future<void> saveImage(File file) async {
    await pr.show();
    APIManager.uploadImageHTTP(file, RemoteServices.updateAvatarURL).then((value) async {
      var loginModel = LoginModel.fromJson(value);
      if (loginModel.statusCode == 200) {
        saveInfoUser();
        await SPref.instance.set("token", loginModel.data?.accessToken ?? "");
        await SPref.instance.set("info_login", json.encode(loginModel.data));
        // saveInfoUser();
      }
    }, onError: (error) async {
      var statuscode = error.toString();
      if (statuscode.contains("Unauthorised:")) {
        var unauthorised = "Unauthorised:";
        var test = statuscode.substring(unauthorised.length, statuscode.length);
        var response = json.decode(test.toString());
        var message = response["message"];
        Utils.showAlertDialogOneButton(context, message);
      } else {
        print("Error == $error");
        Utils.showAlertDialogOneButton(context, error);
      }
    });
    await pr.hide();
  }






}
