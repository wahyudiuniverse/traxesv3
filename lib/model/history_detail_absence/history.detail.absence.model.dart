class HistoryDetailModel {
  int? status;
  String? message;
  List<DetailAbsenceData>? data;

  HistoryDetailModel({this.status, this.message, this.data});

  HistoryDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DetailAbsenceData>[];
      json['data'].forEach((v) {
        data!.add(DetailAbsenceData.fromJson(v));
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

class DetailAbsenceData {
  String? employeeId;
  String? fullname;
  String? jabatan;
  String? projectName;
  String? dateCio;
  String? statusEmp;
  String? customerId;
  String? customerName;
  String? address;
  String? datetimephoneIn;
  String? latitudeIn;
  String? longitudeIn;
  String? distanceIn;
  String? fotoin;
  String? datetimephoneOut;
  String? latitudeOut;
  String? longitudeOut;
  String? distanceOut;
  String? fotoout;

  DetailAbsenceData(
      {this.employeeId,
      this.fullname,
      this.jabatan,
      this.projectName,
      this.dateCio,
      this.statusEmp,
      this.customerId,
      this.customerName,
      this.address,
      this.datetimephoneIn,
      this.latitudeIn,
      this.longitudeIn,
      this.distanceIn,
      this.fotoin,
      this.datetimephoneOut,
      this.latitudeOut,
      this.longitudeOut,
      this.distanceOut,
      this.fotoout});

  DetailAbsenceData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    fullname = json['fullname'];
    jabatan = json['jabatan'];
    projectName = json['project_name'];
    dateCio = json['date_cio'];
    statusEmp = json['status_emp'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    address = json['address'];
    datetimephoneIn = json['datetimephone_in'];
    latitudeIn = json['latitude_in'];
    longitudeIn = json['longitude_in'];
    distanceIn = json['distance_in'];
    fotoin = json['fotoin'];
    datetimephoneOut = json['datetimephone_out'];
    latitudeOut = json['latitude_out'];
    longitudeOut = json['longitude_out'];
    distanceOut = json['distance_out'];
    fotoout = json['fotoout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['fullname'] = fullname;
    data['jabatan'] = jabatan;
    data['project_name'] = projectName;
    data['date_cio'] = dateCio;
    data['status_emp'] = statusEmp;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['address'] = address;
    data['datetimephone_in'] = datetimephoneIn;
    data['latitude_in'] = latitudeIn;
    data['longitude_in'] = longitudeIn;
    data['distance_in'] = distanceIn;
    data['fotoin'] = fotoin;
    data['datetimephone_out'] = datetimephoneOut;
    data['latitude_out'] = latitudeOut;
    data['longitude_out'] = longitudeOut;
    data['distance_out'] = distanceOut;
    data['fotoout'] = fotoout;
    return data;
  }
}