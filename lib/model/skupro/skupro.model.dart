class SkuProModel {
  int? status;
  String? message;
  List<DataSkuPro>? data;

  SkuProModel({this.status, this.message, this.data});

  SkuProModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataSkuPro>[];
      json['data'].forEach((v) {
        data!.add(DataSkuPro.fromJson(v));
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

class DataSkuPro {
  String? secid;
  String? kodeSku;
  String? barcode;
  String? namaMaterial;
  String? materialType;
  String? category;
  String? project;
  String? brand;
  String? variant;
  String? uom;
  String? price;
  String? priceSell;
  String? poin;
  String? volume;
  String? isActive;
  String? createdat;
  String? createdby;

  DataSkuPro(
      {this.secid,
      this.kodeSku,
      this.barcode,
      this.namaMaterial,
      this.materialType,
      this.category,
      this.project,
      this.brand,
      this.variant,
      this.uom,
      this.price,
      this.priceSell,
      this.poin,
      this.volume,
      this.isActive,
      this.createdat,
      this.createdby});

  DataSkuPro.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    kodeSku = json['kode_sku'];
    barcode = json['barcode'];
    namaMaterial = json['nama_material'];
    materialType = json['material_type'];
    category = json['category'];
    project = json['project'];
    brand = json['brand'];
    variant = json['variant'];
    uom = json['uom'];
    price = json['price'];
    priceSell = json['price_sell'];
    poin = json['poin'];
    volume = json['volume'];
    isActive = json['is_active'];
    createdat = json['createdat'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['kode_sku'] = kodeSku;
    data['barcode'] = barcode;
    data['nama_material'] = namaMaterial;
    data['material_type'] = materialType;
    data['category'] = category;
    data['project'] = project;
    data['brand'] = brand;
    data['variant'] = variant;
    data['uom'] = uom;
    data['price'] = price;
    data['price_sell'] = priceSell;
    data['poin'] = poin;
    data['volume'] = volume;
    data['is_active'] = isActive;
    data['createdat'] = createdat;
    data['createdby'] = createdby;
    return data;
  }
}