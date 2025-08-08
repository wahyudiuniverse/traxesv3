class FilterMbdModel {
  int? status;
  String? message;
  List<DataFilterMbd>? data;

  FilterMbdModel({this.status, this.message, this.data});

  FilterMbdModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataFilterMbd>[];
      json['data'].forEach((v) {
        data!.add( DataFilterMbd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataFilterMbd {
  String? secid;
  String? customerName;
  String? customerId;
  String? employeeId;
  String? projectId;
  String? displayDate;
  String? displayFoto;
  String? verifyStatus;
  String? statusDisplay;
  String? createdOn;

  DataFilterMbd(
      {this.secid,
      this.customerName,
      this.customerId,
      this.employeeId,
      this.projectId,
      this.displayDate,
      this.displayFoto,
      this.verifyStatus,
      this.statusDisplay,
      this.createdOn
      });

  DataFilterMbd.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    customerName = json['customer_name'];
    customerId = json['customer_id'];
    employeeId = json['employee_id'];
    projectId = json['project_id'];
    displayDate = json['display_date'];
    displayFoto = json['display_foto'];
    verifyStatus = json['verify_status'];
    statusDisplay = json['status_display'];
    createdOn = json['createdon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['customer_name'] = customerName;
    data['customer_id'] = customerId;
    data['employee_id'] = employeeId;
    data['project_id'] = projectId;
    data['display_date'] = displayDate;
    data['display_foto'] = displayFoto;
    data['verify_status'] = verifyStatus;
    data['status_display'] = statusDisplay;
    data['createdon'] = createdOn;
    return data;
  }
}