class ToolModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<ToolData>? data;

  ToolModel({this.statusError, this.statusCode, this.message, this.data});

  ToolModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ToolData>[];
      json['data'].forEach((v) {
        data!.add(new ToolData.fromJson(v));
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

class ToolData {
  int? id;
  String? name;
  String? description;
  String? thumbnail;
  String? icon;
  String? createdAt;

  ToolData(
      {this.id,
        this.name,
        this.description,
        this.thumbnail,
        this.icon,
        this.createdAt});

  ToolData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    icon = json['icon'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['thumbnail'] = this.thumbnail;
    data['icon'] = this.icon;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
