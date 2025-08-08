class CallplanRequestModel {
  String? employeeId;
  String? dateCallplan;

  CallplanRequestModel({this.employeeId, this.dateCallplan});

  CallplanRequestModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    dateCallplan = json['date_callplan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['date_callplan'] = dateCallplan;
    return data;
  }
}