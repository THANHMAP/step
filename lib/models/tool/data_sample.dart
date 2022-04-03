class DataSampleTool {
  bool? statusError;
  int? statusCode;
  String? message;
  List<SampleToolData>? data;

  DataSampleTool({this.statusError, this.statusCode, this.message, this.data});

  DataSampleTool.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SampleToolData>[];
      json['data'].forEach((v) {
        data!.add(new SampleToolData.fromJson(v));
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

class SampleToolData {
  int? id;
  String? name;
  int? type;
  String? createdAt;

  SampleToolData({this.id, this.name, this.type, this.createdAt});

  SampleToolData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
