class LoginModel {
  bool? statusError;
  int? statusCode;
  String? message;
  UserData? data;

  LoginModel({this.statusError, this.statusCode, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
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

class UserData {
  int? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  int? gender;
  String? dob;
  int? cityId;
  int? provinceId;
  bool? loginFinger;
  String? avatar;
  int? creditFundId;
  List<UserGroup>? userGroup;
  String? createdAt;
  String? accessToken;

  UserData(
      {this.id,
        this.name,
        this.username,
        this.email,
        this.phone,
        this.gender,
        this.dob,
        this.cityId,
        this.provinceId,
        this.loginFinger,
        this.avatar,
        this.creditFundId,
        this.userGroup,
        this.createdAt,
        this.accessToken});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    dob = json['dob'];
    cityId = json['city_id'];
    provinceId = json['province_id'];
    loginFinger = json['login_finger'];
    avatar = json['avatar'];
    creditFundId = json['credit_fund_id'];
    if (json['user_group'] != null) {
      userGroup = <UserGroup>[];
      json['user_group'].forEach((v) {
        userGroup!.add(new UserGroup.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    accessToken = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['city_id'] = this.cityId;
    data['province_id'] = this.provinceId;
    data['login_finger'] = this.loginFinger;
    data['avatar'] = this.avatar;
    data['credit_fund_id'] = this.creditFundId;
    if (this.userGroup != null) {
      data['user_group'] = this.userGroup!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['access_token'] = this.accessToken;
    return data;
  }
}

class UserGroup {
  int? id;
  String? name;
  String? code;
  String? description;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  UserGroup(
      {this.id,
        this.name,
        this.code,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.pivot});

  UserGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? new Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.pivot != null) {
      data['pivot'] = this.pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? userGroupId;

  Pivot({this.userId, this.userGroupId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userGroupId = json['user_group_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_group_id'] = this.userGroupId;
    return data;
  }
}
