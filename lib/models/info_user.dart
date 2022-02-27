class InfoUserModel {
  String? username;
  String? email;
  String? updatedAt;
  String? createdAt;
  int? id;
  bool? isActivated;
  String? token;
  String? avatar;

  InfoUserModel(
      {this.username,
        this.email,
        this.updatedAt,
        this.createdAt,
        this.id,
        this.isActivated,
        this.token,
        this.avatar});

  InfoUserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    isActivated = json['is_activated'];
    token = json['token'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = username;
    data['email'] = email;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    data['is_activated'] = isActivated;
    data['token'] = token;
    data['avatar'] = avatar;
    return data;
  }
}