class UpdateDataTool {
  String? title;
  int? userToolId;
  int? type;
  List<UpdateDataToolUsers>? dataUsers;

  UpdateDataTool({this.title, this.userToolId, this.type, this.dataUsers});

  UpdateDataTool.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    userToolId = json['user_tool_id'];
    type = json['type'];
    if (json['data_users'] != null) {
      dataUsers = <UpdateDataToolUsers>[];
      json['data_users'].forEach((v) {
        dataUsers!.add(new UpdateDataToolUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['user_tool_id'] = this.userToolId;
    data['type'] = this.type;
    if (this.dataUsers != null) {
      data['data_users'] = this.dataUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UpdateDataToolUsers {
  String? key;
  String? value;
  int? type;

  UpdateDataToolUsers({this.key, this.value, this.type});

  UpdateDataToolUsers.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}
