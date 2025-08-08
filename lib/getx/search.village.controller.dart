// import 'package:dio/dio.dart';
// import 'package:dio_smart_retry/dio_smart_retry.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:traxes/constant/config.url.dart';
// import 'package:traxes/model/search_village/search.village.model.dart';

// class SearchVillageGetx extends GetxController {
//   String search = "";
//   final List<DataVillage> dataResult = [];

//   void clearAfterFound() {
//     search = "";
//   }

//   Future<void> onChangeSearchVillage() async {
//     dataResult.clear();
//     final dio = Dio();
//     dio.interceptors.add(RetryInterceptor(
//       dio: dio,
//       logPrint: print,
//       retries: 1,
//       retryDelays: const [
//         Duration(seconds: 30),
//       ],
//     ));
//     var baseUrl = url;

//     Map<String, dynamic> dataSearch = ({"keys": search});

//     final response = await dio.post("$baseUrl/user/villagebysearch",
//         data: dataSearch,
//         options: Options(
//             followRedirects: false,
//             validateStatus: (status) {
//               return status! < 500;
//             },
//             headers: {"Content-Type": "application/json"}));

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       dataResult
//           .addAll(SearchVillageModel.fromJson(response.data).data!.toList());
//     } else {
//       await EasyLoading.showError("Ada yang salah",
//           duration: const Duration(seconds: 3));
//     }
//   }
// }
