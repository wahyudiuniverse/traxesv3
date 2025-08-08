class ProjectRadiusRequestModel {
  String? projectId;

  ProjectRadiusRequestModel({this.projectId});

  ProjectRadiusRequestModel.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['project_id'] = projectId;
    return data;
  }
}