class NextRepaymentDate {
  bool? statusError;
  int? statusCode;
  String? message;
  DataNextRepaymentDate? data;

  NextRepaymentDate(
      {this.statusError, this.statusCode, this.message, this.data});

  NextRepaymentDate.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new DataNextRepaymentDate.fromJson(json['data']) : null;
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

class DataNextRepaymentDate {
  String? nextRepaymentDate;

  DataNextRepaymentDate({this.nextRepaymentDate});

  DataNextRepaymentDate.fromJson(Map<String, dynamic> json) {
    nextRepaymentDate = json['next_repayment_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next_repayment_date'] = this.nextRepaymentDate;
    return data;
  }
}
