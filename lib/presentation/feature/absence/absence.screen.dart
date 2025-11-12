// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traxes/constant/screen/fake.gps.screen.dart';
import 'package:traxes/constant/widget/gradient.appbar.dart';
import 'package:traxes/constant/gps/location.dart';
import 'package:traxes/constant/text.style.dart';
import 'package:traxes/presentation/feature/absence/check-out/checkout.absence.screen.dart';
import 'package:traxes/presentation/feature/absence/check-in/history.outlet.screen.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  String? customerName;
  String? nik;
  String? customerId;
  String? address;
  Position? position;
  String? latToko;
  String? longToko;
  String? jabatan;
  String? projectId;
  bool hasCheckedIn = false;

  void callNik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nik = prefs.getString("empid").toString();
    });
  }

  void callJabatan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      jabatan = prefs.getString("jabatan").toString();
    });
  }

  void getCustomerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerName = prefs.getString("customerName").toString();
    });
  }

  void getCustomerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      customerId = prefs.getString("customerId").toString();
    });
  }

  void getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      address = prefs.getString("address").toString();
    });
  }

  void callProject() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      projectId = prefs.getString("emp_project").toString();
    });
  }

  void getLatToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      latToko = prefs.getString("latitudeToko").toString();
    });
  }

  void getLongToko() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      longToko = prefs.getString("longitudeToko").toString();
    });
  }

  Future<void> getCurrentLocation() async {
    position = await GetGeolocator().getCurrentLocation();

    // if (position!.isMocked) {
    //   Get.offAll(const FakeGPSWarningScreen());
    // }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((t) {
      getCurrentLocation();
    });
    getCurrentLocation();
    getCustomerName();
    getCustomerId();
    getAddress();
    getLatToko();
    callJabatan();
    getLongToko();
    callProject();
    checkFirstCheckInStatus();
  }

  void checkFirstCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastCheckInDate = prefs.getString("lastCheckInDate");

    DateTime today = DateTime.now();
    String formattedToday = DateFormat('yyyy-MM-dd').format(today);

    if (lastCheckInDate == null || lastCheckInDate != formattedToday) {
      prefs.setBool("hasCheckedIn", false);
      prefs.setString("lastCheckInDate", formattedToday);
      setState(() {
        hasCheckedIn = false;
      });
    } else {
      setState(() {
        hasCheckedIn = prefs.getBool("hasCheckedIn") ?? false;
      });
    }
  }

  void setFirstCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("hasCheckedIn", true);
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    DateTime checkinDeadline = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 10, 0, 0);
    bool isAfterDeadline = currentTime.isAfter(checkinDeadline);

    return Scaffold(
      appBar: GradientAppBar(
        title: Text("Visit Screen", style: standarWhiteTextB),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 55, top: 110),
                child: GestureDetector(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    var checkCheckin = prefs.getInt("getIn");

                    if (jabatan == "SALES SUPPORT" && !hasCheckedIn && isAfterDeadline) {
                      CoolAlert.show(
                          backgroundColor: const Color(0xFFFFFFFF),
                          title:
                              "Maaf, Sales Support tidak bisa check-in diatas jam 10",
                          confirmBtnColor: const Color(0xFF661C63),
                          confirmBtnText: "Kembali",
                          confirmBtnTextStyle: smallWhiteText,
                          titleTextStyle: standarBlackText,
                          context: context,
                          type: CoolAlertType.error);
                    } else if (checkCheckin == 1) {
                      CoolAlert.show(
                          backgroundColor: const Color(0xFFFFFFFF),
                          title: "Check-out terlebih dahulu",
                          confirmBtnColor: const Color(0xFF661C63),
                          confirmBtnText: "Kembali",
                          confirmBtnTextStyle: smallWhiteText,
                          titleTextStyle: standarBlackText,
                          context: context,
                          type: CoolAlertType.error);
                    } else {
                      setFirstCheckInStatus(); // Set status check-in pertama
                      Get.to(const HistoryOutletScreen());
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF50D5B7), // Start color
                              Color(0xFF067D68), // End color
                            ],
                          ),
                        ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.login,
                                  size: 60,
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "Check-in",
                                  style: standarWhiteText,
                                )
                              ],
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                         var checkCheckin = prefs.getInt("getIn");
                  int? checkOrder = prefs.getInt("check_order");
                  int? isOrder = prefs.getInt("order");
                  int? checkStock = prefs.getInt("check_stock");
                  int? isStock = prefs.getInt("stock");
                   if (projectId == "47" && checkOrder != 1 && isOrder != 1) {
                    EasyLoading.showError(
                      "Isi data penjualan hari ini terlebih dahulu!",
                      duration: const Duration(seconds: 3),
                    );
                  } else if (projectId == "38" && checkStock != 1 && isStock != 1 ) {
                     EasyLoading.showError(
                        "Isi data stock hari ini terlebih dahulu!",
                        duration: const Duration(seconds: 3));
                  } else if (checkCheckin != 1) {
                     CoolAlert.show(
                          backgroundColor: const Color(0xFFFFFFFF),
                          title: "Check-in terlebih dahulu",
                          confirmBtnColor: const Color(0xFF661C63),
                          confirmBtnText: "Kembali",
                          confirmBtnTextStyle: smallWhiteText,
                          titleTextStyle: standarBlackText,
                          context: context,
                          type: CoolAlertType.error);
                  }
                  
                   else {
                    Get.to(CheckOutAbsenceScreen(
                      alamat: address,
                      customerId: customerId,
                      toko: customerName,
                      latToko: latToko,
                      longToko: longToko,
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100, top: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE65758), // Start color
                            Color(0xFF771D32), // End color
                          ],
                        ),
                      ),
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.logout_rounded,
                                size: 60,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Text("Check-out", style: standarWhiteText)
                            ],
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
