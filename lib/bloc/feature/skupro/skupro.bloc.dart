import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/skupro/skupro.state.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/database_offline/db.material.dart';
import 'package:traxes/model/skupro/skupro.model.dart';
import 'package:traxes/model/skupro/skupro.request.model.dart';

class SkuProBloc extends Cubit<SkuProState> {
  SkuProBloc() : super(SkuProLoading());

  void loadLocalSku() async {
    final response = await DBMaterialHelper().getSkuMaterial();

    try {
      if (kDebugMode) {
        print("respon local --> $response");
      }
      if (response.isNotEmpty) {
        emit(LoadLocalSku(response));
      } else {
        if (kDebugMode) {
          print("lari ke else --");
        }
        emit(LoadLocalSkuFailed());
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getSkuPro({SkuProRequestModel? formData, bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    EasyLoading.show(status: "Loading...");

    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? projectId = prefs.getString("emp_project");

    Map<String, dynamic> skuProRequest = {
      "projectid": projectId,
    };

    final response = await dio.post(
      "/download/skupro",
      data: skuProRequest,
    );

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Berhasil download material",
            duration: const Duration(seconds: 3));
        var resbody = SkuProModel.fromJson(response.data).data;

        if (resbody != null && resbody.isNotEmpty) {
          for (var i = 0; i < resbody.length; i++) {
            DBMaterialHelper().addMaterialData(DataSkuPro(
              secid: resbody[i].secid,
              kodeSku: resbody[i].kodeSku,
              namaMaterial: resbody[i].namaMaterial,
              materialType: resbody[i].materialType,
              category: resbody[i].category,
              project: resbody[i].project,
              brand: resbody[i].brand,
              variant: resbody[i].variant,
              uom: resbody[i].uom,
              price: resbody[i].price,
              poin: resbody[i].poin,
              volume: resbody[i].volume,
              createdat: resbody[i].createdat,
              createdby: resbody[i].createdby,
            ));
            emit(SkuProLoaded(resbody));
          }
        }
        if (kDebugMode) {
          print("ini resbody sku pro --> $resbody");
          print("inii project id --> $skuProRequest");
        } else {
          // Handle the case when resbody is null or empty
          emit(SkuProLoaded(
              const [])); // Emit an empty list or any other state as needed
          if (kDebugMode) {
            print("resbody is null or empty");
          }
        }
      }
    }

    on DioException catch (err) {
      EasyLoading.dismiss();
     if (err.type == DioExceptionType.sendTimeout || err.type == DioExceptionType.receiveTimeout || err.type == DioExceptionType.connectionTimeout) {
        EasyLoading.showError("Koneksi internet anda lambat. Coba lagi", duration: const Duration(seconds: 3));
        emit(SkuTimeOut());
      } else {
        EasyLoading.showError("Waktu menghubungkan ke server telah habis. silakan coba lagi.");
      }
      throw Exception(err);
    } 
    
    catch (err) {
      throw Exception(err);
    }
  }
}
