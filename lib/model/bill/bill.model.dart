class BillModel {
  String? employeeId;
  String? customerId;
  String? bill;
  String? bill2;
  String? bill3;
  String? createdAt;

  BillModel(
      {this.employeeId,
      this.customerId,
      this.bill,
      this.bill2,
      this.bill3,
      this.createdAt});

  BillModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    bill = json['bill'];
    bill2 = json['bill2'];
    bill3 = json['bill3'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['bill'] = bill;
    data['bill2'] = bill2;
    data['bill3'] = bill3;
    data['created_at'] = createdAt;
    return data;
  }
}