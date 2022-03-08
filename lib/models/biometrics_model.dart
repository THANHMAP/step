class BiometricsData {
  bool? isActivated = false;
  String? phone;
  String? password;

  BiometricsData({this.isActivated, this.phone, this.password});

  BiometricsData.fromJson(Map<String, dynamic> json) {
    isActivated = json['is_activated'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_activated'] = isActivated;
    data['phone'] = phone;
    data['password'] = password;
    return data;
  }
}
