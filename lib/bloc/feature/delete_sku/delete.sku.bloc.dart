// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:traxes/bloc/feature/delete_sku/delete.sku.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/delete_sku/delete,sku.model.dart';

class DeleteSkuBloc extends Cubit<DeleteSkuState> {
  DeleteSkuBloc() : super(DeleteSkuLoading());

  Future<void> deleteSku(DeleteSKUModel formData, BuildContext context, {bool isHttp = false}) async {


     final dio = DioClient.getDio(isHttp: isHttp);

       

    await EasyLoading.show(status: "Sedang menghapus sku");

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));

    Map<String, dynamic> deleteData = ({"idorder": formData.idorder});

    
    try {

      final response = await dio.post("/remove/rmorder",
        data: deleteData,
    );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Berhasil hapus sku",
            duration: const Duration(seconds: 3));
        EasyLoading.dismiss();
        emit(SuccessDeleteSku());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
    if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
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
