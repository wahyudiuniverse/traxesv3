import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/mbd/edit_mbd/edit.mbd.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/edit_mbd/edit.mbd.model.dart';
import 'package:get/get.dart' as gets;


class EditMbdBloc extends Cubit<EditMbdState> {
  EditMbdBloc() : super(EditMbdLoading());

  editMbd(EditMbdModel formData, BuildContext context, {bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    EasyLoading.show(status: "Sedang mengupdate status...");

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));


    SharedPreferences prefs = await SharedPreferences.getInstance();

    final verifyBy = prefs.getString("empid")?.isEmpty ?? true
        ? formData.secId
        : prefs.getString("empid");

    Map<String, dynamic> editMbd = {
      "sec_id": formData.secId,
      "verify_status": formData.verifyStatus,
      "verify_on": formData.verifyOn,
      "verify_by": verifyBy,
    };

    try {
      final response = await dio.post(
        "/transaksi/updatestatusmbd",
        data: editMbd,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.dismiss();
        emit(EditMbdSuccess());
       gets.Get.snackbar("Success", "Anda Berhasil Mengubah status MBD",
       colorText: Colors.white,
            snackPosition: gets.SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ));
      } else {
        gets.Get.snackbar("Gagal", "Something went wrong",
        colorText: Colors.white,
            snackPosition: gets.SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ));
      }
    } on DioException catch (err) {
      if (context.mounted) {
        if (err.type == DioExceptionType.sendTimeout ||
            err.type == DioExceptionType.connectionTimeout) {
          DialogUtils().showRetryDialogSubmit(context);
        } else {
          DialogUtils().showRetryDialogSubmit(context);
        }
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
