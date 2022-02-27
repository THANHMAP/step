import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/models/city_model.dart';
import 'package:step_bank/models/login_model.dart';
import 'package:step_bank/models/user_group.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/custom_exception.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/shared/SPref.dart';

import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late ProgressDialog pr;
  late UserData user = UserData();
  final TextEditingController _usernameController = TextEditingController();
  bool _isDisableUsername = true;
  String urlActionUsername = "assets/images/ic_edit.png";
  List<UserGroupData>? userGroupData;
  List<CityData>? cityData;
  bool isChecked = false;
  List<int> selectedList = [1, 3];
  List<String> sexList = ["Nam", "Nữ", "Khác"];
  int currentSexindex = 0;

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    loadSharedPrefs();
    // _usernameController.text = user.username.toString();
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
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  loadImage(user),
                ],
              ),
            ),
            infoUser(),
            sexUser(),
            birthUser(),
            cityUser(),
            districtUser(),
            memberUser()
          ],
        ),
      ),
    );
  }

  loadSharedPrefs() async {
    try {
      var isLogged = await SPref.instance.get("info_login");
      var response = json.decode(isLogged.toString());
      setState(() {
        user = UserData.fromJson(response);
        currentSexindex = user.gender ?? 0;
      });
      print(response);
    } on FetchDataException catch (e) {
      print('error caught: $e');
    }
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Họ và tên",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
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
                    hintText: '',
                  ),
                  maxLines: 1,
                ),
                // Text(
                //   user.username.toString(),
                //   textAlign: TextAlign.end,
                //   style: const TextStyle(
                //     fontSize: 16,
                //     color: Mytheme.color_82869E,
                //     fontWeight: FontWeight.w400,
                //     fontFamily: "OpenSans-Regular",
                //   ),
                // ),
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
                        _usernameController.text = user.username.toString();
                        urlActionUsername = "assets/images/ic_delete.png";
                      });
                    } else {
                      _isDisableUsername = true;
                      _usernameController.text = user.username.toString();
                      urlActionUsername = "assets/images/ic_edit.png";
                    }
                  },
                ),
              ),
            ),

            // Padding(
            //     padding: const EdgeInsets.only(
            //         top: 12, left: 16, bottom: 18, right: 0),
            //     child: Text(
            //       user.username.toString(),
            //       textAlign: TextAlign.start,
            //       style: const TextStyle(
            //         fontSize: 16,
            //         color: Mytheme.color_82869E,
            //         fontWeight: FontWeight.w400,
            //         fontFamily: "OpenSans-Regular",
            //       ),
            //     )),
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
        onTap: () {},
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
                      getNameSex(currentSexindex),
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Sinh nhật",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 10),
                  child: Text(
                    "Thêm thông tin",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  cityUser() {
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 12, left: 16, bottom: 18, right: 0),
                child: Text(
                  "Tỉnh / thành phố",
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Mytheme.colorBgButtonLogin,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans-Semibold",
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 10),
                  child: Text(
                    "Thêm thông tin",
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  districtUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 24, right: 24),
      child: InkWell(
        onTap: () {
          _cityEditModalBottomSheet(context);
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
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 0),
                  child: Text(
                    "Huyện / quận",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.colorBgButtonLogin,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-Semibold",
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 16, bottom: 18, right: 10),
                    child: Text(
                      "Thêm thông tin",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Mytheme.color_82869E,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    )),
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
          height: 100,
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
                  padding: const EdgeInsets.only(
                      top: 12, left: 16, bottom: 18, right: 0),
                  child: Text(
                    "Thành viên / khách hàng của tổ chức tín dụng",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.colorBgButtonLogin,
                      fontWeight: FontWeight.w600,
                      fontFamily: "OpenSans-Semibold",
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, left: 16, bottom: 18, right: 10),
                    child: Text(
                      "Thêm thông tin",
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Mytheme.color_82869E,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    )),
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
                height: MediaQuery.of(context).size.height * .28,
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
                            currentSexindex = i;
                            this.setState(() {
                              user.gender = currentSexindex;
                            });
                          });
                        },
                        child: Container(
                          height: 60,
                          color: currentSexindex == i
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
                                visible: currentSexindex == i ? true : false,
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
                height: MediaQuery.of(context).size.height * .38,
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
                          onTap: () {},
                          child: Container(
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.resolveWith(
                                      getColor),
                                  value: selectedList
                                      .contains(userGroupData![i].id),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        selectedList.add(userGroupData![i].id!);
                                      } else {
                                        selectedList
                                            .remove(userGroupData![i].id);
                                      }
                                    });
                                  },
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
  TextEditingController editingController = TextEditingController();
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

                    TextField(
                      controller: editingController,
                      decoration: InputDecoration(
                          labelText: "Search",
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
                    ),

                    Container(
                      height: 468,
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: cityData?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text('${cityData?[index].name}'),
                              );
                            },
                          ),
                        ],
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

  Container loadImage(UserData user) {
    if (user.avatar != null && user.avatar.toString().isNotEmpty) {
      return Container(
          width: 116.0,
          height: 116.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.avatar.toString()))));
    }
    return Container(
        width: 116.0,
        height: 116.0,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/images/no_image.png"),
            )));
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
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadCity() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.listCityURL).then(
        (value) async {
      await pr.hide();
      var city = CityModel.fromJson(value);
      if (city.statusCode == 200) {
        setState(() {
          cityData = city.data;
        });
      }
    }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
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
}
