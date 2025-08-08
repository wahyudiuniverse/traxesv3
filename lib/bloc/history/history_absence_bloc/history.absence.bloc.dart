// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/history_absence_bloc/history.absence.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/history_absence/history.absence.model.dart';
import 'package:traxes/model/history_absence/history.absence.request.model.dart';

class HistoryAbsenceBloc extends Cubit<HistoryAbsenceState> {
  HistoryAbsenceBloc() : super(HistoryAbsenceLoading());

  static const int maxRetries = 3;
  CancelToken? _cancelToken;

  getHistoryAbsence({
    required BuildContext context,
    HistoryAbsenceRequestModel? formData,
    bool isHttp = false,
    int retryCount = 0,
  }) async {
    _cancelToken = CancelToken();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nip = prefs.getString("empid").toString().isEmpty
        ? formData?.nip
        : prefs.getString("empid");

    Map<String, dynamic> requestHistory = ({"nip": nip});

    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [Duration(seconds: 5)],
    ));

    try {
      final response = await dio.post("/download/historycio",
          data: requestHistory, cancelToken: _cancelToken);
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        var resbody = HistoryAbsenceModel.fromJson(response.data).data;
        emit(HistoryAbsenceLoaded(
            resbody!));
      } else {
        if (kDebugMode) {
          print("Response status code: ${response.statusCode}");
        }
        EasyLoading.showError("Unexpected server response");
        emit(HistoryAbsenceError("Unexpected server response"));
      }
    } on DioException catch (err) {
      if (CancelToken.isCancel(err)) {
        if (kDebugMode) {
          print("Request canceled: $err");
        }
        EasyLoading.dismiss();
        emit(HistoryAbsenceError("Request canceled"));
        return;
      }

      EasyLoading.dismiss();
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        if (retryCount < maxRetries) {
          showRetryDialog(context, retryCount);
        } else {
            CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Error",
            text: "Max retry attempts reached. Please check your internet connection.",
            confirmBtnText: "Kembali",
            onConfirmBtnTap: () {
              Navigator.pop(context);
            }
          );
        }
      } else {
        EasyLoading.showError("An error occurred");
        emit(HistoryAbsenceError("An error occurred"));
      }
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
                  emit(HistoryAbsenceLoading());
                  Navigator.of(context).pop();
                  getHistoryAbsence(
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
          emit(HistoryAbsenceLoading());
          getHistoryAbsence(
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
