import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
import 'package:traxes/model/skupro/skupro.model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';


class DBMaterialHelper {
  DBMaterialHelper();

   Future<Database> initializeMaterialDB() async {
  String path = await getDatabasesPath();
  String databasePath = join(path, 'material.db');
  if (kDebugMode) {
    print('Database path: $databasePath');
  }
  
  return openDatabase(databasePath, onCreate: (database, v) async {
    if (kDebugMode) {
      print('Creating table sku_material...');
    }
    await database.execute("CREATE TABLE sku_material ("
        "sec_id TEXT NOT NULL,"
        "kode_sku TEXT NOT NULL,"
        "nama_material TEXT NOT NULL,"
        "material_type TEXT NOT NULL,"
        "category TEXT NOT NULL,"
        "project TEXT NOT NULL,"
        "brand TEXT NOT NULL,"
        "variant TEXT NOT NULL,"
        "uom TEXT NOT NULL,"
        "price TEXT NOT NULL,"
        "price_sell TEXT,"
        "poin TEXT,"
        "volume TEXT,"
        "is_active TEXT,"
        "createdat TEXT NOT NULL,"
        "createdby TEXT"
        ")");
    if (kDebugMode) {
      print('Table sku_material created successfully.');
    }
  }, version: 1);
}

Future<int> addMaterialData(DataSkuPro? skuModel) async {
  final Database db = await initializeMaterialDB();
  final raw = await db.insert("sku_material", {
    "sec_id": skuModel!.secid,
    "kode_sku": skuModel.kodeSku,
    "nama_material": skuModel.namaMaterial,
    "material_type": skuModel.materialType,
    "category": skuModel.category,
    "project": skuModel.project,
    "brand": skuModel.brand,
    "variant": skuModel.variant,
    "uom": skuModel.uom,
    "price": skuModel.price,
    "price_sell": skuModel.priceSell,
    "poin": skuModel.poin,
    "volume": skuModel.volume,
    "is_active": skuModel.isActive,
    "createdat": skuModel.createdat,
    "createdby": skuModel.createdby
  }, conflictAlgorithm: ConflictAlgorithm.replace);
  return raw;
}

Future<List<DataSkuPro>> getSkuMaterial() async {
  final Database db = await initializeMaterialDB();
  final List<Map<String, Object?>> query = await db.query("sku_material");
  return query.map((e) => DataSkuPro.fromJson(e)).toList();
}

Future<List<DataSkuPro>> searchMaterialByName(String keyword) async {
  final Database db = await initializeMaterialDB();

  final List<Map<String, dynamic>> result = await db.rawQuery(
   "SELECT * FROM sku_material WHERE nama_material LIKE '%$keyword%'",
  );

  return result.map((json) => DataSkuPro.fromJson(json)).toList();
}

Future<int?> getTotalRows(String project) async {
  final Database db = await initializeMaterialDB();
  final List<Map<String, dynamic>> queryResult = await db.rawQuery("SELECT count(*) as total FROM sku_material WHERE project = ?", [project]);
  return Sqflite.firstIntValue(queryResult);
}

   Future<void> deleteMaterialDB() async {
    try {
      String path = 'material.db';
      deleteDatabase(path);
    } catch (err) {
      throw Exception(err);
    }
  }
}
