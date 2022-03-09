class EducationModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<EducationData>? data;

  EducationModel({this.statusError, this.statusCode, this.message, this.data});

  EducationModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EducationData>[];
      json['data'].forEach((v) {
        data!.add(new EducationData.fromJson(v));
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

class EducationData {
  int? id;
  String? name;
  String? description;
  String? createdAt;

  EducationData({this.id, this.name, this.description, this.createdAt});

  EducationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
