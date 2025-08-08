class GetMbdDisplayResponseModel {
  int? status;
  String? message;
  List<DataDisplayMbd>? data;

  GetMbdDisplayResponseModel({this.status, this.message, this.data});

  GetMbdDisplayResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataDisplayMbd>[];
      json['data'].forEach((v) {
        data!.add(DataDisplayMbd.fromJson(v));
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

class DataDisplayMbd {
  String? employeeId;
  String? customerName;
  String? customerId;
  String? displayDate;
  String? displayInfo;
  String? displayFoto;
  String? verifyStatus;

  DataDisplayMbd(
      {this.employeeId,
      this.customerName,
      this.customerId,
      this.displayDate,
      this.displayInfo,
      this.displayFoto,
      this.verifyStatus});

  DataDisplayMbd.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerName = json['customer_name'];
    customerId = json['customer_id'];
    displayDate = json['display_date'];
    displayInfo = json['display_info'];
    displayFoto = json['display_foto'];
    verifyStatus = json['verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_name'] = customerName;
    data['customer_id'] = customerId;
    data['display_date'] = displayDate;
    data['display_info'] = displayInfo;
    data['display_foto'] = displayFoto;
    data['verify_status'] = verifyStatus;
    return data;
  }
}