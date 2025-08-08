import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:traxes/bloc/feature/mbd/filter_mbd/filter.mbd.state.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/filter_mbd/filter.mbd.model.dart';
import 'package:traxes/model/filter_mbd/filter.mbd.request.dart';

class FilterMbdBloc extends Cubit<FilterMbdState> {
  FilterMbdBloc() : super(FilterMbdLoading());

  static const int maxRetries = 3;

  Future<void> getFilterMbd({
    required BuildContext context,
    FilterRequestMbdModel? formData,
    bool isHttp = false,
  }) async {
    Map<String, dynamic> requestFilter = {
      "start_date": formData?.startDate,
      "end_date": formData?.endDate,
      "status_display": formData?.statusDisplay,
      "verify_status": formData?.verifyStatus,
    };

    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: maxRetries,
      retryDelays: const [Duration(seconds: 5)],
    ));

    try {
      final response = await dio.post(
        "/download/filtermbd",
        data: requestFilter,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print("Ini respon filter --> ${response.data}");
        }
        var resBody = FilterMbdModel.fromJson(response.data).data;
        emit(FilterMbdLoaded(resBody!));
      } 
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching filter MBD: $e");
      }
    }
  }
}
