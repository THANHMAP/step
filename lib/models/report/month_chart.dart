class MonthChartModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<MonthChartData>? data;

  MonthChartModel({this.statusError, this.statusCode, this.message, this.data});

  MonthChartModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MonthChartData>[];
      json['data'].forEach((v) {
        data!.add(new MonthChartData.fromJson(v));
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

class MonthChartData {
  int? month;
  int? totalWithDraw;
  int? totalDeposit;

  MonthChartData({this.month, this.totalWithDraw, this.totalDeposit});

  MonthChartData.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    totalWithDraw = json['total_with_draw'];
    totalDeposit = json['total_deposit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this.month;
    data['total_with_draw'] = this.totalWithDraw;
    data['total_deposit'] = this.totalDeposit;
    return data;
  }
}
