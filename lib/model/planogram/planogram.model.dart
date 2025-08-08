class PlanogramModel {
  String? nik;
  String? planogram;
  String? planogram2;
  String? planogram3;
  String? createdat;
  int? createdby;
  String? idToko;

  PlanogramModel(
      {this.nik,
      this.planogram,
      this.planogram2,
      this.planogram3,
      this.createdat,
      this.createdby,
      this.idToko});

  PlanogramModel.fromJson(Map<String, dynamic> json) {
    nik = json['nik'];
    planogram = json['planogram'];
    planogram2 = json['planogram2'];
    planogram3 = json['planogram3'];
    createdat = json['createdat'];
    createdby = json['createdby'];
    idToko = json['id_toko'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nik'] = nik;
    data['planogram'] = planogram;
    data['planogram2'] = planogram2;
    data['planogram3'] = planogram3;
    data['createdat'] = createdat;
    data['createdby'] = createdby;
    data['id_toko'] = idToko;
    return data;
  }
}