// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:traxes/bloc/absence/check_in/checkin.bloc.dart';
import 'package:traxes/bloc/absence/check_radius/check.radius.state.dart';
import 'package:traxes/constant/screen/success.checkin.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/check_in/check.in.model.dart';
import 'package:traxes/model/check_radius/check.radius.model.dart';

class CheckRadiusBloc extends Cubit<CheckRadiusState> {
  CheckRadiusBloc() : super(CheckRadiusLoading());

  void checkRadius(
      BuildContext context,
      String? customerId,
      String? customerName,
      String? radius,
      CheckInV2Model formData,
      String? latitudeToko,
      String? longitudeToko,
      String nama,
      String jabatan,
      String toko,
      String alamat,
      String currentDate,
      String tdata,
      Uint8List imgBytes,
      {bool isHttp = false}) async {

   final dio = DioClient.getDio(isHttp: isHttp);

    EasyLoading.show(status: "Loading...");
    final distance = Geolocator.distanceBetween(
        double.parse(latitudeToko.toString()),
        double.parse(longitudeToko.toString()),
        double.parse(formData.latitudeIn.toString()),
        double.parse(formData.longitudeIn.toString()));

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

   
    Map<String, dynamic> checkRadiusData = ({"customer_id": customerId});

   
    try {

       final response = await dio.post(
      "/v2/customer/check_latlon",
      data: checkRadiusData,
    );

    var checkRadiusModel = CheckRadiusModel.fromJson(response.data);
    var bodyStatus = checkRadiusModel.status;

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(SuccessCheckRadius());

        EasyLoading.dismiss();

        String custName = '$customerName';
        String custId = '$customerId';

        if (bodyStatus == 1) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              backgroundColor: Colors.white,
              title: 'PERINGATAN',
              text: '$custName\nKode: $custId\n\nJarak anda lebih dari $radius M',
              confirmBtnText: 'Reset lokasi',
              cancelBtnText: 'Kembali',
              textTextStyle: standarBlackTextB,
              titleTextStyle: largeBlackTextB,
              confirmBtnTextStyle: smallWhiteText,
              onConfirmBtnTap: () async {
                final checkInData = CheckInV2Model(
                  employeeId: formData.employeeId,
                  customerId: formData.customerId,
                  projectId: formData.projectId,
                  dateCio: formData.dateCio,
                  jabatanId: 5,
                  datetimephoneIn: formData.datetimephoneIn,
                  latitudeIn: formData.latitudeIn,
                  longitudeIn: formData.longitudeIn,
                  radiusIn: formData.radiusIn,
                  distanceIn: distance,
                  fotoIn: formData.fotoIn,
                  statusEmp: 1,
                  reason: formData.reason,
                  statusTransport: formData.statusTransport,
                  updateToko: 1,
                );
                await context.read<SubmitCheckInBloc>().resetCheckIn(
                    formData: checkInData,
                    latitudeToko: latitudeToko,
                    longitudeToko: longitudeToko,
                    context: context,
                    onSuccess: () {
                      Get.offAll(SuccessScreen(
                        toko: toko,
                        name: nama,
                        jabatan: jabatan,
                        alamat: alamat,
                        currentDate: currentDate,
                        tdata: tdata,
                        watermarkedImgBytes: imgBytes,
                      ));
                    });
              },
              showCancelBtn: true);
        } else {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.info,
              backgroundColor: Colors.white,
              title: 'PERINGATAN',
              titleTextStyle: largeBlackTextB,
              text: '$custName\nKode: $custId\n\nJarak anda lebih dari $radius M',
              textTextStyle: standarBlackTextB,
              confirmBtnText: "Kembali",
              confirmBtnTextStyle: smallWhiteText);
        }
      } else {
        emit(FailureCheckRadius("Error"));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
     if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout) {
      showRetryDialog(context);
      } else {
        showRetryDialog(context);
      }
      throw Exception(err);
    } catch (err) {
      emit(FailureCheckRadius("Error"));
      throw Exception(err);
    }
  }

   void showRetryDialog(BuildContext context) {
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
                  Navigator.of(context).pop();
                },
                child: const Text('Retry', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      );
    }
  }
}
