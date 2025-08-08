class ResultAbsenceModel {
  int? status;
  String? message;
  List<ResultAbsenceData>? data;

  ResultAbsenceModel({this.status, this.message, this.data});

  ResultAbsenceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ResultAbsenceData>[];
      json['data'].forEach((v) {
        data!.add(ResultAbsenceData.fromJson(v));
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

class ResultAbsenceData {
  String? employeeId;
  String? firstName;
  String? cIo;
  String? radius;
  String? distance;
  String? dateat;
  String? timeat;
  String? latitude;
  String? longitude;
  String? foto;

  ResultAbsenceData(
      {this.employeeId,
      this.firstName,
      this.cIo,
      this.radius,
      this.distance,
      this.dateat,
      this.timeat,
      this.latitude,
      this.longitude,
      this.foto});

  ResultAbsenceData.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    firstName = json['first_name'];
    cIo = json['c_io'];
    radius = json['radius'];
    distance = json['distance'];
    dateat = json['dateat'];
    timeat = json['timeat'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['first_name'] = firstName;
    data['c_io'] = cIo;
    data['radius'] = radius;
    data['distance'] = distance;
    data['dateat'] = dateat;
    data['timeat'] = timeat;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['foto'] = foto;
    return data;
  }
}