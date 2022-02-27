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
    data['createdAt'] = this.createdAt;
    data['access_token'] = this.accessToken;
    return data;
  }
}
