import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_bank/constants.dart';

import '../controllers/question_controller.dart';
import '../models/result_question.dart';
import '../models/study_model.dart';
import '../themes.dart';
import 'answers.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    Key? key,
    required this.question,
    required this.indexQuestion,
    required this.callback,
  }) : super(key: key);

  final ContentQuizz question;
  final int indexQuestion;
  final CalbackFunction callback;

  @override
  Widget build(BuildContext context) {
    callback(true);
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Constants.kDefaultPadding,
      ),
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            "Câu ${indexQuestion + 1}.${question.questionText.toString()}",
            style: const TextStyle(
              fontSize: 18,
              color: Mytheme.color_0xFF003A8C,
              fontWeight: FontWeight.w600,
              fontFamily: "OpenSans-SemiBold",
            ),
          ),
          const SizedBox(height: Constants.kDefaultPadding / 2),
          ...List.generate(
            question.answers!.length,
            (index) => Option(
              index: index,
              indexQuestion: indexQuestion,
              isCorrect: question.answers![index].isCorrect!,
              text: question.answers![index].answerText.toString(),
              press: () {
                // callback(false);
                if (!_controller.checkAnswerd(indexQuestion)) {
                  _controller.checkAns(question, index, indexQuestion);
                }
              },
              callback: (bool value) {
                callback(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

typedef CalbackFunction = void Function(bool value);
typedef CalbackQuestion = void Function(int indexQuestion);
