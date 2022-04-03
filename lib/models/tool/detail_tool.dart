import 'package:step_bank/models/tool/store_data_tool_model.dart';

class DetailTool {
  bool? statusError;
  int? statusCode;
  String? message;
  Data? data;

  DetailTool({this.statusError, this.statusCode, this.message, this.data});

  DetailTool.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  int? toolId;
  String? name;
  List<DataUsers>? dataUsers;
  String? createdAt;

  Data({this.id, this.toolId, this.name, this.dataUsers, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toolId = json['tool_id'];
    name = json['name'];
    if (json['data_users'] != null) {
      dataUsers = <DataUsers>[];
      json['data_users'].forEach((v) {
        dataUsers!.add(new DataUsers.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool_id'] = this.toolId;
    data['name'] = this.name;
    if (this.dataUsers != null) {
      data['data_users'] = this.dataUsers!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    return data;
  }
}

