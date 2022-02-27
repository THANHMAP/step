class NewsModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<NewsData>? data;

  NewsModel({this.statusError, this.statusCode, this.message, this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NewsData>[];
      json['data'].forEach((v) {
        data!.add(new NewsData.fromJson(v));
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

class NewsData {
  int? id;
  String? name;
  String? description;
  String? content;
  String? thumbnail;
  String? createdAt;

  NewsData(
      {this.id,
        this.name,
        this.description,
        this.content,
        this.thumbnail,
        this.createdAt});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    content = json['content'];
    thumbnail = json['thumbnail'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['content'] = this.content;
    data['thumbnail'] = this.thumbnail;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
