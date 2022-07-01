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
  ContactData? _contactData;
  int currentContactIndex = 0;
  int currentContactId = 0;
  bool selectCity = true;

  List<String> creditList = ["Ngân hàng hợp tác xã", "Quỹ tín dụng"];
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
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Mytheme.colorBgMain,
            body: Column(
              children: <Widget>[
                AppbarWidget(
                  text: "Địa chỉ giao dịch",
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
                    child: Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child:  typeCredit(),
                        // ),
                        typeCredit(),
                        cityUser(),
                        districtUser(), // Expanded(
                        //     child: wardUser()
                        // ),
                        // if (_contactData != null) ...[
                        //   Padding(
                        //     padding: EdgeInsets.only(top: 60),
                        //     child: Align(
                        //       alignment: Alignment.center,
                        //       child: Text(
                        //         _contactData?.name ?? "",
                        //         textAlign: TextAlign.center,
                        //         style: const TextStyle(
                        //           fontSize: 16,
                        //           color: Mytheme.colorTextSubTitle,
                        //           fontWeight: FontWeight.w600,
                        //           fontFamily: "OpenSans-SemiBold",
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ],

                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child:  Container(
                      color: Mytheme.colorTextDivider,
                      child: Column(
                        children: [
                          for (int i = 0; i < _listContact.length; i++) ...[
                            Padding(
                              padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      _listContact[i].name ?? "",
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Mytheme.colorTextSubTitle,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "OpenSans-SemiBold",
                                      ),
                                    ),
                                  ),
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
                                      _listContact[i].address ?? "",
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
                                      _listContact[i].phone ?? "",
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
                                    height: 5,
                                  ),
                                  Divider(
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            )
                          ],
                        ],
                      ),
                    ),
                  ),

                )
              ],
            ),
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
          height: 60,
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
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 5),
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
                  icon: Image.asset("assets/images/ic_arrow_down.png"),
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
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
              child: StatefulBuilder(builder: (BuildContext context,
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
                                  getListContact(currentCreditIndex.toString(),
                                      cityData[currentCityIndex].id.toString(),
                                      "");
                                }
                                );
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
              }),
          );
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
          height: 60,
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
                  padding: const EdgeInsets.only(
                      top: 5, left: 5, right: 5, bottom: 5),
                  child: Text(
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
                  icon: Image.asset("assets/images/ic_arrow_down.png"),
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

  districtUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: InkWell(
        onTap: () {
          _providerEditModalBottomSheet(context);
        },
        child: Container(
          height: 60,
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 5, left: 5, right: 5, bottom: 5),
                  child: Text(
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
                  icon: Image.asset("assets/images/ic_arrow_down.png"),
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
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
              child: StatefulBuilder(builder: (BuildContext context,
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
              }),
          );
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
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
              child: StatefulBuilder(builder: (BuildContext context,
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
              }),
          );
        });
  }

  Widget _showBottomSheetProviderWithSearch(
      int index, List<Provinces> listOfProvinces) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).pop();
          selectCity = false;
          currentProviderIndex = index;
          getListContact(currentCreditIndex.toString(), "",
              listOfProvinces[currentProviderIndex].id ?? "0");
        });
      },
      child: Container(
        height: 60,
        color: currentProviderIndex == index
            ? Mytheme.color_DCDEE9
            : Mytheme.kBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                listOfProvinces[index].name.toString(),
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
              visible: currentProviderIndex == index ? true : false,
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

  String _nameProvider(int indexCity, int indexProvider) {
    var nameProvider = "Quận/Huyện";
    if(selectCity) {
      if(cityData.isNotEmpty) {
        _providersData = cityData[indexCity].provinces!;
      }
    } else {
      if(cityData.isNotEmpty) {
        nameProvider = cityData[indexCity].provinces![indexProvider].name.toString();
        _providersData = cityData[indexCity].provinces!;
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
          selectCity = true;
          if(_tempListCity.isNotEmpty && cityEditingController.text.toString().isNotEmpty) {
              var idCity = listOfCities[index].id;
              for(int i = 0; i < cityData.length; i++) {
                if(idCity == cityData[i].id) {
                  currentCityIndex = i;
                  break;
                }
              }
              _tempListCity.clear();
              cityEditingController.clear();
              _providersData = cityData[currentCityIndex].provinces!;
          } else {
            currentCityIndex = index;
            _providersData = cityData[currentCityIndex].provinces!;
          }
          currentProviderIndex = 0;
          getListContact(currentCreditIndex.toString(), cityData[currentCityIndex].id.toString(), "");
        });
      },
      child: Container(
        height: 60,
        color: currentCityIndex == index
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
              visible: currentCityIndex == index ? true : false,
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

  String _nameCity(int index) {
    var nameCity = "Chưa lựa chọn";
    if(cityData.isNotEmpty) {
       nameCity = cityData[index].name.toString();
    }

    // for (var city in cityData) {
    //   if (cityId == city.id) {
    //     nameCity = city.name.toString();
    //     break;
    //   }
    // }
    return nameCity;
  }

  String? _nameContact(int index) {
    String? nameCity = "không có dữ liệu";
    if (_listContact.isNotEmpty) {
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
      getListContact(
          currentCreditIndex.toString(), cityData[currentCityIndex].id.toString(), "");
    });
  }

  selectItem(int index) {
    if (_listContact.isNotEmpty) {
      setState(() {
        currentContactId = _listContact[index].id!;
        _contactData = _listContact[index];
      });
    }
  }

  String getNameCredit(int credit) {
    if (credit == 0) {
      return "Ngân hàng hợp tác xã";
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

  Future<void> getListContact(String indexCredit, String cityId, String idProvince) async {
    pr.show();
    var param = jsonEncode(<String, String>{
      'is_credit_fund': currentCreditIndex.toString(),
      'province_id': idProvince,
      'city_id': cityId,

    });
    APIManager.postAPICallNeedToken(RemoteServices.listContactURL, param).then(
        (value) async {
      var dataContact = ContactModel.fromJson(value);
      pr.hide();
      if (dataContact.statusCode == 200) {
        setState(() {
          _listContact = dataContact.data!;
        });
      } else {
        Utils.showAlertDialogOneButton(context, value['message'].toString());
      }
    }, onError: (error) async {
      Utils.showError(error.toString(), context);
    });
  }
}
