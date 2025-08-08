class PriceTagDataModel {
  int? status;
  String? message;
  List<PriceTagData>? data;

  PriceTagDataModel({this.status, this.message, this.data});

  PriceTagDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PriceTagData>[];
      json['data'].forEach((v) {
        data!.add(PriceTagData.fromJson(v));
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

class PriceTagData {
  String? secid;
  String? materialId;
  String? namaMaterial;
  String? price;
  String? foto;

  PriceTagData({this.secid, this.materialId, this.price, this.foto});

  PriceTagData.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    materialId = json['material_id'];
    namaMaterial = json['nama_material'];
    price = json['price'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['material_id'] = materialId;
    data['nama_material'] = namaMaterial;
    data['price'] = price;
    data['foto'] = foto;
    return data;
  }
}