import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../constants.dart';
import '../controllers/question_controller.dart';
import '../themes.dart';

class Option extends StatelessWidget {
  const Option({
    Key? key,
    required this.text,
    required this.index,
    required this.press,
  }) : super(key: key);

  final String text;
  final int index;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (qnController) {
          Color getTheRightColor() {
            if (qnController.isAnswerd) {
              if (index == qnController.correctAns) {
                return Constants.kGreenColor;
              } else if (index == qnController.selectedAns &&
                  qnController.selectedAns != qnController.correctAns) {
                return Constants.kRedColor;
              }
            }
            return Constants.kGrayColor;
          }

          bool isAnswerd() {
            return qnController.isAnswerd;
          }

          IconData getTheRightIcon() {
            return getTheRightColor() == Constants.kRedColor
                ? Icons.close
                : Icons.done;
          }

          return InkWell(
            onTap: press,
            child: Container(
              margin: const EdgeInsets.only(top: Constants.kDefaultPadding),
              padding: const EdgeInsets.all(Constants.kDefaultPadding),
              decoration: BoxDecoration(
                border: Border.all(color: getTheRightColor()),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${index + 1}. $text",
                      style: TextStyle(
                        fontSize: 16,
                        color: Mytheme.colorBgButtonLogin,
                        fontWeight: FontWeight.w400,
                        fontFamily: "OpenSans-Regular",
                      ),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: getTheRightColor() == Constants.kGrayColor
                          ? Colors.transparent
                          : getTheRightColor(),
                      border: Border.all(color: getTheRightColor()),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: getTheRightColor() == Constants.kGrayColor
                        ? null
                        : Icon(getTheRightIcon(), size: 16),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
