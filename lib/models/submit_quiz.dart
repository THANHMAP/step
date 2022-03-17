class SubmitQuiz {
  int? studyPartId;
  List<SubmitQuizData>? data;
  int? totalCorrect;

  SubmitQuiz({this.studyPartId, this.data, this.totalCorrect});

  SubmitQuiz.fromJson(Map<String, dynamic> json) {
    studyPartId = json['study_part_id'];
    if (json['data'] != null) {
      data = <SubmitQuizData>[];
      json['data'].forEach((v) {
        data!.add(new SubmitQuizData.fromJson(v));
      });
    }
    totalCorrect = json['total_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['study_part_id'] = this.studyPartId;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_correct'] = this.totalCorrect;
    return data;
  }
}

class SubmitQuizData {
  int? questionId;
  List<DataAnswer>? dataAnswer;

  SubmitQuizData({this.questionId, this.dataAnswer});

  SubmitQuizData.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    if (json['data_answer'] != null) {
      dataAnswer = <DataAnswer>[];
      json['data_answer'].forEach((v) {
        dataAnswer!.add(new DataAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    if (this.dataAnswer != null) {
      data['data_answer'] = this.dataAnswer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataAnswer {
  int? answerId;
  bool? isCorrect;

  DataAnswer({this.answerId, this.isCorrect});

  DataAnswer.fromJson(Map<String, dynamic> json) {
    answerId = json['answer_id'];
    isCorrect = json['is_correct'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer_id'] = this.answerId;
    data['is_correct'] = this.isCorrect;
    return data;
  }
}
