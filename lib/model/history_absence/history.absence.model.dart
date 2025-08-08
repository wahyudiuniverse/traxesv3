class HistoryAbsenceModel {
  int? status;
  String? message;
  List<DataHistoryAbsence>? data;

  HistoryAbsenceModel({this.status, this.message, this.data});

  HistoryAbsenceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataHistoryAbsence>[];
      json['data'].forEach((v) {
        data!.add(DataHistoryAbsence.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataHistoryAbsence {
  String? secid;
  String? employeeId;
  String? customerId;
  String? dateCio;
  String? customerName;
  String? datetimephoneIn;
  String? datetimephoneOut;
  String? statusEmp;

  DataHistoryAbsence(
      {this.secid,
      this.employeeId,
      this.customerId,
      this.dateCio,
      this.customerName,
      this.datetimephoneIn,
      this.datetimephoneOut,
      this.statusEmp});

  DataHistoryAbsence.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    dateCio = json['date_cio'];
    customerName = json['customer_name'];
    datetimephoneIn = json['datetimephone_in'];
    datetimephoneOut = json['datetimephone_out'];
    statusEmp = json['status_emp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['date_cio'] = dateCio;
    data['customer_name'] = customerName;
    data['datetimephone_in'] = datetimephoneIn;
    data['datetimephone_out'] = datetimephoneOut;
    data['status_emp'] = statusEmp;
    return data;
 
 }
}