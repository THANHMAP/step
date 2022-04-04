class PositionLeaderModel {
  bool? statusError;
  int? statusCode;
  String? message;
  PositionLeaderData? data;

  PositionLeaderModel(
      {this.statusError, this.statusCode, this.message, this.data});

  PositionLeaderModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? new PositionLeaderData.fromJson(json['data']) : null;
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

class PositionLeaderData {
  int? position;
  int? score;
  String? name;
  String? avatar;

  PositionLeaderData({this.position, this.score, this.name, this.avatar});

  PositionLeaderData.fromJson(Map<String, dynamic> json) {
    position = json['position'];
    score = json['score'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['score'] = this.score;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
