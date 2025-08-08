class SearchRequestModel {
  String? keys;

  SearchRequestModel({this.keys});

  SearchRequestModel.fromJson(Map<String, dynamic> json) {
    keys = json['keys'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keys'] = keys;
    return data;
  }
}