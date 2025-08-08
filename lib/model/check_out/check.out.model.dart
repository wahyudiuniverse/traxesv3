class CheckOutModel {
  String? employeeId;
  String? customerId;
  String? dateCio;
  String? datetimephoneOut;
  String? latitudeOut;
  String? longitudeOut;
  int? radiusOut;
  double? distanceOut;
  String? fotoOut;
  String? statusToko;

  CheckOutModel(
      {this.employeeId,
      this.customerId,
      this.dateCio,
      this.datetimephoneOut,
      this.latitudeOut,
      this.longitudeOut,
      this.radiusOut,
      this.distanceOut,
      this.fotoOut,
      this.statusToko
      });

  CheckOutModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    dateCio = json['date_cio'];
    datetimephoneOut = json['datetimephone_out'];
    latitudeOut = json['latitude_out'];
    longitudeOut = json['longitude_out'];
    radiusOut = json['radius_out'];
    distanceOut = json['distance_out'];
    fotoOut = json['foto_out'];
    statusToko = json['status_toko'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['date_cio'] = dateCio;
    data['datetimephone_out'] = datetimephoneOut;
    data['latitude_out'] = latitudeOut;
    data['longitude_out'] = longitudeOut;
    data['radius_out'] = radiusOut;
    data['distance_out'] = distanceOut;
    data['foto_out'] = fotoOut;
    data['status_toko'] = statusToko;
    return data;
  }
}