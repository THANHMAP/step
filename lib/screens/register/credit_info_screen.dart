import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../compoment/appbar_wiget.dart';
import '../../constants.dart';
import '../../models/CreditModel.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class CreditInfoScreen extends StatefulWidget {
  const CreditInfoScreen({Key? key}) : super(key: key);

  @override
  _CreditInfoScreenScreenState createState() => _CreditInfoScreenScreenState();
}

class _CreditInfoScreenScreenState extends State<CreditInfoScreen> {
  late ProgressDialog pr;
  List<CreditData>? creditList = [];
  TextEditingController creditEditingController = TextEditingController();
  List<CreditData> _tempCreditList = [];
  int currentIndex = 0;
  int currentIndexTemp = -1;
  int idCredit = 0;
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    String cityId = Get.arguments.toString();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );
    controller = ScrollController()..addListener(_scrollListener);
    Future.delayed(Duration.zero, () {
      loadListCredittest(cityId);
    });
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.atEdge) {
      bool isTop = controller.position.pixels == 0;
      if (isTop) {
        print('At the top');
      } else {
        print('At the bottom');
        // loadListCredittest();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.03),
      child: GestureDetector(
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
                        text: "Quỹ TDND/Chi nhánh ngân hàng HTX",
                        onClicked: () => Get.back(result: false),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: Container(
                            child: TextField(
                              controller: creditEditingController,
                              decoration: InputDecoration(
                                  labelText: "Tìm kiếm",
                                  hintText: "Tìm Quỹ TDND/CNNG HTX",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)))),
                              onChanged: (value) {
                                setState(() {
                                  currentIndexTemp = -1;
                                  _tempCreditList =
                                      _buildSearchCreditList(value);
                                });
                              },
                            ),
                          )),
                      Expanded(
                        flex: 7,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 24, right: 24, bottom: 10),
                          child: Column(
                            children: [
                              Flexible(
                                child: ListView.builder(
                                  controller: controller,
                                  shrinkWrap: true,
                                  itemCount: (_tempCreditList.isNotEmpty)
                                      ? _tempCreditList.length
                                      : creditList!.length,
                                  itemBuilder: (context, index) {
                                    return (_tempCreditList.isNotEmpty)
                                        ? _showBottomSheetWithSearch(
                                        index, _tempCreditList)
                                        : _showBottomSheetCityWithSearch(
                                        index, creditList!);
                                    //   ListTile(
                                    //   title: Text('${(_tempListCity.isNotEmpty) ? _tempListCity[index].name : cityData[index].name}'),
                                    // );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                            padding:
                            const EdgeInsets.only(bottom: 30, left: 24, right: 24),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    // side: const BorderSide(color: Colors.red)
                                  ),
                                  primary: Mytheme.colorBgButtonLogin,
                                  minimumSize:
                                  Size(MediaQuery.of(context).size.width, 44)),
                              child: const Text(
                                StringText.text_continue,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: "OpenSans-Regular",
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                Constants.idCreditTemp = idCredit.toString();

                                Get.back(result: true);
                              },
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  int getIndexCredit(int idCredit) {
    int index = 0;
    for (int i = 0; i < creditList!.length; i++) {
      if (creditList![i].id == idCredit) {
        return index = i;
      }
    }
    return index;
  }

  List<CreditData> _buildSearchCreditList(String userSearchTerm) {
    List<CreditData> _searchList = [];

    for (int i = 0; i < creditList!.length; i++) {
      String name = creditList![i].name.toString();
      if (name.toLowerCase().contains(userSearchTerm.toLowerCase())) {
        _searchList.add(creditList![i]);
      }
    }
    return _searchList;
  }

  Widget _showBottomSheetCityWithSearch(
      int index, List<CreditData> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          idCredit = listOfCities[index].id!;
          Constants.nameCreditTemp = listOfCities[index].name!;
          currentIndex = getIndexCredit(idCredit);
        });
      },
      child: Container(
        height: 60,
        color: currentIndex == index
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
              visible: currentIndex == index ? true : false,
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

  Widget _showBottomSheetWithSearch(
      int index, List<CreditData> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          idCredit = listOfCities[index].id!;
          Constants.nameCreditTemp = listOfCities[index].name!;
          currentIndex = getIndexCredit(idCredit);
          currentIndexTemp = index;
        });
      },
      child: Container(
        height: 60,
        color: currentIndexTemp == index
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
              visible: currentIndexTemp == index ? true : false,
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

  Future<void> loadListCredittest(String cityId) async {
    var param = jsonEncode(<String, String>{'city_id': cityId});
    await pr.show();
    APIManager.postAPICallNoNeedToken(RemoteServices.getListCredit, param).then(
            (value) async {
          await pr.hide();
          if (value['status_code'] == 200) {
            var creditModel = CreditModel.fromJson(value);
            setState(() {
              for (var item in creditModel.data!.data!) {
                creditList?.add(item);
              }
              if (creditList != null && creditList!.isNotEmpty) {
                idCredit = creditList![0].id!;
                Constants.nameCreditTemp = creditList![0].name!;
                currentIndex = getIndexCredit(idCredit);
                currentIndexTemp = 0;
              }
            });
          } else {
            Utils.showAlertDialogOneButton(context, value['message'].toString());
          }
        }, onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }
}
