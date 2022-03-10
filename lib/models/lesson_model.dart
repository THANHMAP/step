class LessonModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<LessonData>? data;

  LessonModel({this.statusError, this.statusCode, this.message, this.data});

  LessonModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LessonData>[];
      json['data'].forEach((v) {
        data!.add(new LessonData.fromJson(v));
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

class LessonData {
  int? id;
  String? name;
  String? thumbnail;
  int? numberFinish;
  int? totalPart;
  String? content;
  String? createdAt;
  String? nameCourse;

  LessonData(
      {this.id,
      this.name,
      this.thumbnail,
      this.numberFinish,
      this.totalPart,
      this.content,
      this.createdAt,
      this.nameCourse});

  LessonData.fromJson(Map<String, dynamic> json) {
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
