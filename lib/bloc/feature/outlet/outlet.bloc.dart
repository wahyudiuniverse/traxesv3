// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/outlet/outlet.state.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/outlet/submit.outlet.model.dart';
import 'package:traxes/presentation/user/activity.screen.dart';

class OutletBloc extends Cubit<OutletState> {
  OutletBloc() : super(OutletLoading());

  void submitOutlet(SubmitOutletModel formData, BuildContext context, {bool isHttp = false}) async {

   final dio = DioClient.getDio(isHttp: isHttp);
    
      dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 5),
      ],
    ));
    var timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? empId = prefs.getString("empid").toString().isEmpty
        ? formData.createdby
        : prefs.getString("empid");
    await EasyLoading.show(status: "Tunggu sebentar yaaa....");

    Map<String, dynamic> submitOutlet = ({
      "customer_id": timeStamp,
      "customer_name": formData.customerName,
      "owner_name": formData.ownerName,
      "no_contact": formData.noContact,
      "address": formData.address,
      "village_id": formData.villageId,
      "district_id": formData.districtId,
      "city_id": formData.cityId,
      "latitude": formData.latitude,
      "longitude": formData.longitude,
      "category": formData.category,
      "photo": formData.photo,
      "createdby": empId,
    });


    
    try {
      final response = await dio.post("/transaksi/pushNoo",
        data: submitOutlet,
        );
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Berhasil menambah toko/outlet",
            duration: const Duration(seconds: 3));
        emit(OutletSubmitSuccess());
        if (kDebugMode) {
          print("data outlet --> $submitOutlet");
        }
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
