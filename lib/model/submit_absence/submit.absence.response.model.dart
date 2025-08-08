// class ResponseSubmitAbsenceModel {
//   int? nik;
//   String? customerid;
//   int? cio;
//   String? cioDate;
//   String? datetimePhone;
//   String? projectId;
//   String? latitude;
//   String? longitude;
//   double? distance;
//   String? foto;

//   ResponseSubmitAbsenceModel(
//       {this.nik,
//       this.customerid,
//       this.cio,
//       this.cioDate,
//       this.datetimePhone,
//       this.projectId,
//       this.latitude,
//       this.longitude,
//       this.distance,
//       this.foto});

//   ResponseSubmitAbsenceModel.fromJson(Map<String, dynamic> json) {
//     nik = json['nik'];
//     customerid = json['customerid'];
//     cio = json['cio'];
//     cioDate = json['cio_date'];
//     datetimePhone = json['datetime_phone'];
//     projectId = json['project_id'];
//     latitude = json['latitude'];
//     longitude = json['longitude'];
//     distance = json['distance'];
//     foto = json['foto'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['nik'] = nik;
//     data['customerid'] = customerid;
//     data['cio'] = cio;
//     data['cio_date'] = cioDate;
//     data['datetime_phone'] = datetimePhone;
//     data['project_id'] = projectId;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     data['distance'] = distance;
//     data['foto'] = foto;
//     return data;
//   }
// }