class SearchVillageRequestModel {
  String? keys;

  SearchVillageRequestModel({this.keys});

  SearchVillageRequestModel.fromJson(Map<String, dynamic> json) {
    keys = json['keys'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keys'] = keys;
    return data;
  }
}