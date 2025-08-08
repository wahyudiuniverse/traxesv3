// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/price_tag/price.tag.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/price_tag/price.tag.data.model.dart';
import 'package:traxes/model/price_tag/price.tag.model.dart';
import 'package:traxes/model/price_tag/price.tag.request.model.dart';

class PriceTagBloc extends Cubit<PriceTagState> {
  PriceTagBloc() : super(PriceTagLoading());

    static const int maxRetries = 3;

  void getPriceTag({PriceTagRequestModel? formData, required BuildContext context, int retryCount = 0, bool isHttp = false,}) async {

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

    String? customerId = prefs.getString("customerid").toString();

    String? empId = prefs.getString("empid").toString();

    Map<String, dynamic> dataPriceTag = ({
      "customer_id": customerId,
      "employee_id": empId,
    });

    try {
      final response = await dio.post(
        "/download/pricetaglist",
        data: dataPriceTag,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = PriceTagDataModel.fromJson(response.data).data;
        emit(PriceTagLoaded(resbody!));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
       if(retryCount < maxRetries) {
        showRetryDialog(context, retryCount);
       } else {
         EasyLoading.showError("Max retry attempts reached. Please check your internet connection.",
              duration: const Duration(seconds: 3));
       }
      } else {
        EasyLoading.showError("Waktu menghubungkan ke server telah habis. silakan coba lagi.");
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void sendPriceTag(PriceTagModel formData, BuildContext context, {bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

    String datetime = DateTime.now().toString();

    EasyLoading.showSuccess("Sukses mengirim price tag",
        duration: const Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? empId = prefs.getString("empid").toString().isEmpty
        ? formData.employeeId
        : prefs.getString("empid");

    Map<String, dynamic> insertPriceTag = ({
      "material_id": formData.materialId,
      "employee_id": empId,
      "customer_id": formData.customerId,
      "price": formData.price,
      "foto": formData.foto,
      "created_at": datetime
    });

    try {
      final response = await dio.post(
        "/transaksi/sendpricetag",
        data: insertPriceTag,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();

        if (kDebugMode) {
          print("dataaa --> $insertPriceTag");
        }
        emit(SuccessInsertPriceTag());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
    if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout) {
      DialogUtils().showRetryDialogSubmit(context);
          } else {
      DialogUtils().showRetryDialogSubmit(context);
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
            content: Text('Connection timed out. Do you want to retry?', style: standarBlackTextB),
            actions: [
              TextButton(
                onPressed: () {
                  emit(PriceTagLoading());
                  Navigator.of(context).pop();
                  getPriceTag(
                      context: context,
                      retryCount: retryCount + 1); // Retry the request
                },
                child: const Text('Retry', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      ).then((_) {
        if (retryCount < maxRetries) {
          emit(PriceTagLoading());
          getPriceTag(
              context: context,
              retryCount: retryCount + 1); // Ensure retry on dialog close
        }
      });
    }
  }
}
