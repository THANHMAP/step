class SentOtpModel {
  bool? statusError;
  int? statusCode;
  String? message;

  SentOtpModel({this.statusError, this.statusCode, this.message});

  SentOtpModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status_error'] = statusError;
    data['status_code'] = statusCode;
    data['message'] = message;
    return data;
  }
}
