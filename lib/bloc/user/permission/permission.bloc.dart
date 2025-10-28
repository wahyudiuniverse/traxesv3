// ignore_for_file: use_build_context_synchronously

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/user/permission/permission.state.dart';
import 'package:traxes/constant/env/config.url.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/check_in/check.in.model.dart';
import 'package:traxes/model/overtime/overtime.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class PermissionBloc extends Cubit<PermissionState> {
  PermissionBloc() : super(PermissionLoading());

  var baseUrl = url;

  void sendPermission(
    CheckInV2Model formData,
    BuildContext context, {
    bool isHttp = false,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    EasyLoading.show(status: "tunggu yaa");

    Map<String, dynamic> permissionData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "keterangan": formData.keterangan,
      "radius_in": 0,
      "distance_in": 0.0,
      "foto_in": formData.fotoIn,
      "status_emp": 2,
    });

    try {
      final response = await dio.post(
        "/transaksi/pushcheckin",
        data: permissionData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        EasyLoading.showSuccess("Pengajuan izin berhasil ditambahkan",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        emit(PermissionSuccess());
        Get.offAll(const EmployeeScreen());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void sickPermission(
    CheckInV2Model formData,
    BuildContext context, {
    bool isHttp = false,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    await EasyLoading.show(status: "Tunggu yaa...");

    Map<String, dynamic> permissionSickData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "keterangan": formData.keterangan,
      "radius_in": 0,
      "distance_in": 0.0,
      "foto_in": formData.fotoIn,
      "status_emp": 3,
    });

    try {
      final response = await dio.post(
        "$baseUrl/transaksi/pushcheckin",
        data: permissionSickData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Pengajuan sakit berhasil ditambahkan",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        emit(PermissionSuccess());
        Get.offAll(const EmployeeScreen());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void leavePermission(
    CheckInV2Model formData,
    BuildContext context, {
    bool isHttp = false,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    var connectivityResult = await Connectivity().checkConnectivity();

    await EasyLoading.show(status: "Tunggu yaa...");

    Map<String, dynamic> permissionLeaveData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "keterangan": formData.keterangan,
      "radius_in": 0,
      "distance_in": 0.0,
      "reason": formData.reason,
      "foto_in": formData.fotoIn,
      "status_emp": 4,
    });

    try {
      final response = await dio.post(
        "/transaksi/pushcheckin",
        data: permissionLeaveData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Pengajuan cuti berhasil ditambahkan",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        emit(PermissionSuccess());
        Get.offAll(const EmployeeScreen());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text('No Internet Connection', style: largeBlackText),
                content: Text(
                    'Please check your internet connection and try again.',
                    style: standarBlackText),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK', style: smallBlackText),
                  ),
                ],
              ),
            );
          },
        );
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void overTime(
    OvertimeModel formData,
    BuildContext context, {
    bool isHttp = false,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    await EasyLoading.show(status: "Tunggu yaa...");

    Map<String, dynamic> timeoutData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "jabatan_id": 5,
      "date_cio": formData.dateCio,
      "project_id": formData.projectId,
      "status_emp": 6,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "radius_in": formData.radiusIn,
      "distance_in": formData.distanceIn,
      "datetimephone_out": formData.datetimephoneOut,
      "latitude_out": formData.latitudeOut,
      "longitude_out": formData.longitudeOut,
      "radius_out": formData.radiusOut,
      "distance_out": formData.distanceOut,
      "keterangan": formData.keterangan,
      "apk": formData.apk,
      "foto_in": formData.fotoIn
    });

    try {
      final response = await dio.post(
        "$baseUrl/transaksi/pushLembur",
        data: timeoutData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Pengajuan lembur berhasil",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();

        emit(PermissionSuccess());
        Get.offAll(const DashboardScreen());
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
      throw Exception(err);
    }
  }

  void offPermission(
    CheckInV2Model formData,
    BuildContext context, {
    bool isHttp = false,
  }) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    await EasyLoading.show(status: "Tunggu yaa...");

    Map<String, dynamic> offData = ({
      "employee_id": formData.employeeId,
      "customer_id": formData.customerId,
      "project_id": formData.projectId,
      "date_cio": formData.dateCio,
      "jabatan_id": 5,
      "datetimephone_in": formData.datetimephoneIn,
      "latitude_in": formData.latitudeIn,
      "longitude_in": formData.longitudeIn,
      "keterangan": formData.keterangan,
      "radius_in": 0,
      "distance_in": 0.0,
      "foto_in": formData.fotoIn,
      "status_emp": 5,
      "apk": 0,
    });

    try {
      final response = await dio.post(
        "$baseUrl/transaksi/pushcheckin",
        data: offData,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Pengajuan Off berhasil diajukan",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();

        emit(PermissionSuccess());
        Get.offAll(const EmployeeScreen());
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
      throw Exception(err);
    }
  }
}
