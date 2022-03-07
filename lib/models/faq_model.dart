class FAQModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<FAQData>? data;

  FAQModel({this.statusError, this.statusCode, this.message, this.data});

  FAQModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FAQData>[];
      json['data'].forEach((v) {
        data!.add(new FAQData.fromJson(v));
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

class FAQData {
  int? id;
  String? question;
  String? answer;
  String? createdAt;

  FAQData({this.id, this.question, this.answer, this.createdAt});

  FAQData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
