class HistoryAbsenceRequestModel {
  String? nip;

  HistoryAbsenceRequestModel({this.nip});

  HistoryAbsenceRequestModel.fromJson(Map<String, dynamic> json) {
    nip = json['nip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nip'] = nip;
    return data;
  }
}
