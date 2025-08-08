class SearchModel {
  int? status;
  String? message;
  List<DataSearch>? data;

  SearchModel({this.status, this.message, this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DataSearch>[];
      json['data'].forEach((v) {
        data!.add(DataSearch.fromJson(v));
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

class DataSearch {
  String? secid;
  String? customerId;
  String? customerName;
  String? ownerName;
  String? noContact;
  String? address;
  String? villageId;
  String? districtId;
  String? cityId;
  String? photo;
  String? latitude;
  String? longitude;
  String? createdon;
  String? createdby;
  String? verify;

  DataSearch(
      {this.secid,
      this.customerId,
      this.customerName,
      this.ownerName,
      this.noContact,
      this.address,
      this.villageId,
      this.districtId,
      this.cityId,
      this.photo,
      this.latitude,
      this.longitude,
      this.createdon,
      this.createdby,
      this.verify,
      });

  DataSearch.fromJson(Map<String, dynamic> json) {
    secid = json['secid'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    ownerName = json['owner_name'];
    noContact = json['no_contact'];
    address = json['address'];
    villageId = json['village_id'];
    districtId = json['district_id'];
    cityId = json['city_id'];
    photo = json['photo'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdon = json['createdon'];
    createdby = json['createdby'];
    verify = json['verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secid'] = secid;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['owner_name'] = ownerName;
    data['no_contact'] = noContact;
    data['address'] = address;
    data['village_id'] = villageId;
    data['district_id'] = districtId;
    data['city_id'] = cityId;
    data['photo'] = photo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdon'] = createdon;
    data['createdby'] = createdby;
    data['verify'] = verify;
    return data;
  }
}