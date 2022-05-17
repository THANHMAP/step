class DetailReportModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<DetailReportData>? data;

  DetailReportModel(
      {this.statusError, this.statusCode, this.message, this.data});

  DetailReportModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DetailReportData>[];
      json['data'].forEach((v) {
        data!.add(new DetailReportData.fromJson(v));
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

class DetailReportData {
  String? withDraw;
  String? deposit;
  String? note;

  DetailReportData({this.withDraw, this.deposit, this.note});

  DetailReportData.fromJson(Map<String, dynamic> json) {
    withDraw = json['with_draw'];
    deposit = json['deposit'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['with_draw'] = this.withDraw;
    data['deposit'] = this.deposit;
    data['note'] = this.note;
    return data;
  }
}
