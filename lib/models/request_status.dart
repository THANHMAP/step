class RequestStatus {
  bool? statusError;
  int? statusCode;
  String? message;

  RequestStatus({this.statusError, this.statusCode, this.message});

  RequestStatus.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_error'] = this.statusError;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}
