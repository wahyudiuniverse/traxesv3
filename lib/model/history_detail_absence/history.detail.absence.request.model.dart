class HistoryDetailRequestModel {
  String? employeeId;
  String? customerId;
  String? dateCio;

  HistoryDetailRequestModel({this.employeeId, this.customerId, this.dateCio});

  HistoryDetailRequestModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    dateCio = json['date_cio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['date_cio'] = dateCio;
    return data;
  }
}