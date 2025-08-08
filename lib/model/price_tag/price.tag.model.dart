class PriceTagModel {
  String? materialId;
  String? employeeId;
  String? customerId;
  int? price;
  String? foto;
  String? createdAt;

  PriceTagModel(
      {this.materialId,
      this.employeeId,
      this.customerId,
      this.price,
      this.foto,
      this.createdAt});

  PriceTagModel.fromJson(Map<String, dynamic> json) {
    materialId = json['material_id'];
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    price = json['price'];
    foto = json['foto'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material_id'] = materialId;
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['price'] = price;
    data['foto'] = foto;
    data['created_at'] = createdAt;
    return data;
  }
}