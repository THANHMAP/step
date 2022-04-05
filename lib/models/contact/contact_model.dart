class ContactModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<ContactData>? data;

  ContactModel({this.statusError, this.statusCode, this.message, this.data});

  ContactModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ContactData>[];
      json['data'].forEach((v) {
        data!.add(new ContactData.fromJson(v));
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

class ContactData {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? workTime;
  String? email;
  String? lat;
  String? long;
  String? createdAt;

  ContactData(
      {this.id,
        this.name,
        this.address,
        this.phone,
        this.workTime,
        this.email,
        this.lat,
        this.long,
        this.createdAt});

  ContactData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    workTime = json['work_time'];
    email = json['email'];
    lat = json['lat'];
    long = json['long'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['work_time'] = this.workTime;
    data['email'] = this.email;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
