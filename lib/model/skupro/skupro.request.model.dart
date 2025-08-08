class SkuProRequestModel {
  String? projectid;
  String? subprojectid;

  SkuProRequestModel({this.projectid, this.subprojectid});

  SkuProRequestModel.fromJson(Map<String, dynamic> json) {
    projectid = json['projectid'];
    subprojectid = json['subprojectid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['projectid'] = projectid;
    data['subprojectid'] = subprojectid;
    return data;
  }
}