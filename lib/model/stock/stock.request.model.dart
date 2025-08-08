class StockRequestModel {
  String? customerId;
  String? projectId;
  String? stockDate;
  String? employeeId;

  StockRequestModel(
      {this.customerId, this.projectId, this.stockDate, this.employeeId});

  StockRequestModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    projectId = json['project_id'];
    stockDate = json['stock_date'];
    employeeId = json['employee_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['project_id'] = projectId;
    data['stock_date'] = stockDate;
    data['employee_id'] = employeeId;
    return data;
  }
}