class ResultQuestion {
  final int idQuestion, IdAnswer, indexQuestion;
  final int isCorrect;
  final bool isCallApi;


  ResultQuestion({
    required this.isCallApi,
    required this.idQuestion,
    required this.isCorrect,
    required this.IdAnswer,
    required this.indexQuestion,
  });
}
