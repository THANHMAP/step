class ResultQuestion {
  int idQuestion, IdAnswer, indexQuestion;
  int isCorrect;
  bool isCallApi;

  ResultQuestion({
    required this.isCallApi,
    required this.idQuestion,
    required this.isCorrect,
    required this.IdAnswer,
    required this.indexQuestion,
  });
}
