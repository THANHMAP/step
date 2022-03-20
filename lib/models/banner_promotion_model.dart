class BannerPromotionModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<BannerPromotionData>? data;

  BannerPromotionModel(
      {this.statusError, this.statusCode, this.message, this.data});

  BannerPromotionModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerPromotionData>[];
      json['data'].forEach((v) {
        data!.add(new BannerPromotionData.fromJson(v));
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

class BannerPromotionData {
  int? id;
  String? name;
  int? lessonId;
  int? newId;
  int? toolId;
  String? linkWeb;
  String? thumbnail;
  String? createdAt;

  BannerPromotionData(
      {this.id,
        this.name,
        this.lessonId,
        this.newId,
        this.toolId,
        this.linkWeb,
        this.thumbnail,
        this.createdAt});

  BannerPromotionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lessonId = json['lesson_id'];
    newId = json['new_id'];
    toolId = json['tool_id'];
    linkWeb = json['link_web'];
    thumbnail = json['thumbnail'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lesson_id'] = this.lessonId;
    data['new_id'] = this.newId;
    data['tool_id'] = this.toolId;
    data['link_web'] = this.linkWeb;
    data['thumbnail'] = this.thumbnail;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
