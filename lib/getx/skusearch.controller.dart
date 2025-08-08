
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'package:traxes/database_offline/db.material.dart';
import 'package:traxes/model/sku_search/skusearch.model.dart';
import 'package:traxes/model/skupro/skupro.model.dart';

class SkuSearchGetX extends GetxController {
  String search = "";
  final List<DataSkuSearch> dataResult = [];
  final List<DataSkuPro> dataResults = [];

  // Future<void> skuSearch(String input, VoidCallback onSuccess) async {

  //   dataResult.clear();
  //   EasyLoading.show(status: "Loading...");

  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   String inputSku = input;

  //   String? projectId = prefs.getString("emp_project");

  //   final dio = Dio();
  //   dio.interceptors.add(RetryInterceptor(
  //     dio: dio,
  //     logPrint: print,
  //     retries: 1,
  //     retryDelays: const [
  //       Duration(seconds: 30),
  //     ],
  //   ));
  //   var baseUrl = url;

  //   Map<String, dynamic> dataSearch = ({
  //     "keys": inputSku,
  //     "project": projectId
  //   });

  //   final response = await dio.post("$baseUrl/user/skusearch", 
  //   data: dataSearch,
  //   options: Options(
  //           followRedirects: false,
  //           validateStatus: (status) {
  //             return status! < 500;
  //           },
  //           headers: {"Content-Type": "application/json"}));
    
  //   if(response.statusCode == 200 || response.statusCode == 201) {
  //     EasyLoading.dismiss();
  //     dataResult.addAll(SkuSearchModel.fromJson(response.data).data!.toList());
  //     onSuccess();
  //   } else {
  //     await EasyLoading.showError("Something went wrong", 
  //     duration: const Duration(seconds: 3)
  //     );
  //   }
    
  // }

 Future<void> loadLocalSkuSearch(String input, VoidCallback onSuccess) async {
  dataResults.clear();
  EasyLoading.show(status: "Loading...", dismissOnTap: true);

  String inputSku = input;

  final response = await DBMaterialHelper().searchMaterialByName(inputSku);
  if (kDebugMode) {
    print("respon search --> $response");
  }

  if (response.isNotEmpty) {
    EasyLoading.dismiss();
    dataResults.addAll(response);
    onSuccess();
  } else {
    await EasyLoading.showError("Data material tidak ada/kosong, coba ketik ulang nama material dengan benar",
        duration: const Duration(seconds: 3));
  }
}
  
}
