class LessonModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<DataLessonModel>? data;

  LessonModel({this.statusError, this.statusCode, this.message, this.data});

  LessonModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataLessonModel>[];
      json['data'].forEach((v) {
        data!.add(new DataLessonModel.fromJson(v));
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

class DataLessonModel {
  int? id;
  String? name;
  String? courseName;
  List<DataLesson>? dataLesson;
  String? createdAt;
  bool? collapsed;

  DataLessonModel({this.id, this.name, this.courseName, this.dataLesson, this.createdAt, this.collapsed});

  DataLessonModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    courseName = json['course_name'];
    if (json['dataLesson'] != null) {
      dataLesson = <DataLesson>[];
      json['dataLesson'].forEach((v) {
        dataLesson!.add(new DataLesson.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    collapsed = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['course_name'] = this.courseName;
    if (this.dataLesson != null) {
      data['dataLesson'] = this.dataLesson!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class DataLesson {
  int? id;
  String? name;
  String? thumbnail;
  int? numberFinish;
  int? totalPart;
  String? content;
  String? createdAt;


  DataLesson(
      {this.id,
        this.name,
        this.thumbnail,
        this.numberFinish,
        this.totalPart,
        this.content,
        this.createdAt
        });

  DataLesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    numberFinish = json['number_finish'];
    totalPart = json['total_part'];
    content = json['content'];
    createdAt = json['createdAt'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['thumbnail'] = this.thumbnail;
    data['number_finish'] = this.numberFinish;
    data['total_part'] = this.totalPart;
    data['content'] = this.content;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
