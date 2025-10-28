
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
    debugPrint(response.toString());
    onSuccess();
  } else {
    await EasyLoading.showError("Data material tidak ada/kosong, coba ketik ulang nama material atau barcode dengan benar",
        duration: const Duration(seconds: 3));
  }
}

 Future<void> loadLocalSkuScan(String input, VoidCallback onSuccess) async {
  dataResults.clear();
  EasyLoading.show(status: "Loading...", dismissOnTap: true);

  String inputSku = input;

  final response = await DBMaterialHelper().searchMaterialByBarcode(inputSku);
  if (kDebugMode) {
    print("respon search --> $response");
  }

  if (response.isNotEmpty) {
    EasyLoading.dismiss();
    dataResults.addAll(response);
    debugPrint(response.toString());
    onSuccess();
  } else {
    await EasyLoading.showError("Data material tidak ditemukan",
        duration: const Duration(seconds: 3));
  }
}
  
}
