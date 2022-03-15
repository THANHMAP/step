import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_bank/constants.dart';

import '../models/result_question.dart';
import '../models/study_model.dart';

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
  late AnimationController _animationController;
  late Animation _animation;

  Animation get animation => _animation;

  List<ResultQuestion> _resultQuestion = [];
  List<ResultQuestion> get resultQuestion => _resultQuestion;

  late PageController _pageController;

  PageController get pageController => _pageController;

  final List<ContentQuizz>? _questions = Constants.questionsGlobals;

  List<ContentQuizz>? get questions => _questions;

  bool _isAnswerd = false;

  bool get isAnswerd => _isAnswerd;

  late int _correctAns;

  int get correctAns => _correctAns;

  late int _selectedAns;

  int get selectedAns => _selectedAns;

  // For more about obs please check documentation
  final RxInt _questionNumber = 1.obs;

  RxInt get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;

  int get numOfCorrectAns => _numOfCorrectAns;

  @override
  void onInit() {
    // Our animation duration is 60s
    // So out plan is to fill the progress bar within 60s
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });

    // Start our animation
    // _animationController.forward().whenComplete(nextQuestion);
    _pageController = PageController();
    super.onInit();
  }

  // Called just befor the Controller is seleted from memory
  void onClose() {
    super.onClose();
    _animationController.dispose();
    _pageController.dispose();
  }

  void checkAns(ContentQuizz question, int selectedIndex, int indexQuestion) {
    // Because once user press any option then it will run
    _isAnswerd = true;

    _correctAns = question.answers![selectedIndex].isCorrect!;
    _selectedAns = selectedIndex;

    _resultQuestion.add(ResultQuestion(
        IdAnswer: question.answers![selectedIndex].id!,
        idQuestion: question.id!,
        isCorrect: _correctAns,
        indexQuestion: indexQuestion
    ));

    if (_correctAns == 1) _numOfCorrectAns++;

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s will go to the next qn
    // Future.delayed(const Duration(seconds: 3), () {
    //   nextQuestion();
    // });
  }

  bool checkAnswerd(int indexQuestion) {
    bool find = false;
    if (_resultQuestion.isEmpty) return false;
    for (var i = 0; i < _resultQuestion.length; i++) {
      if (_resultQuestion[i].indexQuestion == indexQuestion) {
        find = true;
        break;
      }
    }
    return find;
  }

  void nextQuestion() {
    if (_questionNumber.value != _questions?.length) {
      _isAnswerd = false;
      _pageController.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // One timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      // Get a package to provide us simple way to navigate another page
      // Get.to(const ScoreScreen());
    }
  }

  void preQuestion() {
    if (_questionNumber.value == _questions?.length) {
      _isAnswerd = false;
      _pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
      print("tab right: page = " + _pageController.page.toString());
      // Reset the counter
      _animationController.reset();

      // Then start it again
      // One timer is finish go to the next qn
      _animationController.forward().whenComplete(preQuestion);
    } else {
      // Get a package to provide us simple way to navigate another page
      // Get.to(const ScoreScreen());
    }
  }

  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}
