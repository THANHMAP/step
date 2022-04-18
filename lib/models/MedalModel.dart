class MedalModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<MedalData>? data;

  MedalModel({this.statusError, this.statusCode, this.message, this.data});

  MedalModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MedalData>[];
      json['data'].forEach((v) {
        data!.add(new MedalData.fromJson(v));
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

class MedalData {
  int? id;
  String? name;
  String? image;
  String? createdAt;

  MedalData({this.id, this.name, this.image, this.createdAt});

  MedalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
