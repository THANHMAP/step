class ContentQuizzTemp {
  int? id;
  String? questionText;
  String? questionFile;
  int? type;
  String? suggest;
  bool? isAnswers;
  List<AnswersTemp>? answers;

  ContentQuizzTemp(
      {this.id,
        this.questionText,
        this.questionFile,
        this.type,
        this.suggest,
        this.isAnswers,
        this.answers});

  ContentQuizzTemp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
    questionFile = json['question_file'];
    type = json['type'];
    suggest = json['suggest'];
    isAnswers = false;
    if (json['answers'] != null) {
      answers = <AnswersTemp>[];
      json['answers'].forEach((v) {
        answers!.add(new AnswersTemp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_text'] = this.questionText;
    data['question_file'] = this.questionFile;
    data['type'] = this.type;
    data['suggest'] = this.suggest;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswersTemp {
  int? id;
  String? answerText;
  String? answerFile;
  int? isCorrect;
  bool? isSelect;
  int? selectIsCorrect;

  AnswersTemp(
      {this.id,
        this.answerText,
        this.answerFile,
        this.isCorrect,
        this.isSelect,
        this.selectIsCorrect});

  AnswersTemp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerText = json['answer_text'];
    answerFile = json['answer_file'];
    isCorrect = json['is_correct'];
    isSelect = false;
    selectIsCorrect = 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer_text'] = this.answerText;
    data['answer_file'] = this.answerFile;
    data['is_correct'] = this.isCorrect;
    return data;
  }
}