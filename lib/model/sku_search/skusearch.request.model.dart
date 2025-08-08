class SkuSearchRequestModel {
  String? keys;
  String? project;

  SkuSearchRequestModel({this.keys, this.project});

  SkuSearchRequestModel.fromJson(Map<String, dynamic> json) {
    keys = json['keys'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['keys'] = keys;
    data['project'] = project;
    return data;
  }
}