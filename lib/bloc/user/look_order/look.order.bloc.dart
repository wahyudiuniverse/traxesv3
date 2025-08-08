// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/look_order/look.order.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/look_order/look.order.model.dart';

class LookOrderBloc extends Cubit<LookOrderState> {
  LookOrderBloc() : super(LookOrderLoading());

  final logger = Logger();

  static const int maxRetries = 3;
    CancelToken? _cancelToken;


  void getLookOrder({required BuildContext context, int retryCount = 0, bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? empId = prefs.getString("empid");
    String? customerId = prefs.getString("customerid");

    Map<String, dynamic> dataOrder = ({
      "date_cio": currentDate,
      "employee_id": empId,
      "customer_id": customerId
    });

    try {
      final response = await dio.post(
        "/user/lookorder",
        data: dataOrder,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = LookOrderModel.fromJson(response.data).data;
        logger.i(resbody);
        logger.i(response);
        emit(LookOrderLoaded(resbody!));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
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
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
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
                  emit(LookOrderLoading());
                  Navigator.of(context).pop();
                  getLookOrder(
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
          emit(LookOrderLoading());
          getLookOrder(
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
