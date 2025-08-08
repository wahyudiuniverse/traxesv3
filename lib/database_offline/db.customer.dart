import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:traxes/model/history_outlet/history.outlet.model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DBCustomerHelper {

 String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  DBCustomerHelper();

  Future<Database> initializeCustomerDB() async {
    String path = await getDatabasesPath();
    String databasePath = join(path, 'customer.db');

    return openDatabase(databasePath, onCreate: (database, v) async {
      await database.execute("CREATE TABLE tx_customer ("
      "customer_id TEXT NOT NULL,"
      "customer_name TEXT NOT NULL,"
      "address TEXT NOT NULL,"
      "latitude TEXT NOT NULL,"
      "longitude TEXT NOT NULL,"
      "village_id TEXT NOT NULL,"
      "vil_name TEXT,"
      "district_id TEXT NOT NULL,"
      "dist_name TEXT,"
      "city_id TEXT NOT NULL,"
      "city_name TEXT,"
      "dista TEXT NOT NULL,"
      // "photo TEXT,"
      "date TEXT"
      ")");
      if(kDebugMode) {
        print("Table customer dibuat");
      }
    }, version: 1);
  }
  Future<int> addCustomerData(DataHistoryOutlet historyModel) async {
    final Database db = await initializeCustomerDB();
    final raw = await db.insert("tx_customer", {
      "customer_id": historyModel.customerId,
      "customer_name": historyModel.customerName,
      "address": historyModel.address,
      "latitude": historyModel.latitude,
      "longitude": historyModel.longitude,
      "village_id": historyModel.villageId,
      "vil_name": historyModel.vilName ?? "",
      "district_id": historyModel.districtId,
      "dist_name": historyModel.distName ?? "",
      "city_id": historyModel.cityId,
      "city_name": historyModel.cityName ?? "",
      "dista": historyModel.dista,
      // "photo": historyModel.photo ?? "",
      "date": historyModel.date ?? ""
    }, conflictAlgorithm: ConflictAlgorithm.replace
    );
    return raw;
  }

  Future<List<DataHistoryOutlet>> getCustomer() async {
    final Database db = await initializeCustomerDB();
    final List<Map<String, Object?>> query = await db.query("tx_customer");
    return query.map((e) => DataHistoryOutlet.fromJson(e)).toList();
  }

  Future<void> deleteCustomerDB() async {
    try {
      String path = 'customer.db';
      deleteDatabase(path);
    } catch (err){
      throw Exception(err);
    }
  }
}