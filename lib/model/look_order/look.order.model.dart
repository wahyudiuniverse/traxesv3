class LookOrderModel {
  int? status;
  String? message;
  List<LookOrderData>? data;

  LookOrderModel({this.status, this.message, this.data});

  LookOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LookOrderData>[];
      json['data'].forEach((v) {
        data!.add(LookOrderData.fromJson(v));
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

class LookOrderData {
  String? secid;
  String? customerId;
  String? employeeId;
  String? materialId;
  String? namaMaterial;
  String? orderDate;
  String? qty;
  String? price;
  String? total;

  LookOrderData(
      {this.secid,
      this.customerId,
      this.employeeId,
      this.materialId,
      this.namaMaterial,
      this.orderDate,
      this.qty,
      this.price,
      this.total});

  LookOrderData.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    customerId = json['customer_id'];
    employeeId = json['employee_id'];
    materialId = json['material_id'];
    namaMaterial = json['nama_material'];
    orderDate = json['order_date'];
    qty = json['qty'];
    price = json['price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['customer_id'] = customerId;
    data['employee_id'] = employeeId;
    data['material_id'] = materialId;
    data['nama_material'] = namaMaterial;
    data['order_date'] = orderDate;
    data['qty'] = qty;
    data['price'] = price;
    data['total'] = total;
    return data;
  }
}