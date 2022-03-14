import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_bank/constants.dart';

import '../controllers/question_controller.dart';
import '../models/study_model.dart';
import '../themes.dart';
import 'answers.dart';

class QuestionCard extends StatelessWidget {
  QuestionCard({
    Key? key,
    required this.question,
    required this.indexQuestion,
  }) : super(key: key);

  final ContentQuizz question;
  final int indexQuestion;

  @override
  Widget build(BuildContext context) {
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
                text: question.answers![index].answerText.toString(),
                press: () {
                  if(!_controller.checkAnswerd(indexQuestion)) {
                    _controller.checkAns(question, index, indexQuestion);
                  }

                }),
          ),
        ],
      ),
    );
  }
}
