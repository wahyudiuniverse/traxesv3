class SkuSearchModel {
  int? status;
  String? message;
  List<DataSkuSearch>? data;

  SkuSearchModel({this.status, this.message, this.data});

  SkuSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataSkuSearch>[];
      json['data'].forEach((v) {
        data!.add(DataSkuSearch.fromJson(v));
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

class DataSkuSearch {
  String? secid;
  String? kodeSku;
  String? namaMaterial;
  String? materialType;
  String? category;
  String? project;
  String? brand;
  String? variant;
  String? uom;
  String? price;
  String? createdat;
  String? createdby;

  DataSkuSearch(
      {this.secid,
      this.kodeSku,
      this.namaMaterial,
      this.materialType,
      this.category,
      this.project,
      this.brand,
      this.variant,
      this.uom,
      this.price,
      this.createdat,
      this.createdby});

  DataSkuSearch.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    kodeSku = json['kode_sku'];
    namaMaterial = json['nama_material'];
    materialType = json['material_type'];
    category = json['category'];
    project = json['project'];
    brand = json['brand'];
    variant = json['variant'];
    uom = json['uom'];
    price = json['price'];
    createdat = json['createdat'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['kode_sku'] = kodeSku;
    data['nama_material'] = namaMaterial;
    data['material_type'] = materialType;
    data['category'] = category;
    data['project'] = project;
    data['brand'] = brand;
    data['variant'] = variant;
    data['uom'] = uom;
    data['price'] = price;
    data['createdat'] = createdat;
    data['createdby'] = createdby;
    return data;
  }
}