// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/absence/check_in/checkin.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/check_in/check.in.model.dart';

class SubmitCheckInBloc extends Cubit<CheckInState> {
  SubmitCheckInBloc() : super(SubmitCheckInLoading());

  void submitCheckIn(
      {required CheckInV2Model formData,
      required BuildContext context,
      int retryCount = 0,
      String? latitudeToko,
      String? longitudeToko,
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

    final distance = Geolocator.distanceBetween(
        double.parse(latitudeToko.toString()),
        double.parse(longitudeToko.toString()),
        double.parse(formData.latitudeIn.toString()),
        double.parse(formData.longitudeIn.toString()));

    Map<String, dynamic> submitData = {
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "radius_in": formData.radiusIn,
      "distance_in": distance,
      "foto_in": formData.fotoIn,
      "status_emp": 1,
      "reason": formData.reason,
      "apk": 0,
      "status_transport": formData.statusTransport,
      "update_toko": 0
    };

    try {
      final response = await dio.post(
        "/v2/customer/pushcheckin",
        data: submitData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        onSuccess();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("customerid", formData.customerId.toString());
        prefs.setString("project_id", formData.projectId.toString());
        prefs.setInt("getCio", 1);
        prefs.setInt("getIn", 1);
        if (kDebugMode) {
          print("iniii data baruu --> $submitData");
        }
        emit(SubmitCheckInSuccess());
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(
            "Failed to submit. Status code: ${response.statusCode}");
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
      throw Exception(err);
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError("An error . Please try again.");
      throw Exception(err);
    }
  }

  Future<void> resetCheckIn(
      {required CheckInV2Model formData,
      String? latitudeToko,
      String? longitudeToko,
      int retryCount = 0,
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

    final distance = Geolocator.distanceBetween(
        double.parse(latitudeToko.toString()),
        double.parse(longitudeToko.toString()),
        double.parse(formData.latitudeIn.toString()),
        double.parse(formData.longitudeIn.toString()));

    Map<String, dynamic> submitData = {
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "radius_in": formData.radiusIn,
      "distance_in": distance,
      "foto_in": formData.fotoIn,
      "status_emp": 1,
      "reason": formData.reason,
      "apk": 0,
      "status_transport": formData.statusTransport,
      "update_toko": 1
    };

    try {
      final response = await dio.post(
        "/v2/customer/pushcheckin",
        data: submitData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        onSuccess();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("customerid", formData.customerId.toString());
        prefs.setString("project_id", formData.projectId.toString());
        prefs.setInt("getCio", 1);
        prefs.setInt("getIn", 1);
        if (kDebugMode) {
          print("iniii data baruu --> $submitData");
        }
        emit(SubmitResetCheckInSuccess());
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(
            "Failed to reset. Status code: ${response.statusCode}");
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        EasyLoading.showError(
            "Waktu menghubungkan ke server telah habis. silakan coba lagi.");
      }
    } catch (err) {
      EasyLoading.dismiss();
      EasyLoading.showError(
          "Waktu menghubungkan ke server telah habis. silakan coba lagi.");
      throw Exception(err);
    }
  }
}
