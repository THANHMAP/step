class NotificationModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<NotificationData>? data;

  NotificationModel(
      {this.statusError, this.statusCode, this.message, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
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

class NotificationData {
  int? id;
  String? title;
  String? type;
  ItemData? data;
  String? createdAt;

  NotificationData({this.id, this.title, this.type, this.data, this.createdAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    data = json['data'] != null ? new ItemData.fromJson(json['data']) : null;
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class ItemData {
  int? newId;
  int? userToolId;

  ItemData({this.newId, this.userToolId});

  ItemData.fromJson(Map<String, dynamic> json) {
    newId = json['new_id'];
    userToolId = json['user_tool_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['new_id'] = this.newId;
    data['user_tool_id'] = this.userToolId;
    return data;
  }
}
