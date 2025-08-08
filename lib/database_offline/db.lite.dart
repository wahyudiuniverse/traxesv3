import 'package:sqflite/sqflite.dart';
// ignore: unused_import
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:traxes/model/login/employee.model.dart';

class DBHelper {
  DBHelper();

  DBHelper.createObject();

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();

    return openDatabase(join(path, 'databases.db'),
        onCreate: (database, v) async {
      await database.execute("CREATE TABLE cakrawalaa ("
          "employee_id TEXT NOT NULL,"
          "fullname TEXT NOT NULL,"
          "server_env TEXT NOT NULL,"
          "type_id TEXT NOT NULL,"
          "project_id TEXT NOT NULL,"
          "company_id TEXT,"
          "area_id TEXT NOT NULL,"
          "area_id_extra1 TEXT,"
          "area_id_extra2 TEXT"
          ")");
    }, version: 1);
  }

  Future<int> addData(DataEmployee employeeModel) async {
    final Database db = await initializeDB();
    final raw = await db.insert(
        "cakrawalaa",
        {
          "employee_id": employeeModel.employeeId,
          "fullname": employeeModel.fullname,
          "server_env": employeeModel.serverEnv,
          "type_id": employeeModel.typeId,
          "project_id": employeeModel.projectId,
          "company_id": employeeModel.companyId,
          "area_id": employeeModel.areaId,
          "area_id_extra1": employeeModel.areaIdExtra1,
          "area_id_extra2": employeeModel.areaIdExtra2
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
    getEmployee();
    return raw;
  }

  Future<List<DataEmployee>> getEmployee() async {
    final db = await initializeDB();
    final List<Map<String, Object?>> query =
        await db.query("cakrawalaa", limit: 1);
    return query.map((e) => DataEmployee.fromJson(e)).toList();
  }

  Future<void> deleteDB() async {
    try {
      String path = 'databases.db';
      deleteDatabase(path);
    } catch (err) {
      throw Exception(err);
    }
  }
}
