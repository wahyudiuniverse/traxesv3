class ResponseEmployeeModel {
  int? status;
  String? message;
  DataEmployee? data;

  ResponseEmployeeModel({this.status, this.message, this.data});

  ResponseEmployeeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataEmployee.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DataEmployee {
  String? employeeId;
  String? fullname;
  String? serverEnv;
  String? typeId;
  String? projectId;
  String? projectName;
  String? companyId;
  String? areaId;
  String? areaIdExtra1;
  String? areaIdExtra2;

  DataEmployee(
      {this.employeeId,
      this.fullname,
      this.serverEnv,
      this.typeId,
      this.projectId,
      this.projectName,
      this.companyId,
      this.areaId,
      this.areaIdExtra1,
      this.areaIdExtra2});

  DataEmployee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employee_id'];
    fullname = json['fullname'];
    serverEnv = json['server_env'];
    typeId = json['type_id'];
    projectId = json['project_id'];
    projectName = json['project_name'];
    companyId = json['company_id'];
    areaId = json['area_id'];
    areaIdExtra1 = json['area_id_extra1'];
    areaIdExtra2 = json['area_id_extra2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['employee_id'] = employeeId;
    data['fullname'] = fullname;
    data['server_env'] = serverEnv;
    data['type_id'] = typeId;
    data['project_id'] = projectId;
    data['project_name'] = projectName;
    data['company_id'] = companyId;
    data['area_id'] = areaId;
    data['area_id_extra1'] = areaIdExtra1;
    data['area_id_extra2'] = areaIdExtra2;
    return data;
  }
}
