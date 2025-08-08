class LoginModel {
  String? nik;
  String? deviceID;
  String? logindt;
  String? apkVersion;

  LoginModel({this.nik, this.deviceID, this.logindt, this.apkVersion});

  LoginModel.fromJson(Map<String, dynamic> json) {
    nik = json['nik'];
    deviceID = json['deviceID'];
    logindt = json['logindt'];
    apkVersion = json['apk_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nik'] = nik;
    data['deviceID'] = deviceID;
    data['logindt'] = logindt;
    data['apk_version'] = apkVersion;
    return data;
  }
}
