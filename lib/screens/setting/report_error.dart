import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../../compoment/appbar_wiget.dart';
import '../../compoment/dialog_nomal.dart';
import '../../compoment/textfield_widget.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../strings.dart';
import '../../themes.dart';
import '../../util.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late ProgressDialog pr;
  var _image;
  var imagePicker;
  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

    _nameController.addListener(() => setState(() {}));
    _contentController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.1),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Mytheme.kBackgroundColor,
              body: Column(
                children: <Widget>[
                  AppbarWidget(
                    text: StringText.text_report_title,
                    onClicked: () => Get.back(),
                  ),
                  Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      child:  Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(top: 30, left: 24, right: 24,  bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Tên lỗi",
                                    textAlign: TextAlign.left,
                                    style: Mytheme.textSubTitle,
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
                                      textInputAction: TextInputAction.next,
                                      obscureText: false,
                                      hintText: "Tên lỗi",
                                      // labelText: "Phone number",
                                      // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                      suffixIcon: Icons.close,
                                      clickSuffixIcon: () => _nameController.clear(),
                                      textController: _nameController),
                                ),
                                const SizedBox(height: 30),
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Nội dung",
                                    textAlign: TextAlign.left,
                                    style: Mytheme.textSubTitle,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                SizedBox(
                                  child: TextFieldWidget(
                                      keyboardType: TextInputType.multiline,
                                      // inputFormatters: <TextInputFormatter>[
                                      //   FilteringTextInputFormatter
                                      //       .singleLineFormatter
                                      // ],
                                      textInputAction: TextInputAction.newline,
                                      obscureText: false,
                                      hintText: "Nội dung lỗi",
                                      // labelText: "Phone number",
                                      // prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
                                      suffixIcon: Icons.close,
                                      clickSuffixIcon: () =>
                                          _contentController.clear(),
                                      textController: _contentController),
                                ),
                                const SizedBox(height: 10),
                                loadImage(),
                              ],
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
                            "Gửi báo cáo lỗi",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "OpenSans-Regular",
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            sendReport();
                          },
                        )),
                  ),
                ],
              ),
            )),
    );
  }

  Widget loadImage() {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(0),
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

  Future<void> sendReport() async {
    String? titleError, contentError;
    if (_nameController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      titleError = _nameController.text;
      contentError = _contentController.text;
      if(_image != null) {
        saveImageWithFile(_image, titleError, contentError);
      } else {
        var param = jsonEncode(<String, String>{'name': titleError, 'content': contentError,});
        await pr.show();
        APIManager.postAPICallNeedToken(RemoteServices.reportErrorURL, param)
            .then((value) async {
          if (value['status_code'] == 200) {
            await pr.hide();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                      onWillPop: () {
                        return Future.value(false);
                      },
                      child:  NormalDialogBox(
                          descriptions: StringText.text_report_success,
                          onClicked: () {
                            Get.back();
                          }
                      ));
                });
          } else {
            await pr.hide();
            Utils.showAlertDialogOneButton(context, value['message'].toString());
          }
        }, onError: (error) async {
          await pr.hide();
          Utils.showError(error.toString(), context);
        });
      }

    } else {
      Utils.showAlertDialogOneButton(context, "Vui lòng điền dây dủ thông tin");
    }
  }


  Future<void> saveImageWithFile(File file, name, nd) async {
    await pr.show();
    APIManager.uploadImageHTTPWithParam(file, name, nd, RemoteServices.reportErrorURL).then((value) async {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child:  NormalDialogBox(
                    descriptions: StringText.text_report_success,
                    onClicked: () {
                      Get.back();
                      Get.back();
                    }
                ));
          });
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
