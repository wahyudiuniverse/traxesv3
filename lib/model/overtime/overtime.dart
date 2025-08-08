class OvertimeModel {
  String? employeeId;
  String? customerId;
  String? jabatanId;
  String? dateCio;
  String? projectId;
  String? statusEmp;
  String? datetimephoneIn;
  String? latitudeIn;
  String? longitudeIn;
  double? radiusIn;
  double? distanceIn;
  String? datetimephoneOut;
  String? latitudeOut;
  String? longitudeOut;
  double? radiusOut;
  double? distanceOut;
  String? keterangan;
  String? apk;
  String? fotoIn;

  OvertimeModel(
      {this.employeeId,
      this.customerId,
      this.jabatanId,
      this.dateCio,
      this.projectId,
      this.statusEmp,
      this.datetimephoneIn,
      this.latitudeIn,
      this.longitudeIn,
      this.radiusIn,
      this.distanceIn,
      this.datetimephoneOut,
      this.latitudeOut,
      this.longitudeOut,
      this.radiusOut,
      this.distanceOut,
      this.keterangan,
      this.apk,
      this.fotoIn});

  OvertimeModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    jabatanId = json['jabatan_id'];
    dateCio = json['date_cio'];
    projectId = json['project_id'];
    statusEmp = json['status_emp'];
    datetimephoneIn = json['datetimephone_in'];
    latitudeIn = json['latitude_in'];
    longitudeIn = json['longitude_in'];
    radiusIn = json['radius_in'];
    distanceIn = json['distance_in'];
    datetimephoneOut = json['datetimephone_out'];
    latitudeOut = json['latitude_out'];
    longitudeOut = json['longitude_out'];
    radiusOut = json['radius_out'];
    distanceOut = json['distance_out'];
    keterangan = json['keterangan'];
    apk = json['apk'];
    fotoIn = json['foto_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['jabatan_id'] = jabatanId;
    data['date_cio'] = dateCio;
    data['project_id'] = projectId;
    data['status_emp'] = statusEmp;
    data['datetimephone_in'] = datetimephoneIn;
    data['latitude_in'] = latitudeIn;
    data['longitude_in'] = longitudeIn;
    data['radius_in'] = radiusIn;
    data['distance_in'] = distanceIn;
    data['datetimephone_out'] = datetimephoneOut;
    data['latitude_out'] = latitudeOut;
    data['longitude_out'] = longitudeOut;
    data['radius_out'] = radiusOut;
    data['distance_out'] = distanceOut;
    data['keterangan'] = keterangan;
    data['apk'] = apk;
    data['foto_in'] = fotoIn;
    return data;
  }
}