class ToolLastUsed {
  bool? statusError;
  int? statusCode;
  String? message;
  List<DataToolUsed>? data;

  ToolLastUsed({this.statusError, this.statusCode, this.message, this.data});

  ToolLastUsed.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataToolUsed>[];
      json['data'].forEach((v) {
        data!.add(new DataToolUsed.fromJson(v));
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

class DataToolUsed {
  int? id;
  int? toolId;
  String? toolName;
  String? toolThumbnail;
  String? toolIcon;
  String? name;
  int? type;
  String? createdAt;

  DataToolUsed(
      {this.id,
        this.toolId,
        this.toolName,
        this.toolThumbnail,
        this.toolIcon,
        this.name,
        this.type,
        this.createdAt});

  DataToolUsed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toolId = json['tool_id'];
    toolName = json['tool_name'];
    toolThumbnail = json['tool_thumbnail'];
    toolIcon = json['tool_icon'];
    name = json['name'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool_id'] = this.toolId;
    data['tool_name'] = this.toolName;
    data['tool_thumbnail'] = this.toolThumbnail;
    data['tool_icon'] = this.toolIcon;
    data['name'] = this.name;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
