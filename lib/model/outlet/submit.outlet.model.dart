class SubmitOutletModel {
  String? customerId;
  String? customerName;
  String? ownerName;
  String? noContact;
  String? address;
  int? villageId;
  String? districtId;
  String? cityId;
  String? latitude;
  String? longitude;
  int? category;
  String? photo;
  String? createdby;

  SubmitOutletModel(
      {this.customerId,
      this.customerName,
      this.ownerName,
      this.noContact,
      this.address,
      this.villageId,
      this.districtId,
      this.cityId,
      this.latitude,
      this.longitude,
      this.category,
      this.photo,
      this.createdby});

  SubmitOutletModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    ownerName = json['owner_name'];
    noContact = json['no_contact'];
    address = json['address'];
    villageId = json['village_id'];
    districtId = json['district_id'];
    cityId = json['city_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    category = json['category'];
    photo = json['photo'];
    createdby = json['createdby'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['owner_name'] = ownerName;
    data['no_contact'] = noContact;
    data['address'] = address;
    data['village_id'] = villageId;
    data['district_id'] = districtId;
    data['city_id'] = cityId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['category'] = category;
    data['photo'] = photo;
    data['createdby'] = createdby;
    return data;
  }
}