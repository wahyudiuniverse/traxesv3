// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/display/display.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/display/display.model.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class DisplayBloc extends Cubit<DisplayState> {
  DisplayBloc() : super(DisplayLoading());

  void sendDisplay(DisplayModel formData, BuildContext context, {bool isHttp = false,}) async {

     final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

    EasyLoading.show(status: "Loading...");
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var createdBy = prefs.getString("empid").toString().isEmpty
        ? formData.createdBy
        : prefs.getString("empid");

    Map<String, dynamic> insertDisplay = ({
      "display": formData.display,
      "display2": formData.display2,
      "display3": formData.display3,
      "id_toko": formData.idToko,
      "created_at": cdate,
      "created_by": formData.createdBy,
      "nik": createdBy
    });

    

    try {
      final response = await dio.post("/transaksi/senddisplay",
        data: insertDisplay,
       );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Sukses mengirim display",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("dataaa --> $insertDisplay");
        }
        emit(DisplaySuccessInsert());
        Get.offAll(const EmployeeScreen());
      }
    }

    on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
              DialogUtils().showRetryDialogSubmit(context);

      } else {
                   DialogUtils().showRetryDialogSubmit(context);

      }
      throw Exception(err);
    } 
    
    catch (err) {
      throw Exception(err);
    } 
  }
}
