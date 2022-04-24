class ItemTool {
  bool? statusError;
  int? statusCode;
  String? message;
  List<ItemToolData>? data;

  ItemTool({this.statusError, this.statusCode, this.message, this.data});

  ItemTool.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ItemToolData>[];
      json['data'].forEach((v) {
        data!.add(new ItemToolData.fromJson(v));
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

class ItemToolData {
  int? id;
  int? toolId;
  String? name;
  int? type;
  String? createdAt;

  ItemToolData({this.id, this.toolId, this.name, this.type, this.createdAt});

  ItemToolData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toolId = json['tool_id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tool_id'] = this.toolId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
