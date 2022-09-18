import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import 'package:step_bank/compoment/button_wiget.dart';
import 'package:step_bank/compoment/button_wiget_border.dart';
import 'package:step_bank/compoment/dialog_nomal.dart';
import 'package:step_bank/compoment/textfield_widget.dart';
import 'package:step_bank/models/CreditModel.dart';
import 'package:step_bank/service/api_manager.dart';
import 'package:step_bank/service/remote_service.dart';
import 'package:step_bank/strings.dart';

import '../../themes.dart';
import '../../util.dart';

class UpdatePassWordScreen extends StatefulWidget {
  const UpdatePassWordScreen({Key? key}) : super(key: key);

  @override
  _UpdatePassWordScreenState createState() => _UpdatePassWordScreenState();
}

class _UpdatePassWordScreenState extends State<UpdatePassWordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  TextEditingController creditEditingController = TextEditingController();
  bool isPasswordVisible = true;
  bool isPasswordConfirmVisible = true;
  String title = "";
  String textButton = "";
  String phone = "";
  int typeScreen = 0;
  late ProgressDialog pr;
  List<CreditData>? creditList = <CreditData>[];
  List<CreditData> _tempCreditList = [];
  int currentIndex = 0;
  int idCredit = 0;

  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    if (Get.arguments.toString().contains("register:")) {
      typeScreen = 0;
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_create_password;
      textButton = StringText.text_register_button;
      creditList?.add(CreditData(id: 0, name: "Chọn Quỹ"));
      Future.delayed(Duration(seconds: 0), () {
        loadListCredit();
      });

    } else {
      typeScreen = 1;
      phone = Get.arguments.toString().split(":")[1];
      title = StringText.text_create_password_new;
      textButton = StringText.text_change_password;
    }

    _passwordController.addListener(() => setState(() {}));
    _passwordConfirmController.addListener(() => setState(() {}));
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
                    flex: 9,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AppbarWidget(
                          text: title,
                          onClicked: () => Get.back(),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 30, left: 24, right: 24),
                          child: Column(
                            children: [
                              if(creditList != null && typeScreen == 0 && creditList!.isNotEmpty)...[
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Chọn tên Quỹ TDND/Chi nhánh ngân hàng HTX",
                                    textAlign: TextAlign.left,
                                    style: Mytheme.textSubTitle,
                                  ),
                                ),

                                creditUser(),
                                const SizedBox(height: 10),
                              ],

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  StringText.text_password,
                                  textAlign: TextAlign.left,
                                  style: Mytheme.textSubTitle,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 56,
                                child: TextFieldWidget(
                                    textAlign: true,
                                    maxLines: 1,
                                    obscureText: isPasswordVisible,
                                    hintText: StringText.text_password_input,
                                    // labelText: 'Password',
                                    // prefixIcon:
                                    // const Icon(Icons.person, color: Colors.grey),
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    clickSuffixIcon: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    textController: _passwordController),
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset("assets/svg/text_goi_u_pass.svg"),
                              ),
                              const SizedBox(height: 10),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  StringText.text_password_input_again,
                                  textAlign: TextAlign.left,
                                  style: Mytheme.textSubTitle,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 56,
                                child: TextFieldWidget(
                                    textAlign: true,
                                    maxLines: 1,
                                    obscureText: isPasswordConfirmVisible,
                                    hintText: StringText.text_password_input_again,
                                    // labelText: 'Password',
                                    // prefixIcon:
                                    // const Icon(Icons.person, color: Colors.grey),
                                    textInputAction: TextInputAction.done,
                                    suffixIcon: isPasswordConfirmVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    clickSuffixIcon: () {
                                      setState(() {
                                        isPasswordConfirmVisible =
                                        !isPasswordConfirmVisible;
                                      });
                                    },
                                    textController: _passwordConfirmController),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                          child: Text(
                            textButton,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "OpenSans-Regular",
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            doUpdate();
                            // Get.toNamed('/otp');
                          },
                        )),
                  ),
                ],
              ),
            )),
    );
  }

  Future<void> signUp() async {
    String? password, passwordConfirm;
    if (_passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty) {
      await pr?.show();
      password = _passwordController.text;
      passwordConfirm = _passwordConfirmController.text;
      var param = jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
        'password_confirm': passwordConfirm,
        'credit_fund_id' : idCredit.toString(),
      });
      if (password == passwordConfirm) {
        APIManager.postAPICallNoNeedToken(RemoteServices.signUpOTPURL, param)
            .then((value) async {
          await pr?.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child:  NormalDialogBox(
                        descriptions: StringText.text_register_acc_success,
                        onClicked: () => switchToLogin()
                    ));
              });
        }, onError: (error) async {
          await pr?.hide();
          Utils.showError(error.toString(), context);
        });
      } else {
        await pr?.hide();
        Utils.showAlertDialogOneButton(
            context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
        // Get.snackbar("Thông báo", "Mật khẩu không giống nhau. Vui lòng nhập lại");
      }
    } else {
      Utils.showAlertDialogOneButton(
          context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
      // Get.snackbar("Thông báo", "Vui lòng điền đúng dịnh dạng số điện thoại");
    }
  }
  
  Future loadCredit() async {
   await pr.show();
   await APIManager.getAPICallNoNeedToken(RemoteServices.getListCredit).then((value) async {
        var creditModel = CreditModel.fromJson(value);
        if(creditModel.statusCode == 200){
          for(var item in creditModel.data!) {
            creditList?.add(item);
          }
          setState(() {
            creditList;
            Future.delayed(Duration(seconds: 2), () async {
              await pr.hide();
            });
          });
        } else {
          await pr.hide();
        }
    },onError: (error) async {
      await pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  Future<void> loadListCredit() async {
    await pr.show();
    APIManager.getAPICallNoNeedToken(RemoteServices.getListCredit).then(
            (value) async {
          var creditModel = CreditModel.fromJson(value);
          if(creditModel.statusCode == 200){
            for(var item in creditModel.data!) {
              creditList?.add(item);
            }
            setState(() {
              creditList;
            });
          }
          Future.delayed(Duration(seconds: 2)).then((value) {
            if (pr.isShowing())
              pr.hide().whenComplete(() {
                print("error");
              });
          });
        }, onError: (error) async {
      pr.hide();
      Utils.showError(error.toString(), context);
    });
  }

  // Future fetchCredit() async {
  //   await pr?.show();
  //   final response = await APIManager.getAPICallNoNeedToken(RemoteServices.getListCredit);
  //
  // }

  Future<void> updatePassword() async {
    String? password, passwordConfirm;
    if (_passwordController.text.isNotEmpty &&
        _passwordConfirmController.text.isNotEmpty) {
      await pr?.show();
      password = _passwordController.text;
      passwordConfirm = _passwordConfirmController.text;
      var param = jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
        'password_confirm': passwordConfirm
      });
      if (password == passwordConfirm) {
        APIManager.postAPICallNoNeedToken(
                RemoteServices.forgotPasswordURL, param)
            .then((value) async {
          await pr?.hide();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child:  NormalDialogBox(
                      descriptions: StringText.text_change_password_success,
                      onClicked: () => switchToLogin()
                    ));
              });

        }, onError: (error) async {
          await pr?.hide();
          Utils.showError(error.toString(), context);
        });
      } else {
        await pr?.hide();
        Utils.showAlertDialogOneButton(
            context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
        // Get.snackbar("Thông báo", "Mật khẩu không giống nhau. Vui lòng nhập lại");
      }
    } else {
      Utils.showAlertDialogOneButton(
          context, "Mật khẩu không giống nhau. Vui lòng nhập lại");
      // Get.snackbar("Thông báo", "Vui lòng điền đúng dịnh dạng số điện thoại");
    }
  }

  Future<void> doUpdate() async {
    if (typeScreen == 0) {
      signUp();
    } else {
      updatePassword();
    }
  }

  Future<void> switchToLogin() async {
    Get.offAllNamed("/login");
  }

  creditUser() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
      child: InkWell(
        onTap: () {
          _creditModalBottomSheet(context);
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
              // const Expanded(
              //   flex: 1,
              //   child: Padding(
              //     padding:
              //     EdgeInsets.only(top: 12, left: 16, bottom: 18, right: 0),
              //     child: Text(
              //       "Ngân hàng / quỹ tín dụng",
              //       textAlign: TextAlign.start,
              //       style: TextStyle(
              //         fontSize: 16,
              //         color: Mytheme.colorBgButtonLogin,
              //         fontWeight: FontWeight.w600,
              //         fontFamily: "OpenSans-Semibold",
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 5, right: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            creditList![currentIndex].name.toString(),
                            textAlign: TextAlign.center,
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
                              _creditModalBottomSheet(context);
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


  void _creditModalBottomSheet(context) {
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
          return  MediaQuery(
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
                            // const Center(
                            //   child: Text(
                            //     "Chọn tên Quỹ TDND/Chi nhánh ngân hàng HTX",
                            //     textAlign: TextAlign.center,
                            //     style: TextStyle(
                            //       fontSize: 18,
                            //       color: Mytheme.color_434657,
                            //       fontWeight: FontWeight.w600,
                            //       fontFamily: "OpenSans-Semibold",
                            //       // decoration: TextDecoration.underline,
                            //     ),
                            //   ),
                            // ),
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
                            controller: creditEditingController,
                            decoration: InputDecoration(
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)))),
                            onChanged: (value) {
                              setState(() {
                                _tempCreditList = _buildSearchCreditList(value);
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
                                itemCount: (_tempCreditList.isNotEmpty)
                                    ? _tempCreditList.length
                                    : creditList!.length,
                                itemBuilder: (context, index) {
                                  return (_tempCreditList.isNotEmpty)
                                      ? _showBottomSheetCityWithSearch(
                                      index, _tempCreditList)
                                      : _showBottomSheetCityWithSearch(
                                      index, creditList!);
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

  int getIndexCredit(int idCredit) {
    int index = 0;
    for (int i = 0; i < creditList!.length; i++) {
      if(creditList![i].id == idCredit) {
        return index = i;
      }
    }
    return index;
  }

  Widget _showBottomSheetCityWithSearch(
      int index, List<CreditData> listOfCities) {
    return InkWell(
      onTap: () {
        setState(() {
          idCredit = listOfCities[index].id!;
          currentIndex = getIndexCredit(idCredit);
          Navigator.of(context).pop();
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
              visible:
              currentIndex == index ? true : false,
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



}
