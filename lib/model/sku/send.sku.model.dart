class SendSkuModel {
  String? customerId;
  String? employeeId;
  String? materialId;
  String? orderDate;
  String? qty;
  int? price;
  int? total;
  String? createdby;

  SendSkuModel(
      {this.customerId,
      this.employeeId,
      this.materialId,
      this.orderDate,
      this.qty,
      this.price,
      this.total,
      this.createdby});

  SendSkuModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    employeeId = json['employee_id'];
    materialId = json['material_id'];
    orderDate = json['order_date'];
    qty = json['qty'];
    price = json['price'];
    total = json['total'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['employee_id'] = employeeId;
    data['material_id'] = materialId;
    data['order_date'] = orderDate;
    data['qty'] = qty;
    data['price'] = price;
    data['total'] = total;
    data['createdby'] = createdby;
    return data;
  }
}