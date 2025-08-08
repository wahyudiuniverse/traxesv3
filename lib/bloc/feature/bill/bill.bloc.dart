// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/bill/bill.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/bill/bill.model.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class BillBloc extends Cubit<BillState> {
  BillBloc() : super(BillLoading());

  void sendBill(BillModel formData, BuildContext context, {bool isHttp = false}) async {
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

    var empId = prefs.getString("empid").toString().isEmpty
        ? formData.employeeId
        : prefs.getString("empid");

    Map<String, dynamic> insertbill = ({
      "employee_id": empId,
      "customer_id": formData.customerId,
      "bill": formData.bill,
      "bill2": formData.bill2,
      "bill3": formData.bill3,
      "created_at": cdate,
    });

    try {
      final response = await dio.post("/transaksi/sendbill",
      data: insertbill
      );
      if(response.statusCode == 200 || response.statusCode == 201) {
          EasyLoading.showSuccess("Sukses mengirim foto struk",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        emit(BillSuccessInsert());
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