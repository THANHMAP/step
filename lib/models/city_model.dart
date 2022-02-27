class CityModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<CityData>? data;

  CityModel({this.statusError, this.statusCode, this.message, this.data});

  CityModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CityData>[];
      json['data'].forEach((v) {
        data!.add(new CityData.fromJson(v));
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

class CityData {
  int? id;
  String? name;
  String? slug;
  List<Provinces>? provinces;

  CityData({this.id, this.name, this.slug, this.provinces});

  CityData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    if (json['provinces'] != null) {
      provinces = <Provinces>[];
      json['provinces'].forEach((v) {
        provinces!.add(new Provinces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    if (this.provinces != null) {
      data['provinces'] = this.provinces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Provinces {
  String? id;
  String? name;
  List<Wards>? wards;

  Provinces({this.id, this.name, this.wards});

  Provinces.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['wards'] != null) {
      wards = <Wards>[];
      json['wards'].forEach((v) {
        wards!.add(new Wards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.wards != null) {
      data['wards'] = this.wards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Wards {
  String? id;
  String? name;

  Wards({this.id, this.name});

  Wards.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
