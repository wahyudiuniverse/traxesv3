class CompetitorModel {
  String? employeeId;
  String? customerId;
  String? namaMaterial;
  int? qty;
  int? hargaNormal;
  int? hargaPromo;
  String? tanggalPromo;
  String? akhirPromo;
  String? keteranganPromo;
  String? omzet;
  String? foto1;
  String? foto2;

  CompetitorModel(
      {this.employeeId,
      this.customerId,
      this.namaMaterial,
      this.qty,
      this.hargaNormal,
      this.hargaPromo,
      this.tanggalPromo,
      this.akhirPromo,
      this.keteranganPromo,
      this.omzet,
      this.foto1,
      this.foto2});

  CompetitorModel.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    customerId = json['customer_id'];
    namaMaterial = json['nama_material'];
    qty = json['qty'];
    hargaNormal = json['harga_normal'];
    hargaPromo = json['harga_promo'];
    tanggalPromo = json['tanggal_promo'];
    akhirPromo = json['akhir_promo'];
    omzet = json['omzet'];
    keteranganPromo = json['keterangan_promo'];
    foto1 = json['foto_1'];
    foto2 = json['foto_2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['customer_id'] = customerId;
    data['nama_material'] = namaMaterial;
    data['qty'] = qty;
    data['harga_normal'] = hargaNormal;
    data['harga_promo'] = hargaPromo;
    data['tanggal_promo'] = tanggalPromo;
    data['akhir_promo'] = akhirPromo;
    data['keterangan_promo'] = keteranganPromo;
    data['omzet'] = omzet;
    data['foto_1'] = foto1;
    data['foto_2'] = foto2;
    return data;
  }
}