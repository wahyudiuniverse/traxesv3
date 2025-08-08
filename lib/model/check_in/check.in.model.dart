class CheckInV2Model {
  String? employeeId;
  String? customerId;
  int? projectId;
  String? dateCio;
  int? jabatanId;
  String? datetimephoneIn;
  String? latitudeIn;
  String? longitudeIn;
  int? radiusIn;
  double? distanceIn;
  String? fotoIn;
  int? statusEmp;
  String? keterangan;
  String? reason;
  int? statusTransport;
  int? updateToko;

  CheckInV2Model(
      {this.employeeId,
      this.customerId,
      this.projectId,
      this.dateCio,
      this.jabatanId,
      this.datetimephoneIn,
      this.latitudeIn,
      this.longitudeIn,
      this.radiusIn,
      this.distanceIn,
      this.fotoIn,
      this.statusEmp,
      this.keterangan,
      this.reason,
      this.statusTransport,
      this.updateToko
      });

  CheckInV2Model.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    projectId = json['project_id'];
    dateCio = json['date_cio'];
    jabatanId = json['jabatan_id'];
    datetimephoneIn = json['datetimephone_in'];
    latitudeIn = json['latitude_in'];
    longitudeIn = json['longitude_in'];
    radiusIn = json['radius_in'];
    distanceIn = json['distance_in'];
    fotoIn = json['foto_in'];
    statusEmp = json['status_emp'];
    keterangan = json['keterangan'];
    reason = json['reason'];
    statusTransport = json['status_transport'];
    updateToko = json['update_toko'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['project_id'] = projectId;
    data['date_cio'] = dateCio;
    data['jabatan_id'] = jabatanId;
    data['datetimephone_in'] = datetimephoneIn;
    data['latitude_in'] = latitudeIn;
    data['longitude_in'] = longitudeIn;
    data['radius_in'] = radiusIn;
    data['distance_in'] = distanceIn;
    data['foto_in'] = fotoIn;
    data['status_emp'] = statusEmp;
    data['keterangan'] = keterangan;
    data['reason'] = reason;
    data['status_transport'] = statusTransport;
    data['update_toko'] = updateToko;
    return data;
  }
}
