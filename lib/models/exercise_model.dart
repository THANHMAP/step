class ExerciseModel {
  bool? statusError;
  int? statusCode;
  String? message;
  List<ExerciseData>? data;

  ExerciseModel({this.statusError, this.statusCode, this.message, this.data});

  ExerciseModel.fromJson(Map<String, dynamic> json) {
    statusError = json['status_error'];
    statusCode = json['status_code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExerciseData>[];
      json['data'].forEach((v) {
        data!.add(new ExerciseData.fromJson(v));
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

class ExerciseData {
  int? id;
  String? name;
  String? fileExercise;

  ExerciseData({this.id, this.name, this.fileExercise});

  ExerciseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    fileExercise = json['file_exercise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['file_exercise'] = this.fileExercise;
    return data;
  }
}
