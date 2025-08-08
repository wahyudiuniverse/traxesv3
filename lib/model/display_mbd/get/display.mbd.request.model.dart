// ignore_for_file: unnecessary_this

class GetMbdDisplayRequestModel {
  String? customerId;

  GetMbdDisplayRequestModel({this.customerId});

  GetMbdDisplayRequestModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = this.customerId;
    return data;
  }
}