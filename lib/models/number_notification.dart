class NumberNotification {
  bool? statusError;
  int? statusCode;
  String? message;
  DataNumberNotification? data;

  NumberNotification(
      {this.statusError, this.statusCode, this.message, this.data});

  NumberNotification.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new DataNumberNotification.fromJson(json['data']) : null;
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

class DataNumberNotification {
  int? total;

  DataNumberNotification({this.total});

  DataNumberNotification.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}
