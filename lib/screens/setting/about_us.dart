import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../compoment/appbar_wiget.dart';
import '../../themes.dart';
import '../../util.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  late ProgressDialog pr;
  final url = Get.arguments;
  @override
  void initState() {
    super.initState();
    Utils.portraitModeOnly();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,
    );

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
                        text: "Về chúng tôi",
                        onClicked: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      Expanded(
                        child:  WebView(
                          initialUrl: url,
                          // Enable Javascript on WebView
                          javascriptMode: JavascriptMode.unrestricted,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          )),
    );
  }

}
