// ignore_for_file: unnecessary_this

class InsertMbdDisplayModel {
  String? customerId;
  String? employeeId;
  String? projectId;
  String? tanggalDisplay;
  String? ketDisplay;
  String? fotoDisplay;
  int? statusDisplay;

  InsertMbdDisplayModel(
      {this.customerId,
      this.employeeId,
      this.projectId,
      this.tanggalDisplay,
      this.ketDisplay,
      this.fotoDisplay,
      this.statusDisplay
      });

  InsertMbdDisplayModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    employeeId = json['employee_id'];
    projectId = json['project_id'];
    tanggalDisplay = json['tanggal_display'];
    ketDisplay = json['ket_display'];
    fotoDisplay = json['foto_display'];
    statusDisplay = json['status_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = this.customerId;
    data['employee_id'] = this.employeeId;
    data['project_id'] = this.projectId;
    data['tanggal_display'] = this.tanggalDisplay;
    data['ket_display'] = this.ketDisplay;
    data['foto_display'] = this.fotoDisplay;
    data['status_display'] = this.statusDisplay;
    return data;
  }
}