class FilterRequestMbdModel {
  String? startDate;
  String? endDate;
  String? statusDisplay;
  String? verifyStatus;

  FilterRequestMbdModel(
      {this.startDate, this.endDate, this.statusDisplay, this.verifyStatus});

  FilterRequestMbdModel.fromJson(Map<String, dynamic> json) {
    startDate = json['start_date'];
    endDate = json['end_date'];
    statusDisplay = json['status_display'];
    verifyStatus = json['verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['status_display'] = statusDisplay;
    data['verify_status'] = verifyStatus;
    return data;
  }
}