class HistoryOrderRequestModel {
  String? employeeId;
  String? dateCio;

  HistoryOrderRequestModel({this.employeeId, this.dateCio});

  HistoryOrderRequestModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    dateCio = json['date_cio'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['date_cio'] = dateCio;
    return data;
  }
}