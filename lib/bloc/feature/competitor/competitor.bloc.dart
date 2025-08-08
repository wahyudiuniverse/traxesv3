// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/competitor/competitor.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/competitor/competitor.model.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class CompetitorBloc extends Cubit<CompetitorState> {
  CompetitorBloc() : super(CompetitorLoading());

  void submitCompetitor(CompetitorModel formData, BuildContext context, {bool isHttp = false}) async {

   final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));
   

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? empId = prefs.getString("empid").toString();

    await EasyLoading.show(status: "Sedang menginput competitor");

    Map<String, dynamic> dataCompetitor = ({
      "employee_id": empId,
      "customer_id": formData.customerId,
      "nama_material": formData.namaMaterial,
      "qty": formData.qty,
      "harga_normal": formData.hargaNormal,
      "harga_promo": formData.hargaPromo,
      "tanggal_promo": formData.tanggalPromo,
      "akhir_promo": formData.akhirPromo,
      "keterangan_promo": formData.keteranganPromo,
      "omzet": formData.omzet,
      "foto_1": formData.foto1,
      "foto_2": formData.foto2,
    });

    
    try {
      final response = await dio.post("/transaksi/sendcompetitor",
        data: dataCompetitor,
    );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Berhasil menambahkan kompetitor",
            duration: const Duration(seconds: 3));
        emit(SuccesSubmitCompetitor());
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
