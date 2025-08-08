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
import 'package:traxes/bloc/feature/planogram/planogram.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/planogram/planogram.model.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class PlanogramBloc extends Cubit<PlanogramState> {
  PlanogramBloc() : super(PlanogramLoading());

  void sendPlanogram(PlanogramModel formData, BuildContext context, {bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    SharedPreferences prefs = await SharedPreferences.getInstance();

    EasyLoading.show(status: "Loading...");

    var createdBy = prefs.getString("empid").toString().isEmpty
        ? formData.createdby
        : prefs.getString("empid");

    Map<String, dynamic> insertPlanogram = ({
      "planogram": formData.planogram,
      "planogram2": formData.planogram2,
      "planogram3": formData.planogram3,
      "createdat": cdate,
      "createdby": formData.createdby,
      "id_toko": formData.idToko, 
      "nik": createdBy
    });

    try {
      final response = await dio.post(
        "/transaksi/sendplanogram",
        data: insertPlanogram,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
          EasyLoading.showSuccess("Sukses mengirim foto planogram",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        if (kDebugMode) {
          print("dataaa --> $insertPlanogram");
        }
        emit(PlanogramSuccessInsert());
        Get.offAll(const EmployeeScreen());
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
      throw Exception(err);
    }
  }
}
