class StudyModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<StudyData>? data;

  StudyModel({this.statusError, this.statusCode, this.message, this.data});

  StudyModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StudyData>[];
      json['data'].forEach((v) {
        data!.add(new StudyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_error'] = this.statusError;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudyData {
  int? id;
  String? name;
  String? icon;
  String? contentText;
  String? contentFile;
  int? type;
  List<String>? fileSlideShare;
  String? fileScorm;
  List<ContentQuizz>? contentQuizz;

  StudyData(
      {this.id,
        this.name,
        this.icon,
        this.contentText,
        this.contentFile,
        this.type,
        this.fileSlideShare,
        this.fileScorm,
        this.contentQuizz});

  StudyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    icon = json['icon'];
    contentText = json['content_text'];
    contentFile = json['content_file'];
    type = json['type'];
    fileSlideShare = json['file_slide_share'].cast<String>();
    fileScorm = json['file_scorm'];
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
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['content_text'] = this.contentText;
    data['content_file'] = this.contentFile;
    data['type'] = this.type;
    data['file_slide_share'] = this.fileSlideShare;
    data['file_scorm'] = this.fileScorm;
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
  String? questionFile;
  int? type;
  List<Answers>? answers;

  ContentQuizz(
      {this.id, this.questionText, this.questionFile, this.type, this.answers});

  ContentQuizz.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionText = json['question_text'];
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
  int? isCorrect;

  Answers({this.id, this.answerText, this.answerFile, this.isCorrect});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    answerText = json['answer_text'];
    answerFile = json['answer_file'];
    isCorrect = json['is_correct'];
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
