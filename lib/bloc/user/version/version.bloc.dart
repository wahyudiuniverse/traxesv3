import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:traxes/bloc/user/version/version.state.dart';
import 'package:traxes/constant/env/config.url.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/model/version/version.request.model.dart';

class VersionBloc extends Cubit<VersionState> {
  VersionBloc() : super(VersionLoading());

  static const int maxRetries = 3;

  void sendVersion({required String version, int retryCount = 0, required BuildContext context}) async {
    String? versionApp;

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;

    versionApp = version;

    final dio = Dio();
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));
    var baseUrl = url;

    Map<String, dynamic> versionData = ({"version": versionApp});

    final response = await dio.post("$baseUrl/user/version",
        data: versionData,
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }));

    try {
      var bodyStatus = ResponseVersionModel.fromJson(response.data).status;
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print("status body --> $bodyStatus");
        }
        if (bodyStatus == 0) {
          emit(UpdateNotification("New Update is available, go for it!"));
        }
      } 
    } on DioException catch (err) {
      if(err.type == DioExceptionType.connectionTimeout || err.type == DioExceptionType.sendTimeout) {
        if (retryCount < maxRetries) {
          if(context.mounted) {
            showRetryDialog(context, retryCount, version);
          }
        } else {
          if(context.mounted) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Error",
              text:
                  "Max retry attempts reached. Please check your internet connection.",
              confirmBtnText: "Kembali",
              onConfirmBtnTap: () {
                Navigator.pop(context);
              });
          }
          
        }
      }
    } catch (err) {
      throw Exception(err);
    }

    
  }

  void showRetryDialog(BuildContext context, int retryCount, version) {
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
                emit(VersionLoading());
                Navigator.of(context).pop();
                sendVersion(version:version, context: context, retryCount: retryCount + 1);
              },
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    ).then((_) {
      if (retryCount < maxRetries) {
        emit(VersionLoading());
        sendVersion(
          version: version,
            context: context,
            retryCount: retryCount + 1); // Ensure retry on dialog close
      }
    });
  }
}
