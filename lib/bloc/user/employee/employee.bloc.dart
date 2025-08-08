
import 'package:android_id/android_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/database_offline/db.lite.dart';
import 'package:traxes/model/login/employee.model.dart';
import 'package:traxes/model/login/login.employee.model.dart';
import 'package:traxes/presentation/dashboard/dashboard.screen.dart';

class EmployeeBloc extends Cubit<EmployeeState> {
  EmployeeBloc() : super(EmployeeLoading());

  void employeeLoad() async {
    final response = await DBHelper().getEmployee();
    try {
      if (response.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("empid", response[0].employeeId.toString());
        emit(EmployeeLoaded
        (response));
      } else {
        emit(EmployeeNotLoaded());
      }
    } catch (e) {
      emit(EmployeeNotLoaded());
    }
  }

  void loginEmployee(
      {required LoginModel formData,
      required VoidCallback onSuccess,
      bool isHttp = false,
      required Function(String bodyMessage) onFailed}) async {
      await EasyLoading.show(status: "Loading...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));
    const androidPlugin = AndroidId();
    var db = DBHelper();
    final String? androidId = await androidPlugin.getId();
    String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String currentVersion = packageInfo.version + packageInfo.buildNumber;

    Map<String, dynamic> dataDTO = ({
      "nik": formData.nik,
      "deviceID": androidId,
      "logindt": date,
      "apk_version": currentVersion
    });

    try {
      final response = await dio.post("/user/login",
          data: dataDTO,
          options: Options(headers: {"Content-Type": "application/json"}));
      var bodyStatus = ResponseEmployeeModel.fromJson(response.data).status;
      var bodyMessage = ResponseEmployeeModel.fromJson(response.data).message;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (bodyStatus == 9 || bodyStatus == 1) {
          onSuccess();
          EasyLoading.showSuccess(bodyMessage.toString(),
              duration: const Duration(seconds: 3));
          prefs.setBool("login", true);

          var resbody = ResponseEmployeeModel.fromJson(response.data).data;

          (resbody!.toJson());

          db
              .addData(DataEmployee(
                  employeeId: resbody.employeeId,
                  fullname: resbody.fullname,
                  serverEnv: resbody.serverEnv,
                  typeId: resbody.typeId,
                  projectId: resbody.projectId,
                  projectName: resbody.projectName,
                  companyId: resbody.companyId,
                  areaId: resbody.areaId,
                  areaIdExtra1: resbody.areaIdExtra1,
                  areaIdExtra2: resbody.areaIdExtra2))
              .then((value) => {
                    if (value != 0)
                      {
                        Get.offAll(
                            const DashboardScreen())
                      }
                    else
                      {onFailed(bodyMessage.toString())}
                  });

          prefs.setString("empid", resbody.employeeId.toString());
          prefs.setString("jabatan", resbody.typeId.toString());
          prefs.setString("emp_project", resbody.projectId.toString());
          prefs.setString("nama", resbody.fullname.toString());
        } else {
          EasyLoading.dismiss();
          onFailed(bodyMessage.toString());
          DBHelper().deleteDB();
        }
      } else {
        EasyLoading.showError(
            "Login gagal. Status kode: ${response.statusCode}",
            duration: const Duration(seconds: 5));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        EasyLoading.showError("Koneksi internet anda lambat. Coba lagi");
      } else {
        EasyLoading.showError(
            "Waktu menghubungkan ke server telah habis. silakan coba lagi");
      }
      throw Exception(err);
    } catch (err) {
      EasyLoading.showError("Gagal login, periksa koneksi internet anda",
          duration: const Duration(seconds: 3));
    }
  }
}
