import 'package:get/get_utils/get_utils.dart';

class LessonLearned {
  bool? statusError;
  int? statusCode;
  String? message;
  DataLessonLearned? data;

  LessonLearned({this.statusError, this.statusCode, this.message, this.data});

  LessonLearned.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      if (json['data'].toString() == "[]") {
        data = null;
      } else {
        data = DataLessonLearned.fromJson(json['data']);
      }
    } else {
      data = null;
    }
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

class DataLessonLearned {
  int? id;
  int? lessonId;
  String? lessonName;
  String? thumbnail;
  String? createdAt;

  DataLessonLearned(
      {this.id,
        this.lessonId,
        this.lessonName,
        this.thumbnail,
        this.createdAt});

  DataLessonLearned.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lessonId = json['lesson_id'];
    lessonName = json['lesson_name'];
    thumbnail = json['thumbnail'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lesson_id'] = this.lessonId;
    data['lesson_name'] = this.lessonName;
    data['thumbnail'] = this.thumbnail;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
