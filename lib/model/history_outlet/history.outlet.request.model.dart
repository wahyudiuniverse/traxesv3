class HistoryOutletRequestModel {
  String? empid;
  String? area;
  String? area2;
  String? area3;
  String? latitude;
  String? longitude;

  HistoryOutletRequestModel(
      {this.empid,
      this.area,
      this.area2,
      this.area3,
      this.latitude,
      this.longitude});

  HistoryOutletRequestModel.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    area = json['area'];
    area2 = json['area2'];
    area3 = json['area3'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empid'] = empid;
    data['area'] = area;
    data['area2'] = area2;
    data['area3'] = area3;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}