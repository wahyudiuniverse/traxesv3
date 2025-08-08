class UpdateStockModel {
  String? materialId;
  String? customerId;
  String? projectId;
  String? expDate;
  String? employeeId;
  String? stockQty;
  String? stockOut;
  String? stockDate;

  UpdateStockModel(
      {this.materialId,
      this.customerId,
      this.projectId,
      this.expDate,
      this.employeeId,
      this.stockQty,
      this.stockOut,
      this.stockDate});

  UpdateStockModel.fromJson(Map<String, dynamic> json) {
    materialId = json['material_id'];
    customerId = json['customer_id'];
    projectId = json['project_id'];
    expDate = json['exp_date'];
    employeeId = json['employee_id'];
    stockQty = json['stock_qty'];
    stockOut = json['stock_out'];
    stockDate = json['stock_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material_id'] = materialId;
    data['customer_id'] = customerId;
    data['project_id'] = projectId;
    data['exp_date'] = expDate;
    data['employee_id'] = employeeId;
    data['stock_qty'] = stockQty;
    data['stock_out'] = stockOut;
    data['stock_date'] = stockDate;
    return data;
  }
}