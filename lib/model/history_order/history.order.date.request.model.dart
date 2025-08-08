class HistoryOrderDateRequestModel {
  String? employeeId;
  String? firstDate;
  String? lastDate;

  HistoryOrderDateRequestModel(
      {this.employeeId, this.firstDate, this.lastDate});

  HistoryOrderDateRequestModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    firstDate = json['first_date'];
    lastDate = json['last_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['first_date'] = firstDate;
    data['last_date'] = lastDate;
    return data;
  }
}