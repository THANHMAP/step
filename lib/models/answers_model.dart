class AnswersModel {
  bool? statusError;
  int? statusCode;
  String? message;
  AnswersData? data;

  AnswersModel({this.statusError, this.statusCode, this.message, this.data});

  AnswersModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new AnswersData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_error'] = this.statusError;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AnswersData {
  int? id;
  List<ContentQuizz>? contentQuizz;

  AnswersData({this.id, this.contentQuizz});

  AnswersData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['content_quizz'] != null) {
      contentQuizz = <ContentQuizz>[];
      json['content_quizz'].forEach((v) {
        contentQuizz!.add(new ContentQuizz.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.contentQuizz != null) {
      data['content_quizz'] =
          this.contentQuizz!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ContentQuizz {
  int? id;
  String? questionText;
  String? suggest;
  String? questionFile;
  int? type;
  List<Answers>? answers;

  ContentQuizz(
      {this.id,
        this.questionText,
        this.suggest,
        this.questionFile,
        this.type,
        this.answers});

  ContentQuizz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
    suggest = json['suggest'];
    questionFile = json['question_file'];
    type = json['type'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_text'] = this.questionText;
    data['suggest'] = this.suggest;
    data['question_file'] = this.questionFile;
    data['type'] = this.type;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Answers {
  int? id;
  String? answerText;
  String? answerFile;
  int? ordering;
  int? isCorrect;
  bool? userChoose;

  Answers(
      {this.id,
        this.answerText,
        this.answerFile,
        this.ordering,
        this.isCorrect,
        this.userChoose});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerText = json['answer_text'];
    answerFile = json['answer_file'];
    ordering = json['ordering'];
    isCorrect = json['is_correct'];
    userChoose = json['user_choose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['answer_text'] = this.answerText;
    data['answer_file'] = this.answerFile;
    data['ordering'] = this.ordering;
    data['is_correct'] = this.isCorrect;
    data['user_choose'] = this.userChoose;
    return data;
  }
}
