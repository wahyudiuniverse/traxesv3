class ProjectRadiusResponseModel {
  int? status;
  String? message;
  List<DataProjectRadius>? data;

  ProjectRadiusResponseModel({this.status, this.message, this.data});

  ProjectRadiusResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataProjectRadius>[];
      json['data'].forEach((v) {
        data!.add(DataProjectRadius.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataProjectRadius {
  String? secid;
  String? projectId;
  String? projectName;
  String? projectRadius;

  DataProjectRadius({this.secid, this.projectId, this.projectName, this.projectRadius});

  DataProjectRadius.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    projectRadius = json['project_radius'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['project_id'] = projectId;
    data['project_name'] = projectName;
    data['project_radius'] = projectRadius;
    return data;
  }
}