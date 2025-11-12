import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:logger/logger.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:traxes/model/search/search.model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreListGetx extends GetxController {
  String search = "";
  final List<DataSearch> dataCallPlan = [];
  final List<DataSearch> dataSuggest = [];

  final logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true
    )
  );

  Future<void> getCallPlan(ValueChanged<List<DataSearch>> onSuccess) async {
    dataSuggest.clear();

    final dio = DioClient.getDio();
    dio.interceptors.add(RetryInterceptor(
      dio: dio,      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nip = prefs.getString("empid");

    Map<String, dynamic> payload = ({
      "employee_id": nip,
      "date_callplan": cdate
    });
    
    final response = await dio.post("/download/callplanlist",
        data: payload,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {"Content-Type": "application/json"}));

    logger.i(dio);
    logger.i(payload);
    logger.i(response);

    if (response.statusCode == 200) {
      dataCallPlan.addAll(SearchModel.fromJson(response.data).data!.toList());
      onSuccess(dataCallPlan);
    }
  }
  
  Future<void> getSuggest(String projectId, ValueChanged<List<DataSearch>> onSuccess) async {
    dataSuggest.clear();

    final dio = DioClient.getDio();
    dio.interceptors.add(RetryInterceptor(
      dio: dio,      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    Map<String, dynamic> payload = ({"project_id": projectId});
    
    final response = await dio.post("/v2/customer/customerlist_project",
        data: payload,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {"Content-Type": "application/json"}));

    logger.i(dio);
    logger.i(payload);
    logger.i(response);

    if (response.statusCode == 200) {
      dataSuggest.addAll(SearchModel.fromJson(response.data).data!.toList());
      onSuccess(dataSuggest);
    } 
  }
}
