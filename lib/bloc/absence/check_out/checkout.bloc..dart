// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/absence/check_out/checkout.state.dart';
import 'package:traxes/constant/env/config.url.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/check_out/check.out.model.dart';
import 'package:traxes/model/check_out/check.out.request.model.dart';

class SubmitCheckOutBloc extends Cubit<CheckOutState> {
  SubmitCheckOutBloc() : super(SubmitCheckOutLoading());

  void submitCheckOut(
      {required CheckOutModel formData,
      required BuildContext context,
      String? latitudeToko,
      String? longitudeToko,
      bool isHttp = false,
      required VoidCallback onSuccess}) async {

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

    final distance = Geolocator.distanceBetween(
        double.parse(latitudeToko.toString()),
        double.parse(longitudeToko.toString()),
        double.parse(formData.latitudeOut.toString()),
        double.parse(formData.longitudeOut.toString()));

    Map<String, dynamic> submitData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "date_cio": formData.dateCio,
      "datetimephone_out": formData.datetimephoneOut,
      "latitude_out": formData.latitudeOut,
      "longitude_out": formData.longitudeOut,
      "radius_out": formData.radiusOut,
      "distance_out": distance,
      "foto_out": formData.fotoOut,
      "status_toko": formData.statusToko
    });

   

    try {
       final response = await dio.post("/transaksi/pushcheckout",
        data: submitData,
        );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        onSuccess();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("getIn");
        if (kDebugMode) {
          print("iniii data baruu logout --> $submitData");
        }
        emit(SubmitCheckOutSuccess());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
    if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      }  else {
        DialogUtils().showRetryDialogSubmit(context);

      }
      throw Exception(err);
    } catch (err) {
      if (kDebugMode) {
        print("submit data error --> $submitData");
      }
      if (kDebugMode) {
        print("status toko --> ${formData.statusToko}");
      }
      throw Exception(err);
    }
  }

   
}
