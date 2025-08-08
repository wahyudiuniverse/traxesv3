class StockModel {
  int? status;
  String? message;
  List<StockData>? data;

  StockModel({this.status, this.message, this.data});

  StockModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StockData>[];
      json['data'].forEach((v) {
        data!.add(StockData.fromJson(v));
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

class StockData {
  String? secid;
  String? materialId;
  String? namaMaterial;
  String? customerId;
  String? customerName;
  String? projectId;
  String? stockDate;
  String? stockQty;
  String? stockOut;
  String? expDate;

  StockData(
      {this.secid,
      this.materialId,
      this.namaMaterial,
      this.customerId,
      this.customerName,
      this.projectId,
      this.stockDate,
      this.stockQty,
      this.stockOut,
      this.expDate});

  StockData.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    materialId = json['material_id'];
    namaMaterial = json['nama_material'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    projectId = json['project_id'];
    stockDate = json['stock_date'];
    stockQty = json['stock_qty'];
    stockOut = json['stock_out'];
    expDate = json['exp_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['material_id'] = materialId;
    data['nama_material'] = namaMaterial;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['project_id'] = projectId;
    data['stock_date'] = stockDate;
    data['stock_qty'] = stockQty;
    data['stock_out'] = stockOut;
    data['exp_date'] = expDate;
    return data;
  }
}