import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:traxes/model/search/search.model.dart';

class SearchHistoryGetx extends GetxController {
  String search = "";
  final List<DataSearch> dataResult = [];
  final List<DataSearch> dataApplication = [];

  Future<void> onChangeSearch({bool isHttp = false,}) async {
    dataResult.clear();
    EasyLoading.show(status: "loading");
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    Map<String, dynamic> dataSearch = ({"keys": search});
    final response = await dio.post("/user/customerbysearch",
        data: dataSearch,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {"Content-Type": "application/json"}));

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      dataResult.addAll(SearchModel.fromJson(response.data).data!.toList());
    } else {
      await EasyLoading.showError("Something went wrong",
          duration: const Duration(seconds: 3));
    }
  }

  Future<void> onChangeSearchNew(String input,VoidCallback onSuccess, {bool isHttp = false,}) async {
    dataResult.clear();
    EasyLoading.show(status: "Loading...");
      String inputNama = input;

    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    Map<String, dynamic> dataSearch = ({"keys": inputNama});
    // print(input);
    final response = await dio.post("/user/customerbysearch",
        data: dataSearch,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {"Content-Type": "application/json"}));

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      dataResult.addAll(SearchModel.fromJson(response.data).data!.toList());
      onSuccess();
    } else {
      await EasyLoading.showError("Something went wrong",
          duration: const Duration(seconds: 3));
    }
  }

}
