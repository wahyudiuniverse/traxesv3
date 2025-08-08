// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traxes/bloc/history/history_absence_detail/history.absence.detail.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/history_detail_absence/history.detail.absence.model.dart';

class DetailAbsenceBloc extends Cubit<HistoryDetailState> {
  DetailAbsenceBloc() : super(HistoryDetailLoading());

  static const int maxRetries = 3;
  CancelToken? _cancelToken;

  void getDetail({
    String? secid,
    required BuildContext context,
    bool isHttp = false,
    int retryCount = 0,
  }) async {
    _cancelToken = CancelToken();
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    Map<String, dynamic> detailData = ({
      "secid": secid,
    });

    try {
      final response = await dio.post(
        "/v2/cio/lookcio",
        data: detailData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = HistoryDetailModel.fromJson(response.data).data;
        emit(HistoryDetailLoaded(resbody!));
      } else {
                EasyLoading.showError("Unexpected server response ${response.statusCode}");

      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
       if (retryCount < maxRetries) {
          showRetryDialog(context, retryCount);
          emit(HistoryDetailTimeOut("Timeout nih"));
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
                  emit(HistoryDetailLoading());
                  Navigator.of(context).pop();
                  getDetail(
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
          emit(HistoryDetailLoading());
          getDetail(
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
