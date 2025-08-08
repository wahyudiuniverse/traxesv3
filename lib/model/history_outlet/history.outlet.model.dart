class HistoryOutletModel {
  int? status;
  String? message;
  List<DataHistoryOutlet>? data;

  HistoryOutletModel({this.status, this.message, this.data});

  HistoryOutletModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataHistoryOutlet>[];
      json['data'].forEach((v) {
        data!.add(DataHistoryOutlet.fromJson(v));
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

class DataHistoryOutlet {
  String? customerId;
  String? customerName;
  String? address;
  String? latitude;
  String? longitude;
  String? villageId;
  String? vilName;
  String? districtId;
  String? distName;
  String? cityId;
  String? cityName;
  String? dista;
  String? photo;
  String? verify;
  String? date;

  DataHistoryOutlet(
      {this.customerId,
      this.customerName,
      this.address,
      this.latitude,
      this.longitude,
      this.villageId,
      this.vilName,
      this.districtId,
      this.distName,
      this.cityId,
      this.cityName,
      this.dista,
      this.photo,
      this.verify,
      this.date
      });

  DataHistoryOutlet.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    villageId = json['village_id'];
    vilName = json['vil_name'];
    districtId = json['district_id'];
    distName = json['dist_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    dista = json['dista'];
    photo = json['photo'];
    verify = json['verify'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['village_id'] = villageId;
    data['vil_name'] = vilName;
    data['district_id'] = districtId;
    data['dist_name'] = distName;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['dista'] = dista;
    data['photo'] = photo;
    data['verify'] = verify;
    data['date'] = date;
    return data;
  }
}