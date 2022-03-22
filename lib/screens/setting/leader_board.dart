import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:step_bank/compoment/appbar_wiget.dart';
import '../../compoment/item_leader_board.dart';
import '../../models/leader_board_model.dart';
import '../../service/api_manager.dart';
import '../../service/remote_service.dart';
import '../../themes.dart';
import '../../util.dart';


class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  late ProgressDialog pr;
  List<LeaderBoardData> dataLeaderBoard = [];
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
      loadLeaderBoard();
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
              text: "Bảng xếp hạng",
              onClicked: () {
                Navigator.of(context).pop(false);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for(var i = 0; i < dataLeaderBoard.length; i++)...[
                        ItemLeaderBoardWidget(
                          name: dataLeaderBoard[i].name,
                          numberStt: i + 1,
                          avatar: dataLeaderBoard[i].avatar,
                          score: dataLeaderBoard[i].score??0,
                          onClicked: () {
                          },
                        ),
                      ]

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

  Future<void> loadLeaderBoard() async {
    await pr.show();
    APIManager.getAPICallNeedToken(RemoteServices.leaderBoardURL).then((value) async {
      var data = LeaderBoardModel.fromJson(value);
      if (data.statusCode == 200) {
        setState(() {
          dataLeaderBoard = data.data!;
        });
      } else {
        await pr.hide();
        Utils.showAlertDialogOneButton(context, value['message'].toString());
      }
    }, onError: (error) async {
      Utils.showError(error.toString(), context);
    });
    await pr.hide();
  }


}