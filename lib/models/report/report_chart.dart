class ReportChartModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<ReportChartData>? data;

  ReportChartModel(
      {this.statusError, this.statusCode, this.message, this.data});

  ReportChartModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReportChartData>[];
      json['data'].forEach((v) {
        data!.add(new ReportChartData.fromJson(v));
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

class ReportChartData {
  String? startDate;
  String? endDate;
  int? totalWithDraw;
  int? totalDeposit;

  ReportChartData({this.startDate, this.endDate, this.totalWithDraw, this.totalDeposit});

  ReportChartData.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    totalWithDraw = json['total_with_draw'];
    totalDeposit = json['total_deposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['total_with_draw'] = this.totalWithDraw;
    data['total_deposit'] = this.totalDeposit;
    return data;
  }
}
