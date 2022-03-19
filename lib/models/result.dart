class Result {
  String? result;
  int? numOfCorrectAns;
  List<Question>? listQuestion;
  Result({
    this.result,
    this.numOfCorrectAns,
    this.listQuestion,
  });
}

class Question {
  int? id;
  bool? isCorrect;
  Question({
    this.id,
    this.isCorrect,
  });
}