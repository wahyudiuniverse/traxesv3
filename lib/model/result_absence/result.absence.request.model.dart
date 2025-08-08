class ResultAbsenceRequestModel {
  String? dateCio;
  String? employeeId;
  String? customerId;

  ResultAbsenceRequestModel({this.dateCio, this.employeeId, this.customerId});

  ResultAbsenceRequestModel.fromJson(Map<String, dynamic> json) {
    dateCio = json['date_cio'];
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date_cio'] = dateCio;
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    return data;
  }
}