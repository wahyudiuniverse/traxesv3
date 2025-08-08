class SearchVillageModel {
  int? status;
  String? message;
  List<DataVillage>? data;

  SearchVillageModel({this.status, this.message, this.data});

  SearchVillageModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataVillage>[];
      json['data'].forEach((v) {
        data!.add(DataVillage.fromJson(v));
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

class DataVillage {
  String? villId;
  String? distId;
  String? cityId;
  String? villageName;

  DataVillage({this.villId, this.distId, this.cityId, this.villageName});

  DataVillage.fromJson(Map<String, dynamic> json) {
    villId = json['vill_id'];
    distId = json['dist_id'];
    cityId = json['city_id'];
    villageName = json['village_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vill_id'] = villId;
    data['dist_id'] = distId;
    data['city_id'] = cityId;
    data['village_name'] = villageName;
    return data;
  }
}