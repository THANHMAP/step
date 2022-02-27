class UserGroupModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<UserGroupData>? data;

  UserGroupModel({this.statusError, this.statusCode, this.message, this.data});

  UserGroupModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserGroupData>[];
      json['data'].forEach((v) {
        data!.add(new UserGroupData.fromJson(v));
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

class UserGroupData {
  int? id;
  String? name;
  String? createdAt;

  UserGroupData({this.id, this.name, this.createdAt});

  UserGroupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
