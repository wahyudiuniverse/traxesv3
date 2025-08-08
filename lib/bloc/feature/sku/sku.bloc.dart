// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/sku/sku.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';


class SkuBloc extends Cubit<SkuState> {
  SkuBloc() : super(SkuLoading());

  void loadingSku() {
    SkuLoading();
  }

  void sendSku({required  formData, int retryCount = 0 , required BuildContext context, required VoidCallback onSuccess, bool isHttp = false,}) async {

    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));


    String dateTime = DateTime.now().toString();

    EasyLoading.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? createdBy = prefs.getString("empid").toString().isEmpty
        ? formData.createdby
        : prefs.getString("empid");
    
        String? customerId = prefs.getString("customerid");


    Map<String, dynamic> insertSkuData = ({
      "customer_id": customerId,
      "employee_id": createdBy,
      "material_id": formData.materialId,
      "order_date": dateTime,
      "qty": formData.qty,
      "price": formData.price,
      "total": formData.total,
      "createdBy": createdBy
    });

   

    try {
       final response = await dio.post("/transaksi/pushOrder",
        data: insertSkuData,
        );
      if (response.statusCode == 200 || response.statusCode == 201) {
        prefs.setInt("order", 1);
        onSuccess();
        EasyLoading.dismiss();
        emit(SkuSuccessInsert());
        if (kDebugMode) {
          print("data sku --> $insertSkuData");
        }
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
