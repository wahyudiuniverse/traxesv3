import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';  // For date formatting
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/bloc/history/local_history_outlet/local.history.outlet.state.dart';
import 'package:traxes/constant/util/dio.mixin.dart';
import 'package:traxes/database_offline/db.customer.dart';
import 'package:traxes/model/history_outlet/history.outlet.model.dart';
import 'package:traxes/model/history_outlet/history.outlet.request.model.dart';

class LocalHistoryOutletBloc extends Cubit<LocalOutletState> {
  LocalHistoryOutletBloc() : super(LocalOutletLoading());

  final logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true
    )
  );

  void loadLocalOutlet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastSyncDate = prefs.getString('lastSyncDate');
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastSyncDate != currentDate) {
      // If it's a new day, clear the local database
      await DBCustomerHelper().deleteCustomerDB();  // Add a function to clear the database

      // Download new data
      await getLocalCustomer();

      // Save the current date as the last sync date
      prefs.setString('lastSyncDate', currentDate);
    } else {
      // If it's the same day, load from local DB
      final response = await DBCustomerHelper().getCustomer();
      try {
        if (response.isNotEmpty) {
          logger.i(response);
          emit(LocalOutletLoaded(response));
        }
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  // Function to download and store customer data
  Future<void> getLocalCustomer({HistoryOutletRequestModel? formData, bool isHttp = false,}) async {
    final dio = DioClient.getDio(isHttp: isHttp);
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retries: 1,
      retryDelays: const [
        Duration(seconds: 30),
      ],
    ));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("empid")?.isEmpty ?? true
        ? formData?.empid
        : prefs.getString("empid");

    Map<String, dynamic> dataHistory = ({
      "empid": empId,
      "latitude": formData?.latitude,
      "longitude": formData?.longitude
    });

    final response = await dio.post("/v2/customer/customerbyid", data: dataHistory);

    try {
      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Data outlet berhasil di download", duration: const Duration(seconds: 3));
        var resbody = HistoryOutletModel.fromJson(response.data).data;

        if (resbody != null && resbody.isNotEmpty) {
          await DBCustomerHelper().deleteCustomerDB();  // Clear before adding new data
          for (var i = 0; i < resbody.length; i++) {
            await DBCustomerHelper().addCustomerData(DataHistoryOutlet(
              customerId: resbody[i].customerId,
              customerName: resbody[i].customerName,
              address: resbody[i].address,
              latitude: resbody[i].latitude,
              longitude: resbody[i].longitude,
              villageId: resbody[i].villageId,
              vilName: resbody[i].vilName,
              districtId: resbody[i].districtId,
              distName: resbody[i].distName,
              cityId: resbody[i].cityId,
              cityName: resbody[i].cityName,
              dista: resbody[i].dista
            ));
          }
          emit(LocalOutletLoaded(resbody));
        }

        if (kDebugMode) {
          print("ini resbody sku pro --> $resbody");
          print("inii project id --> $dataHistory");
        }
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
