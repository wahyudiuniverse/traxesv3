class EditMbdModel {
  String? secId;
  String? verifyStatus;
  String? verifyOn;
  String? verifyBy;

  EditMbdModel({this.secId, this.verifyStatus, this.verifyOn, this.verifyBy});

  EditMbdModel.fromJson(Map<String, dynamic> json) {
    secId = json['sec_id'];
    verifyStatus = json['verify_status'];
    verifyOn = json['verify_on'];
    verifyBy = json['verify_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sec_id'] = secId;
    data['verify_status'] = verifyStatus;
    data['verify_on'] = verifyOn;
    data['verify_by'] = verifyBy;
    return data;
  }
}