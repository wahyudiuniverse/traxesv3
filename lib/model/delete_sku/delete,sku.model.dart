class DeleteSKUModel {
  String? idorder;

  DeleteSKUModel({this.idorder});

  DeleteSKUModel.fromJson(Map<String, dynamic> json) {
    idorder = json['idorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idorder'] = idorder;
    return data;
  }
}