import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/callplan/callplan.state.dart';
import 'package:traxes/model/callplan/callplan.model.dart';
import 'package:traxes/model/callplan/callplan.request.model.dart';

class CallplanBloc extends Cubit<CallplanState> {
  CallplanBloc() : super(CallplanLoading());

  void getCallPlan({CallplanRequestModel? formData, bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);
      dio.interceptors.add(RetryInterceptor(
      dio: dio,
      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nip = prefs.getString("empid").toString().isEmpty
    ? formData?.employeeId
    : prefs.getString("empid");

    Map<String, dynamic> callPlanRequest = ({
      "employee_id": nip,
      "date_callplan": cdate
    });

    final logger = Logger(
      printer: PrettyPrinter(
        colors: true,
        printEmojis: true
      )
    );

    logger.i(callPlanRequest);

    final response = await dio.post("/download/callplanlist",
    data: callPlanRequest,
    options: Options(
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      followRedirects: false,
      validateStatus: ((status) {
        return status! < 500;
      }
    )
    ));

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = CallplanModel.fromJson(response.data).data;
        emit(CallplanLoaded(resbody!));
        if(kDebugMode) {
          print(resbody);
        }
      }
    }

     on DioException catch (err) {
      EasyLoading.dismiss();
       if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
        EasyLoading.showError("Koneksi intenet anda lambat. Coba lagi");
      } else {
        EasyLoading.showError("Waktu menghubungkan ke server telah habis. silakan coba lagi.");
      }
      throw Exception(err);
    }  
    
    catch (err) {
      throw Exception(err);
    }
  }
}