class HistoryOrderModel {
  int? status;
  String? message;
  List<DataHistoryOrder>? data;

  HistoryOrderModel({this.status, this.message, this.data});

  HistoryOrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataHistoryOrder>[];
      json['data'].forEach((v) {
        data!.add(DataHistoryOrder.fromJson(v));
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

class DataHistoryOrder {
  String? secid;
  String? customerId;
  String? customerName;
  String? employeeId;
  String? materialId;
  String? namaMaterial;
  String? poin;
  String? orderDate;
  String? qty;
  String? price;
  String? total;
  String? totalPoin;

  DataHistoryOrder(
      {this.secid,
      this.customerId,
      this.customerName,
      this.employeeId,
      this.materialId,
      this.namaMaterial,
      this.poin,
      this.orderDate,
      this.qty,
      this.price,
      this.total,
      this.totalPoin
      });

  DataHistoryOrder.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    employeeId = json['employee_id'];
    materialId = json['material_id'];
    namaMaterial = json['nama_material'];
    poin = json['poin'];
    orderDate = json['order_date'];
    qty = json['qty'];
    price = json['price'];
    total = json['total'];
    totalPoin = json['total_poin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['employee_id'] = employeeId;
    data['material_id'] = materialId;
    data['nama_material'] = namaMaterial;
    data['poin'] = poin;
    data['order_date'] = orderDate;
    data['qty'] = qty;
    data['price'] = price;
    data['total'] = total;
    data['total_poin'] = totalPoin;
    return data;
  }
}