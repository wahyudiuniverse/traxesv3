// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/history_outlet/history.outlet.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/history_outlet/history.outlet.model.dart';
import 'package:traxes/model/history_outlet/history.outlet.request.model.dart';

class HistoryOutletBloc extends Cubit<HistoryOutletState> {
  HistoryOutletBloc() : super(HistoryOutletLoading());

  final logger = Logger();

    static const int maxRetries = 3;
  CancelToken? _cancelToken;


  void sendHistoryOutlet({HistoryOutletRequestModel? formData, required BuildContext context, int retryCount = 0, bool isHttp = false,}) async {

 final dio = DioClient.getDio(isHttp: isHttp);
    
     dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? empId = prefs.getString("empid").toString().isEmpty
        ? formData?.empid
        : prefs.getString("empid");

    Map<String, dynamic> dataHistory = ({
      "empid": empId,
      "latitude": formData?.latitude,
      "longitude": formData?.longitude
    });

  
    try {
        final response = await dio.post("/v2/customer/customerbyid",
        data: dataHistory,
        );
      if (response.statusCode == 200 || response.statusCode == 201) {
                  logger.i(response);
                  logger.i(dataHistory);

        if (kDebugMode) {
          print("id --> $empId");
        }
        if (kDebugMode) {
          print("data id history --> $response");
        }
        EasyLoading.dismiss();
        var resbody = HistoryOutletModel.fromJson(response.data).data;
        if (kDebugMode) {
          print("data resbody history --> $resbody");
        }
        emit(HistoryOutletSuccessLoad(resbody!));
      }
    }

    on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
       if (retryCount < maxRetries) {
          showRetryDialog(context, retryCount);
          emit(HistoryOutletTimeout("Timeout nih"));
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
    }
  }

   void showRetryDialog(BuildContext context, int retryCount) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Timeout', style: largeBlackText),
            content: Text('Connection timed out. Do you want to retry?', style: standarBlackTextB),
            actions: [
              TextButton(
                onPressed: () {
                  emit(HistoryOutletLoading());
                  Navigator.of(context).pop();
                  sendHistoryOutlet(
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
          emit(HistoryOutletLoading());
          sendHistoryOutlet(
              context: context,
              retryCount: retryCount + 1); // Ensure retry on dialog close
        }
      });
    }
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel();
    return super.close();
  }
    } 
    
   

  
