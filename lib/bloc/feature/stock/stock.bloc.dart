// ignore_for_file: use_build_context_synchronously

import 'package:cool_alert/cool_alert.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/feature/stock/stock.state.dart';
import 'package:traxes/constant/env/config.url.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/constant/util/dialog.util.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/model/stock/stock.model.dart';
import 'package:traxes/model/stock/stock.request.model.dart';
import 'package:traxes/model/stock_update/stock.update.model.dart';

class StockBloc extends Cubit<StockState> {
  StockBloc() : super(StockLoading());

  static const int maxRetries = 3;
  CancelToken? _cancelToken;

  void getStock(
      {StockRequestModel? formData,
      required BuildContext context,
      bool isHttp = false,
      int retryCount = 0}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 10),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? customerid = prefs.getString("customerid").toString();
    String? projectid = prefs.getString("project_id").toString();
    String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    String? empId = prefs.getString("empid").toString();

    Map<String, dynamic> requestStock = ({
      "customer_id": customerid,
      "project_id": projectid,
      "stock_date": cdate,
      "employee_id": empId
    });

    try {
      final response = await dio.post(
        "/download/stocklistv2",
        data: requestStock,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var resbody = StockModel.fromJson(response.data).data;
        emit(StockLoaded(resbody!));
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
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
            }
          );
        }
      }
      throw Exception(err);
    } catch (err) {
      throw Exception(err);
    }
  }

  void updateStock(
      {UpdateStockModel? formData,
      required BuildContext context,
      bool isHttp = false,
      required VoidCallback onSuccess}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    Map<String, dynamic> updateStock = ({
      "material_id": formData!.materialId,
      "customer_id": formData.customerId,
      "stock_date": formData.stockDate,
      "stock_qty": formData.stockQty,
      "stock_out": formData.stockOut,
      "exp_date": formData.expDate
    });

    final response = await dio.post("/transaksi/updatestock",
        data: updateStock,
        options: Options(
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess();
        EasyLoading.showSuccess("Berhasil memperbarui stok",
            duration: const Duration(seconds: 3));
        emit(StockUpdated());
        if (kDebugMode) {
          print("data update --> $updateStock");
        }
        // EasyLoading.dismiss();
      }
    } on DioException catch (err) {
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
        DialogUtils().showRetryDialogSubmit(context);
      } else {
        DialogUtils().showRetryDialogSubmit(context);
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  void insertMaterial(
      {UpdateStockModel? formData,
      required BuildContext context,
      required VoidCallback onSuccess, bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);

    EasyLoading.show(status: "Loading...");

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? customerId = prefs.getString("customerid");
    String? employeeId = prefs.getString("empid");
    String? projectid = prefs.getString("project_id").toString();

    Map<String, dynamic> updateStock = ({
      "material_id": formData!.materialId,
      "customer_id": customerId,
      "employee_id": employeeId,
      "stock_date": formData.stockDate,
      "exp_date": formData.expDate,
      "stock_qty": formData.stockQty,
      "project_id": projectid
    });

    final response = await dio.post("/transaksi/insertstockv2",
        data: updateStock,
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess();
        EasyLoading.dismiss();
        prefs.setInt("stock", 1);
        if (kDebugMode) {
          print("inii data update stock --> $updateStock");
        }
        emit(InsertSuccess());
      }
    } on DioException catch (err) {
      EasyLoading.dismiss();
      if (err.type == DioExceptionType.sendTimeout ||
          err.type == DioExceptionType.receiveTimeout) {
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
                emit(StockLoading());
                Navigator.of(context).pop();
                getStock(context: context, retryCount: retryCount + 1);
              },
              child: const Text('Retry', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    ).then((_) {
      if (retryCount < maxRetries) {
        emit(StockLoading());
        getStock(
            context: context,
            retryCount: retryCount + 1); // Ensure retry on dialog close
      }
    });
  }

  @override
  Future<void> close() {
    _cancelToken?.cancel(); // Cancel the request if the bloc is closed
    return super.close();
  }
}
