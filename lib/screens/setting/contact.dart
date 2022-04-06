import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/models/position_leader_model.dart';
import '../../compoment/item_leader_board.dart';
import '../../compoment/item_leader_position_board.dart';
import '../../models/city_model.dart';
import '../../models/contact/contact_model.dart';
import '../../models/leader_board_model.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../themes.dart';
import '../../util.dart';


class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late ProgressDialog pr;
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController wardEditingController = TextEditingController();
  TextEditingController providerEditingController = TextEditingController();

  List<CityData> _tempListCity = [];
  // city
  List<CityData> cityData = [];
  int currentCityIndex = 0;
  //
  List<ContactData> _listContact = [];
  List<ContactData> _tempListWard = [];
  ContactData? _contactData;
  int currentContactIndex = 0;

  List<String> creditList = ["Ngân hàng", "Quỹ tín dụng"];
  int currentCreditIndex = 1;

  // provider
  int currentProviderIndex = 0;
  List<Provinces> _providersData = [];
  List<Provinces> _tempProvidersData = [];

  @override
  void initState() {
    super.initState();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    Utils.portraitModeOnly();
    Future.delayed(Duration.zero, () {
      loadCity();
    });

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
              text: "Liên hệ",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: Mytheme.colorBgMain,
                  child:  Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child:  typeCredit(),
                      // ),
                      Expanded(
                          child: typeCredit()
                      ),
                      Expanded(
                          child: cityUser()
                      ),
                      Expanded(
                          child: districtUser()
                      ),
                      Expanded(
                          child: wardUser()
                      ),
                    if(_contactData != null) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 60),
                        child:  Align(
                          alignment: Alignment.center,
                          child: Text(
                            _contactData?.name ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Mytheme.colorTextSubTitle,
                              fontWeight: FontWeight.w600,
                              fontFamily: "OpenSans-SemiBold",
                            ),
                          ),
                        ),
                      ),

                    ],

                    ],
                  ),
                ),

            ),
            Expanded(
              flex: 1,
              child: Container(
                color: Mytheme.colorTextDivider,
                child: Column(
                  children: [
                    if(_contactData != null) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Địa chỉ",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Mytheme.color_82869E,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "OpenSans-Regular",
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _contactData?.address ?? "",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorTextSubTitle,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-SemiBold",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Thời gian làm việc",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Mytheme.color_82869E,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "OpenSans-Regular",
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _contactData?.workTime ?? "",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorTextSubTitle,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-SemiBold",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Điện thoại",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Mytheme.color_82869E,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "OpenSans-Regular",
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _contactData?.phone ?? "",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorTextSubTitle,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-SemiBold",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Email",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Mytheme.color_82869E,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "OpenSans-Regular",
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _contactData?.email ?? "",
                                // textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Mytheme.colorTextSubTitle,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "OpenSans-SemiBold",
                                ),
                              ),
                            ),

                          ],
                        ),
                      )
                    ],

                  ],
                ),
              ),

            )

          ],
        ),
      ),
    );
  }

  typeCredit() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          _creditEditModalBottomSheet(context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                    child: Text(
                      getNameCredit(currentCreditIndex),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Mytheme.color_82869E,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    )),
              ),
              SizedBox(
                child: IconButton(
                  icon:
                  Image.asset("assets/images/ic_arrow_down.png"),
                  onPressed: () {
                    _creditEditModalBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _creditEditModalBottomSheet(context) {
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
                              "Chọn tổ chức tín dụng",
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
                    for (var i = 0; i < creditList.length; i++) ...[
                      InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.of(context).pop();
                            currentCreditIndex = i;
                            this.setState(() {
                              currentCreditIndex;
                              getNameCredit(currentCreditIndex);
                              getListContact(currentCityIndex.toString());
                            });
                          });
                        },
                        child: Container(
                          height: 60,
                          color: currentCreditIndex == i
                              ? Mytheme.color_DCDEE9
                              : Mytheme.kBackgroundColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Text(
                                  creditList[i],
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
                                visible: currentCreditIndex == i ? true : false,
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

  cityUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  child:  Text(
                    _nameCity(currentCityIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                    ),
                  ),
                ),

              ),
              SizedBox(
                child: IconButton(
                  icon:
                  Image.asset("assets/images/ic_arrow_down.png"),
                  onPressed: () {
                    _cityEditModalBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  wardUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          _wardEditModalBottomSheet(context);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child:  Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  child:  Text(
                    _nameContact(currentContactIndex) ?? "không có dữ liệu",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon:
                  Image.asset("assets/images/ic_arrow_down.png"),
                  onPressed: () {
                    _wardEditModalBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  districtUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
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
              Expanded(
                child:  Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 5),
                  child:  Text(
                    _nameProvider(currentCityIndex, currentProviderIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Mytheme.color_82869E,
                      fontWeight: FontWeight.w400,
                      fontFamily: "OpenSans-Regular",
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon:
                  Image.asset("assets/images/ic_arrow_down.png"),
                  onPressed: () {
                    _providerEditModalBottomSheet(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

  void _wardEditModalBottomSheet(context) {
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
                           Center(
                            child: Text(
                              currentCreditIndex == 0 ? "Chọn ngân hàng": "Chọn QTDNN",
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
                          controller: wardEditingController,
                          decoration: InputDecoration(
                              labelText: "Search",
                              hintText: "Search",
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)))),
                          onChanged: (value) {
                            setState(() {
                              _tempListWard = _buildSearchWardList(value);
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
                              itemCount: (_tempListWard.isNotEmpty)
                                  ? _tempListWard.length
                                  : _listContact.length,
                              itemBuilder: (context, index) {
                                return (_tempListWard.isNotEmpty)
                                    ? _showBottomSheetWardWithSearch(
                                    index, _tempListWard)
                                    : _showBottomSheetWardWithSearch(
                                    index, _listContact);
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

  Widget _showBottomSheetProviderWithSearch(
      int index, List<Provinces> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).pop();
          currentProviderIndex = int.parse(listOfCities[index].id ?? "0");
          getListContact(currentProviderIndex.toString());

        });
      },
      child: Container(
        height: 60,
        color: currentProviderIndex == listOfCities[index].id!
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
              currentProviderIndex == listOfCities[index].id! ? true : false,
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

  List<ContactData> _buildSearchWardList(String userSearchTerm) {
    List<ContactData> _searchList = [];

    for (int i = 0; i < _listContact.length; i++) {
      String name = _listContact[i].name.toString();
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(_listContact[i]);
      }
    }
    return _searchList;
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
          nameProvider = city.provinces![0].name.toString();
          setState(() {
            currentProviderIndex = int.parse(city.provinces![0].id ?? "0");
          });

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

  Widget _showBottomSheetCityWithSearch(
      int index, List<CityData> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).pop();
          currentCityIndex = listOfCities[index].id!;
          // getListContact(currentCityIndex.toString());

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

  Widget _showBottomSheetWardWithSearch(
      int index, List<ContactData> listOfWards) {
    return InkWell(
      onTap: () {
        setState(() {
          currentContactIndex = listOfWards[index].id!;
          selectItem(index);
          Navigator.of(context).pop();
          // getListContact(currentCityIndex.toString());

        });
      },
      child: Container(
        height: 60,
        color: currentContactIndex == listOfWards[index].id!
            ? Mytheme.color_DCDEE9
            : Mytheme.kBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                listOfWards[index].name.toString(),
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
              currentContactIndex == listOfWards[index].id! ? true : false,
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

  String? _nameContact(int index) {
    String? nameCity = "không có dữ liệu";
    if(_listContact.isNotEmpty) {
     return nameCity = _listContact[index].name;
    }
    return nameCity;
  }

  Future<void> loadCity() async {
    final String response = await rootBundle.loadString('assets/city.json');
    final data = await json.decode(response);
    var listCitys = CityModel.fromJson(data);
    setState(() {
      cityData = listCitys.data!;
      // getListContact(currentCityIndex.toString());
    });
  }

   selectItem(int index) {
    if(_listContact.isNotEmpty) {
      setState(() {
        currentContactIndex = _listContact[index].id!;
        _contactData = _listContact[index];
      });
    }
  }

  String getNameCredit(int credit) {
    if (credit == 0) {
      return "Ngân hàng";
    }
    return "Quỹ tín dụng";
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

  Future<void> getListContact(String id) async {
    pr.show();
    var param = jsonEncode(<String, String>{
      'is_credit_fund': currentCreditIndex.toString(),
      'province_id': id,
    });
    APIManager.postAPICallNeedToken(RemoteServices.listContactURL, param).then((value) async {
      var dataContact = ContactModel.fromJson(value);
      pr.hide();
      if (dataContact.statusCode == 200) {
        setState(() {
          _contactData = null;
          _listContact = dataContact.data!;
          if(_listContact.isNotEmpty) {
            selectItem(0);
          }
        });
      } else {
        Utils.showAlertDialogOneButton(context, value['message'].toString());
      }
    }, onError: (error) async {
      Utils.showError(error.toString(), context);
    });
  }


}
