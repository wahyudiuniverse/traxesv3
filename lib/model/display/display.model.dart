class DisplayModel {
  String? display;
  String? display2;
  String? display3;
  String? createdAt;
  int? createdBy;
  String? idToko;
  String? nik;

  DisplayModel(
      {this.display,
      this.display2,
      this.display3,
      this.createdAt,
      this.createdBy,
      this.idToko,
      this.nik});

  DisplayModel.fromJson(Map<String, dynamic> json) {
    display = json['display'];
    display2 = json['display2'];
    display3 = json['display3'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    idToko = json['id_toko'];
    nik = json['nik'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['display'] = display;
    data['display2'] = display2;
    data['display3'] = display3;
    data['created_at'] = createdAt;
    data['created_by'] = createdBy;
    data['id_toko'] = idToko;
    data['nik'] = nik;
    return data;
  }
}