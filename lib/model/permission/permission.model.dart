class PermissionModel {
  String? nik;
  String? customerid;
  String? keterangan;
  int? cio;
  String? cioDate;
  String? datetimePhone;
  String? projectId;
  String? latitude;
  String? longitude;
  double? distance;
  String? foto;

  PermissionModel(
      {this.nik,
      this.customerid,
      this.keterangan,
      this.cio,
      this.cioDate,
      this.datetimePhone,
      this.projectId,
      this.latitude,
      this.longitude,
      this.distance,
      this.foto});

  PermissionModel.fromJson(Map<String, dynamic> json) {
    nik = json['nik'];
    customerid = json['customerid'];
    keterangan = json['keterangan'];
    cio = json['cio'];
    cioDate = json['cio_date'];
    datetimePhone = json['datetime_phone'];
    projectId = json['project_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    distance = json['distance'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nik'] = nik;
    data['customerid'] = customerid;
    data['keterangan'] = keterangan;
    data['cio'] = cio;
    data['cio_date'] = cioDate;
    data['datetime_phone'] = datetimePhone;
    data['project_id'] = projectId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['distance'] = distance;
    data['foto'] = foto;
    return data;
  }
}