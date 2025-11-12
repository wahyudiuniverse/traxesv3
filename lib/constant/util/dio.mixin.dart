import 'package:dio/dio.dart';
import 'package:traxes/constant/env/config.url.dart';

class DioClient {
  static const String httpsApi = "https://api.traxes.id/index.php";
  static const String httpApi = "http://api.traxes.id/index.php";

  static Dio getDio({bool isHttp = true}) {
    String baseUrl = isHttp ? httpApi : httpsApi;

    return Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500; // Accept all 2xx and 4xx responses
      },
    ));
  }

  static Dio getDummyDio() {
    return Dio(BaseOptions(
      baseUrl: dummy!, // Assuming `dummy` is defined elsewhere
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      },
    ));
  }
}
