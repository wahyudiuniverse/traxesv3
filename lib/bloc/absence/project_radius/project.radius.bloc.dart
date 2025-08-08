// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/absence/project_radius/project.radius.state.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/project_radius/project.radius.request.model.dart';
import 'package:traxes/model/project_radius/project.radius.response.model.dart';

class ProjectRadiusBloc extends Cubit<ProjectRadiusState> {
  ProjectRadiusBloc() : super(ProjectRadiusLoading());

  static const int maxRetries = 3;

  void getProjectRadius({
    ProjectRadiusRequestModel? formData,
    required BuildContext context,
    int retryCount = 0,
    bool isHttp = false, 
  }) async {
    var dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? projectid = prefs.getString("emp_project").toString();
    Map<String, dynamic> projectData = ({"project_id": projectid});

    try {
      final response = await dio.post("/download/projectradius", data: projectData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = ProjectRadiusResponseModel.fromJson(response.data).data;
        emit(ProjectRadiusSuccess(resbody!));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();

      if (err.type == DioExceptionType.badCertificate && !isHttp) {
        getProjectRadius(context: context, retryCount: retryCount, isHttp: true);
      } else if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.connectionTimeout) {
        if (retryCount < maxRetries) {
          showRetryDialog(context, retryCount);
        } else {
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            title: "Error",
            text: "Max retry attempts reached. Please check your internet connection.",
            confirmBtnText: "Kembali",
            onConfirmBtnTap: () {
              Navigator.pop(context);
            });
        }
      } else {
        throw Exception(err);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  void showRetryDialog(BuildContext context, int retryCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Timeout', style: largeBlackText),
          content: Text('Connection timed out. Do you want to retry?',
              style: standarBlackTextB),
          actions: [
            TextButton(
              onPressed: () {
                emit(ProjectRadiusLoading());
                Navigator.of(context).pop();
                getProjectRadius(context: context, retryCount: retryCount + 1);
              },
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    ).then((_) {
      if (retryCount < maxRetries) {
        emit(ProjectRadiusLoading());
        getProjectRadius(context: context, retryCount: retryCount + 1);
      }
    });
  }
}
