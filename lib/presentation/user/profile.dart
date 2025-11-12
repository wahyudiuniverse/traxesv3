import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:traxes/bloc/user/employee/employee.bloc.dart';
import 'package:traxes/bloc/user/employee/employee.state.dart';
import 'package:traxes/constant/screen/download.sku.dart';
import 'package:traxes/constant/sharedprefs.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/database_offline/db.customer.dart';
import 'package:traxes/database_offline/db.lite.dart';
import 'package:traxes/database_offline/db.material.dart';
import 'package:traxes/presentation/user/login.employee.screen.dart';


/// Widget utama yang menampilkan layar profil pengguna.
/// Ia mendengarkan (listen) state dari EmployeeBloc untuk mengambil data karyawan.
class ProfileScreen extends StatelessWidget {
 const ProfileScreen({super.key});

 /// Membangun tampilan utama layar profil.
 /// Jika state adalah EmployeeLoaded, ia menampilkan ProfileContent.
 /// Jika tidak, ia menampilkan CircularProgressIndicator.
 @override
 Widget build(BuildContext context) {
  return BlocBuilder<EmployeeBloc, EmployeeState>(
   builder: (context, stateEmployee) {
    if (stateEmployee is EmployeeLoaded) {
     // Mengambil data karyawan pertama dari list data
     var employee = stateEmployee.data[0];
     return ProfileContent(
      fullname: employee.fullname.toString(),
      typeId: employee.typeId.toString(),
      employeeId: employee.employeeId.toString(),
      projectId: employee.projectId.toString(),
      projectName: employee.projectName.toString(),
     );
    } else {
     return const Center(
      child: CircularProgressIndicator(),
     );
    }
   },
  );
 }
}

/// Widget yang menampilkan detail konten profil karyawan.
class ProfileContent extends StatelessWidget {
 final String fullname;
 final String typeId;
 final String employeeId;
 final String projectId;
 final String projectName;

 /// Konstruktor untuk ProfileContent.
 /// Membutuhkan data detail karyawan.
 const ProfileContent({
  super.key,
  required this.fullname,
  required this.typeId,
  required this.employeeId,
  required this.projectId,
  required this.projectName,
 });

 /// Membangun layout visual dari konten profil.
 @override
 Widget build(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
   child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    child: Column(
     crossAxisAlignment: CrossAxisAlignment.center,
     mainAxisAlignment: MainAxisAlignment.start,
     children: <Widget>[
      const SizedBox(height: 50),
      const CircleAvatar(
       radius: 60,
       backgroundImage: AssetImage('assets/images/punk-image.jpg'),
      ),
      const SizedBox(height: 12),
      Text(
       fullname,
       style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
       ),
      ),
      Text(
       typeId,
       style: TextStyle(
        fontSize: 16,
        color: Color(0xFF737A87),
       ),
      ),
      const SizedBox(height: 30),
      // Card untuk menampilkan detail NIP, Project ID, dan Company
      Card(
       elevation: 0,
       color: const Color(0xFFFFFFFF),
       shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
       ),
       child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
         children: <Widget>[
          ProfileDetailRow(
           label: 'NIP',
           value: employeeId,
          ),
          const Divider(color: Color(0xFFF5F6F7), height: 1),
          ProfileDetailRow(
           label: 'Project ID',
           value: projectId,
          ),
          const Divider(color: Color(0xFFF5F6F7), height: 1),
          ProfileDetailRow(
           label: 'Company',
           value: projectName,
          ),
         ],
        ),
       ),
      ),
      // Pindahkan DownloadMaterialCard ke sini, setelah Card detail.
      SizedBox(height: screenHeight * 0.020), // Tambahkan sedikit jarak
      const DownloadMaterialCard(), // TOMBOL DOWNLOAD DATA DIPINDAHKAN
      // Awalnya ada di bawah Spacer()
      const Spacer(), 
      // SizedBox(height: screenHeight * 0.020), // Jarak ini sudah ada di atas
      const LogoutCard(),
     ],
    ),
   ));
 }
}

/// Widget kartu yang berfungsi sebagai tombol untuk mengunduh data.
class DownloadMaterialCard extends StatelessWidget {
 const DownloadMaterialCard({super.key});

 /// Membangun tampilan kartu unduh data.
 /// onTap akan menavigasi ke DownloadSkuScreen.
 @override
 Widget build(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.symmetric(horizontal: 10),
   child: InkWell(
    onTap: () {
     Get.to(const DownloadSkuScreen());
    },
    child: Container(
     padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
     decoration: BoxDecoration(
      color: const Color(0xFFE0EBFB),
      borderRadius: BorderRadius.circular(5),
     ),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Icon(Icons.file_download_outlined, color: Color(0xFF0D6EFD),),
       const SizedBox(width: 10),
       Text('Download Data', style: smallTextBlue),
      ],
     ),
    ),
   ),
  );
 }
}

/// Widget kartu yang berfungsi sebagai tombol untuk Logout.
class LogoutCard extends StatelessWidget {
 const LogoutCard({super.key});

 /// Membangun tampilan kartu Logout.
 @override
 Widget build(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.symmetric(horizontal: 10),
   child: InkWell(
    onTap: () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      DBHelper().deleteDB();
      DBMaterialHelper().deleteMaterialDB();
      DBCustomerHelper().deleteCustomerDB();
      LocalStorage.clear();
      EasyLoading.showSuccess("Berhasil Logout", duration: const Duration(seconds: 3));
      Get.offAll(const LoginEmployeeScreen());
    },
    child: Container(
     padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
     decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5),
     ),
     child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
       const Icon(Icons.logout, color: Colors.white,),
       const SizedBox(width: 10),
       Text('Logout', style: smallTextWhite),
      ],
     ),
    ),
   ),
  );
 }
}

/// Widget baris yang menampilkan detail label dan nilai.
class ProfileDetailRow extends StatelessWidget {
 final String label;
 final String value;

 /// Konstruktor untuk ProfileDetailRow.
 /// Membutuhkan label (kiri) dan value (kanan).
 const ProfileDetailRow({
  required this.label,
  required this.value,
  super.key,
 });

 /// Membangun tampilan baris detail (Label di kiri, Value di kanan).
 @override
 Widget build(BuildContext context) {
  return Padding(
   padding: const EdgeInsets.symmetric(vertical: 12.0),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
     // Sisi kiri: Label
     Text(
      label,
      style: TextStyle(
       fontSize: 16,
       color: Color(0xFF828894),
      ),
     ),
     // Sisi kanan: Nilai (bold)
     Text(
      value,
      style: const TextStyle(
       fontSize: 16,
       fontWeight: FontWeight.bold,
      ),
     ),
    ],
   ),
  );
 }
}