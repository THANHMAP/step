class StoreDataTool {
  String? title;
  int? toolId;
  List<DataUsers>? dataUsers;

  StoreDataTool({this.title, this.toolId, this.dataUsers});

  StoreDataTool.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    toolId = json['tool_id'];
    if (json['data_users'] != null) {
      dataUsers = <DataUsers>[];
      json['data_users'].forEach((v) {
        dataUsers!.add(new DataUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['tool_id'] = this.toolId;
    if (this.dataUsers != null) {
      data['data_users'] = this.dataUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataUsers {
  String? key;
  String? value;
  int? type;

  DataUsers({this.key, this.value, this.type});

  DataUsers.fromJson(Map<String, dynamic> json) {
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
