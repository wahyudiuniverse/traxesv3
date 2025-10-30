// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/history_order/history.order.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/history_order/history.order.date.request.model.dart';
import 'package:traxes/model/history_order/history.order.model.dart';

class HistoryOrderBloc extends Cubit<HistoryOrderState> {
  HistoryOrderBloc() : super(HistoryOrderLoading());

  static const int maxRetries = 3;
  CancelToken? _cancelToken;

  void getHistoryOrder({
    required BuildContext context,
    bool isHttp = false,
    DateTime? selectedDate,
    DateTime? selectedSecondDate,
    HistoryOrderDateRequestModel? formData,
    int retryCount = 0,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    String? dateTime =
        DateFormat("yyyy-MM-dd").format(selectedDate ?? DateTime.now());
    
    String? secondDateTime = 
         DateFormat("yyyy-MM-dd").format(selectedSecondDate ?? DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nip = prefs.getString("empid").toString().isEmpty
        ? formData?.employeeId
        : prefs.getString("empid");

    Map<String, dynamic> requetHistoryOrder =
        ({"employee_id": nip, "first_date": dateTime, "last_date": secondDateTime});

    try {
      final response = await dio.post(
        "/v2/order/historyorderdate",
        data: requetHistoryOrder,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = HistoryOrderModel.fromJson(response.data).data;
        emit(HistoryOrderLoaded(resbody!));
      }
    } on DioException catch (err) {
      if (CancelToken.isCancel(err)) {
        if (kDebugMode) {
          print("Request canceled: $err");
        }
        EasyLoading.dismiss();
        emit(HistoryOrderError("Request canceled"));
        return;
      }

      EasyLoading.dismiss();
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        if (retryCount < maxRetries) {
          showRetryDialog(context, retryCount);
          emit(HistoryOrderTimeout("Timeout nih"));
        } else {
          EasyLoading.showError(
              "Max retry attempts reached. Please check your internet connection.",
              duration: const Duration(seconds: 3));
          emit(HistoryOrderError("Max retry attempts reached"));
        }
      }
    } catch (err) {
      EasyLoading.showError(
          "Gagal periksa history, periksa koneksi internet anda",
          duration: const Duration(seconds: 3));
    }
  }

  Future<void> sendHistoryOrder(
      {HistoryOrderDateRequestModel? formData,
      required context,
      bool isHttp = false,
      int retryCount = 0}) async {
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nip = prefs.getString("empid").toString().isEmpty
        ? formData!.employeeId
        : prefs.getString("empid");

    Map<String, dynamic> requetHistoryOrder =
        ({"employee_id": nip, "first_date": formData!.firstDate, "last_date": formData.lastDate});

    try {
      final response = await dio.post(
        "/v2/order/historyorderdate",
        data: requetHistoryOrder,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SuccessHistoryOrder());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
      throw Exception(err);
    } catch (err) {
      EasyLoading.showError(
          "Gagal periksa history, periksa koneksi internet anda",
          duration: const Duration(seconds: 3));
    }
  }

  void showRetryDialog(BuildContext context, int retryCount) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Timeout', style: largeBlackText),
            content: Text('Connection timed out. Do you want to retry?',
                style: standarBlackTextB),
            actions: [
              TextButton(
                onPressed: () {
                  emit(HistoryOrderLoading());
                  Navigator.of(context).pop();
                  getHistoryOrder(
                      context: context,
                      retryCount: retryCount + 1); // Retry the request
                },
                child: Text('Retry', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      ).then((_) {
        if (retryCount < maxRetries) {
          emit(HistoryOrderLoading());
          getHistoryOrder(
              context: context,
              retryCount: retryCount + 1); // Ensure retry on dialog close
        }
      });
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel(); // Cancel the request if the bloc is closed
    return super.close();
  }
}
