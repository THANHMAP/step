class CourseDetailModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<CourseDetailData>? data;

  CourseDetailModel(
      {this.statusError, this.statusCode, this.message, this.data});

  CourseDetailModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CourseDetailData>[];
      json['data'].forEach((v) {
        data!.add(new CourseDetailData.fromJson(v));
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

class CourseDetailData {
  int? id;
  String? name;
  String? description;
  String? icon;
  List<InfoList>? infoList;
  String? createdAt;

  CourseDetailData(
      {this.id,
        this.name,
        this.description,
        this.icon,
        this.infoList,
        this.createdAt});

  CourseDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    icon = json['icon'];
    if (json['info_list'] != null) {
      infoList = <InfoList>[];
      json['info_list'].forEach((v) {
        infoList!.add(new InfoList.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['icon'] = this.icon;
    if (this.infoList != null) {
      data['info_list'] = this.infoList!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class InfoList {
  int? id;
  int? courseId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  InfoList(
      {this.id,
        this.courseId,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt});

  InfoList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseId = json['course_id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_id'] = this.courseId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
