class ResponseVersionModel {
	int? status;
	String? message;

	ResponseVersionModel({this.status, this.message});

	ResponseVersionModel.fromJson(Map<String, dynamic> json) {
		status = json['status'];
		message = json['message'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = <String, dynamic>{};
		data['status'] = status;
		data['message'] = message;
		return data;
	}
}
