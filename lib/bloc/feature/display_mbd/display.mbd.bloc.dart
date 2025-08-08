// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/display_mbd/display.mbd.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/display_mbd/get/display.mbd.request.model.dart';
import 'package:traxes/model/display_mbd/get/display.mbd.response.model.dart';
import 'package:traxes/model/display_mbd/insert/insert.mbd.display.model.dart';

class DisplayMbdBloc extends Cubit<DisplayMbdState> {
  DisplayMbdBloc() : super(DisplayMbdLoading());

    static const int maxRetries = 3;
 void getMbdDisplay(
      {GetMbdDisplayRequestModel? formData,
      required BuildContext context,
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

    String? customerid = prefs.getString("customerid").toString();
    Map<String, dynamic> requestMbd = ({
      "customer_id": customerid,
    });

    try {
      final response = await dio.post(
        "/download/getdisplaymbd",
        data: requestMbd,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = GetMbdDisplayResponseModel.fromJson(response.data).data;
        emit(DisplayMbdLoaded(resbody!));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        if (retryCount < maxRetries) {
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
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void sendMbdDisplay(
      {required InsertMbdDisplayModel formData,
      required BuildContext context,
      bool isHttp = false,
      required VoidCallback onSuccess}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    EasyLoading.show(status: "Loading...");

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var empid = prefs.getString("empid").toString().isEmpty
        ? formData.employeeId
        : prefs.getString("empid");

        String? projectid = prefs.getString("project_id").toString().isEmpty ? formData.projectId : prefs.getString("project_id");

    Map<String, dynamic> insertMbdData = ({
      "customer_id": formData.customerId,
      "employee_id": empid,
      "project_id": projectid,
      "tanggal_display": formData.tanggalDisplay,
      "ket_display": formData.ketDisplay,
      "foto_display": formData.fotoDisplay,
      "status_display": formData.statusDisplay
    });

    try {
      final response =
          await dio.post("/v2/display/simpan_display_mbd", data: insertMbdData);
      if (response.statusCode == 200 || response.statusCode == 201) {
                  if (kDebugMode) {
                    print("iniii data baruu --> $insertMbdData");
                  }

        onSuccess();
        emit(DisplayMbdSuccess());
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("Data mbd --> $insertMbdData");
        }
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError("Gagal kirim data display");
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  // void showRetryDialog(BuildContext context, int retryCount) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Timeout', style: largeBlackText),
  //         content: Text('Connection timed out. Do you want to retry?',
  //             style: standarBlackTextB),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               emit(DisplayMbdLoading());
  //               Navigator.of(context).pop();
  //               getMbdDisplay(context: context, retryCount: retryCount + 1);
  //             },
  //             child: const Text('Retry', style: TextStyle(color: Colors.blue)),
  //           ),
  //         ],
  //       );
  //     },
  //   ).then((_) {
  //     if (retryCount < maxRetries) {
  //       emit(DisplayMbdLoading());
  //       getMbdDisplay(
  //           context: context,
  //           retryCount: retryCount + 1); // Ensure retry on dialog close
  //     }
  //   });
  // }

  // @override
  // Future<void> close() {
  //   _cancelToken?.cancel(); 
  //   return super.close();
  // }
}



